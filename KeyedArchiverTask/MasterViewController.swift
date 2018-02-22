//
//  MasterViewController.swift
//  KeyedArchiverTask
//
//  Created by Robert Berry on 2/21/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // MARK: Properties
    
    var fileName = "pizza.bin"
    
    // filePath locates the file path that will be saved to. Data will be saved to pizza.bin which will be in the documents directory.
    
    var filePath: String? {
        
        do {
            
            let fileManager = FileManager.default
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let savePath = documentDirectory.appendingPathComponent(fileName)
            
            return savePath.path
        
        } catch {
            
            print("Error getting file path.")
            return nil
        }
    }

    var detailViewController: DetailViewController? = nil
    var objects = [Pizza]()
    
    // Constants to represent different pizza options.
    
    let pizzaSize = ["Small", "Medium", "Large", "Extra Large"]
    let meats = ["Chicken", "Pepperoni", "Beef", "Bacon", "Sausage"]
    let veggies = ["Mushrooms", "Green Olives", "Tomatoes", "Pineapple", "Onions", "Olives", "Peppers"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
       
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        
        super.viewWillAppear(animated)
        
        // Unarchives data from the file and populates the pizza array with the data. 
        
        if let path = filePath {
            
            if let array = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [Pizza] {
                
                objects = array
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        
        // Select random pizza items from arrays that were previously initialized.
        
        let randomPizzaSize = pizzaSize[Int(arc4random_uniform(UInt32(pizzaSize.count)))]
        let randomMeats = meats[Int(arc4random_uniform(UInt32(meats.count)))]
        let randomVeggies = veggies[Int(arc4random_uniform(UInt32(veggies.count)))]
        
        // Initialize Pizza object with random array values.
        
        objects.insert(Pizza(pizzaSize: randomPizzaSize, meats: randomMeats, veggies: randomVeggies), at: 0)
        
        if let path = filePath {
            
            // Persists entire object graph.
            
            NSKeyedArchiver.archiveRootObject(objects, toFile: path)
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] 
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            
            // When an item is deleted, the modified objects array will be saved.
            
            if let path = filePath {
                
                NSKeyedArchiver.archiveRootObject(objects, toFile: path)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

