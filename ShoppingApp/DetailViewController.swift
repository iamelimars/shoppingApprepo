//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by iMac on 6/25/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
import Moltin

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailPriceLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            //Set the product title
            let productTitle = detail["title"] as? String
            if let title = productTitle {
                self.detailTitleLabel?.text = title;
            }
            //set the description title
            let productDescription = detail["description"] as? String
            if let desc = productDescription {
                self.detailDescriptionLabel?.text = desc
            }
            
            //set price label
            let productPrice = detail.valueForKeyPath("price.value") as? String
            if let price = productPrice {
                self.detailPriceLabel?.text = price
            }
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addToCartTapped(sender: UIButton) {
        
        //Get the current Product Id
        let productid = self.detailItem?["id"] as? String
        
        if let id = productid {
            
        
        //Add the product to the cart
        
        Moltin.sharedInstance().cart.insertItemWithId(id,
                                                      quantity: 1,
                                                      andModifiersOrNil: nil,
                                                      success: { (responseDictionary) in
                                                       //Display message to user saying that an item  has been addded to the cart

                                                        let alert = UIAlertController(title: "Added To Cart!!", message: "Added Item To Cart", preferredStyle: UIAlertControllerStyle.Alert)
                                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                                                        
                                                        self.presentViewController(alert, animated: true, completion: nil)
            },
                                                      failure: { (responseDictionary, error) in
                                                        
                                                        //Couldnt Add product to cart
                                                        print("Something went wrong");
        })
            
        
        }
        
        
    }

}

