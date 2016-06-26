//
//  MasterViewController.swift
//  ShoppingApp
//
//  Created by iMac on 6/25/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
import Moltin

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let checkoutButton = UIBarButtonItem(title: "Checkout!!", style: UIBarButtonItemStyle.Plain, target: self, action: "checkout");
        
        self.navigationItem.rightBarButtonItem = checkoutButton
        
        Moltin.sharedInstance().setPublicId("vjA7hGXCc7GAgvIpaYUdAzv7VYMp5HZiJkCOwwlX6K")

        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //Make  a call to retrieve the store products
        Moltin.sharedInstance().product.listingWithParameters(nil, success: { (responseDictionary) in
            
            //Assign  products array to our objects property
            self.objects = responseDictionary["result"] as! [AnyObject]
            
            //Tell th tableView to looad its data
            self.tableView.reloadData()
            
            
            }) { (responseDictionary, error) in
                print("Something went wrong")
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    //MARK: - Checkout methods
    
    func checkout(){
        //Hardcode the order data. In a real app, you would gather this data from the using a bunch of textfields and labels
        let orderParameters = [
            "customer": ["first_name": "Jon",
                "last_name":  "Doe",
                "email":      "jon.doe@gmail.com"],
            
            "shipping": "free-shipping",
            
            "gateway": "dummy",
            
            "bill_to": ["first_name": "Jon",
                "last_name":  "Doe",
                "address_1":  "123 Sunny Street",
                "address_2":  "Sunnycreek",
                "city":       "Sunnyvale",
                "county":     "California",
                "country":    "US",
                "postcode":   "CA94040",
                "phone":     "6507123124"],
            
            "ship_to": "bill_to"
            ] as [NSObject: AnyObject]
        
        
        
        
        
        //Create an Order
        Moltin.sharedInstance().cart.orderWithParameters(orderParameters, success: { (responseDictionary) in
            
            
            
                    //Get the order ID

        let orderId = (responseDictionary as NSDictionary).valueForKeyPath("result.id") as? String
        
        if let oid = orderId {
            
            //Hardcode the credit card details. Ina a real app you would gather  thjis in a user form
            let paymentParameters = ["data": [
            "number":       "4242424242424242",
            "expiry_month": "02",
            "expiry_year":  "2017",
            "cvv":          "123"
            ]] as [NSObject: AnyObject]
            
            
            //Process the payment
            Moltin.sharedInstance().checkout.paymentWithMethod("purchase", order: oid, parameters: paymentParameters, success: { (responseDictionary) in
                
                let alert = UIAlertController(title: "Order Complete!", message: "Your order is complete and your payment has been processed! Thank you for shopping with us!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)

                
                }, failure: { (responseDictionary, error) in
                    print("Couldnt process the payment")
            })
            
            
        }
        
        
            }) { (responseDictionary, error) in
                print("Couldnt create the order")
        }

        
        
        
    }
    
    
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = objects[indexPath.row] as! NSDictionary
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row] as! [String:AnyObject]
        cell.textLabel!.text = object["title"] as? String
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

