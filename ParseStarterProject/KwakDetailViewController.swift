
//  KwakDetailViewController.swift
//  testTutti
//
//  Created by hugo roman on 10/25/15.
//  Copyright © 2015 hugo roman. All rights reserved.
//

import UIKit
import MapKit
import Parse

class KwakDetailViewController: UIViewController 
{
    var mySucursal: PFObject!
    
    @IBOutlet weak var enMesonLabel: UILabel!
    
    @IBOutlet weak var sucursalLabel: UILabel!
    
    @IBOutlet weak var enCajaLabel: UILabel!
    
    @IBOutlet weak var enMesonStepper: UIStepper!

    @IBOutlet weak var enCajaStepper: UIStepper!
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        //saving all data
        self.mySucursal["lastPeopleAtCashier"] = Int(self.enCajaLabel.text!)!
        self.mySucursal["lastPeopleAtCustomerService"] = Int(self.enMesonLabel.text!)!
        self.mySucursal.saveInBackground()
        
        self.saveAnnotationInParse(Int(self.enMesonLabel.text!)!, positionType: "MESON", objectId: self.mySucursal)
        self.saveAnnotationInParse(Int(self.enCajaLabel.text!)!, positionType: "CAJA", objectId: self.mySucursal)
        print("done")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func enMesonValueChanged(sender: UIStepper) {
        enMesonLabel.text = Int(sender.value).description
    }

    @IBAction func enCajaValueChanged(sender: UIStepper) {
        enCajaLabel.text = Int(sender.value).description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss:")
        sucursalLabel.text = mySucursal["address"] as? String
        enMesonStepper.wraps = true
        enMesonStepper.minimumValue = 0
        enMesonStepper.maximumValue = 100
        enMesonStepper.value = mySucursal["lastPeopleAtCustomerService"] as! Double
        enMesonLabel.text = Int(enMesonStepper.value).description
        enMesonStepper.autorepeat = true
        enCajaStepper.wraps = true
        enCajaStepper.minimumValue = 0
        enCajaStepper.maximumValue = 100
        enCajaStepper.value = mySucursal["lastPeopleAtCashier"] as! Double
        enCajaLabel.text = Int(enCajaStepper.value).description
        enCajaStepper.autorepeat = true
    }
    
    func dismiss(sender: AnyObject) {
    }
    
    func saveAnnotationInParse(peopleAtPosition: Int, positionType: String, objectId: PFObject!)
    {
        let objPF = PFObject(className: "Annotation")
        objPF["peopleAtPosition"] = peopleAtPosition
        objPF["positionType"] = positionType
        objPF["sucursalId"] = objectId
        objPF.saveInBackground()
    }

    
}
