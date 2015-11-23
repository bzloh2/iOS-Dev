//
//  ViewController.swift
//  CandyAnalyzer
//
//  Created by Brian Loh on 11/5/15.
//  Copyright © 2015 Brian Loh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var candyData = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCoreData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Add New Candy", message: "Add a new type of candy", preferredStyle: .Alert)
        let AddNewCandyAction = UIAlertAction(title: "Add", style: .Default) {(action) -> Void in let textField = alert.textFields!.first!
            
            //0 because we don't know if we have any of this candy yet.
            self.saveCandy(named: textField.text!,number: 0)
            
            self.tableView.reloadData() //make sure the new candy shows up on-screen
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(AddNewCandyAction)
        alert.addAction(cancelAction)
        
        //add a text field to the alert so we can type out a new name for the new candy
        alert.addTextFieldWithConfigurationHandler(nil)
        presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func saveCandy(named name: String, number: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Candy", inManagedObjectContext: managedContext)!
        let candy = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext)
        
        candy.setValue(name, forKey: "name")
        candy.setValue(number, forKey: "numberEaten")
        
        // save the new candy
        do{
            try managedContext.save()
            candyData.append(candy)
            
        }
        catch let error as NSError{
            print("Could not save: \(error)")
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        let candy = candyData[indexPath.row]
        cell.textLabel?.text = candy.valueForKey("name") as? String
        let numberEaten = candy.valueForKey("numberEaten") as? Int
        cell.detailTextLabel?.text = "\(numberEaten!)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candyData.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let candy = candyData[indexPath.row]
        //add one piece of candy
        let numberEaten = candy.valueForKey("numberEaten") as? Int
        candy.setValue(numberEaten! + 1, forKey: "numberEaten")
        // without this, the candy the user tapped would stay gray 
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // show the new number on-screen
        tableView.reloadData()
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            managedContext.deleteObject(candyData[indexPath.row])
            do {
               try managedContext.save()
            }
            catch{}
            
            
           // candyData.removeAtIndex(indexPath.row)
            reloadCoreData()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            tableView.reloadData()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func reloadCoreData(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Candy")
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            candyData = results as! [NSManagedObject]
            
        }
        catch let error as NSError {
            print("Unable to fetch: \(error)")
        }

    }

}

