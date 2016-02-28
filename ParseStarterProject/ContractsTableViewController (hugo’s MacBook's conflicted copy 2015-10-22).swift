//
//  ContractsTableViewController.swift
//  BasicParse
//
//  Created by hugo roman on 10/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Foundation
import Parse

class ContractsTableViewController: UITableViewController {
    
    // MARK: Properties
    var Contracts: [Contract] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create and set the logout button */
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: "logoutButtonTouchUp")
    }
        
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let queryCompany = PFQuery(className:"Company")
        queryCompany.getObjectInBackgroundWithId("SN58QXPU6Q") {
            (myCompany: PFObject?, error: NSError?) -> Void in
            if error == nil && myCompany != nil {
                let queryContract = PFQuery(className:"Contract")
                queryContract.whereKey("CompanyId", equalTo: myCompany!)
                queryContract.findObjectsInBackgroundWithBlock {
                    (myContractsObject:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        if let myContracts = myContractsObject {
                            for unitContract in myContracts
                            {
                                let id = unitContract.objectId! 
                                let name = unitContract["Name"] as! String
                                _ = unitContract["CompanyId"].objectId
                                self.Contracts.append(Contract(idIn: id, companyIdIn: id, nameIn: name) )
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView.reloadData()}
                        }
                    } else {
                        print(error) // at this point the value = 1
                    }
                }
            } else {
                print("error")
            }
        }

    }
    
    // MARK: UITableViewController
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("contractCell", forIndexPath: indexPath)
        cell.textLabel?.text = Contracts[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contracts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /* Push the movie detail view */
//        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
//        controller.movie = movies[indexPath.row]
//        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: Logout
    
    func logoutButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
