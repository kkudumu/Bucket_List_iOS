//
//  ViewController.swift
//  Bucket List 2
//
//  Created by Kioja Kudumu on 11/3/17.
//  Copyright © 2017 Kioja Kudumu. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {

    var items = [BucketListItem]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Number of rows that the app needs - determined by our array of items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    //create a cell for each row that we specified in numberofrows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text!
        return cell
    }
    
    // shows us what happens when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
    }
    
    //Edit button functionality
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    //Swipe to Delete function (commit editingstyle)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        managedObjectContext.delete(item)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //prepares for the segues in the app
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
        addItemTableViewController.delegate = self
        
        if sender is NSIndexPath {
            let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            
            addItemTableViewController.item = item.text!
            addItemTableViewController.indexPath = indexPath
        }
    }
    
    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        
        do {
        let result = try managedObjectContext.fetch(request)
        items = result as! [BucketListItem]
        } catch {
            print("\(error)")
        }
    }
    
    //cancel button functionality
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //functionaly for saving and appending items to the table
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        
        if let ip = indexPath {
            let item = items[ip.row]
            item.text = text
        } else {
        let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
            item.text = text
        items.append(item)
            
        }
        do {
          try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

