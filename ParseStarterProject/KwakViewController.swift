
//  KwakViewController.swift
//  testTutti
//
//  Created by hugo roman on 10/25/15.
//  Copyright © 2015 hugo roman. All rights reserved.
//

import UIKit
import MapKit
import Parse

class KwakViewController: UIViewController, MKMapViewDelegate {
    

    var initialLocation = CLLocation()
    //    var session: NSURLSession!
    //    var appDelegate: AppDelegate!
    var beAndCv : [Sucursales]=[]
    
    let regionRadius: CLLocationDistance = 1000
    var myPFPoint : PFGeoPoint!
    var mySucursalLook: PFObject!
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var itemSelected: UISegmentedControl!
    
    @IBAction func itemSegmentedControlPressed(sender: AnyObject) {

        //MARK: Remove all annotations and paint again
        myMap.removeAnnotations(myMap.annotations)
        if(itemSelected.selectedSegmentIndex == 0)
        {
            paintAnnotation("BE")
        }
        else if(itemSelected.selectedSegmentIndex == 1)
        {
            paintAnnotation("CV")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        myMap.delegate = self
        myMap.showsUserLocation = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let _ = mySucursalLook as PFObject! {
            //MARK: Waiting
            myMap.removeAnnotations(myMap.annotations)
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityView.center = self.view.center
            activityView.startAnimating()
            fillSucursal(mySucursalLook)
            activityView.stopAnimating()
            activityView.hidden = true
            self.view.addSubview(activityView)
            activityView.stopAnimating()
        }
    }

    //MARK propetary functions
    func fillAllSucursales() -> Void {
        let query = PFQuery(className: "Sucursales")
        myPFPoint = PFGeoPoint(location: myMap.userLocation.location)
        print(myMap.userLocation.coordinate)
        query.whereKey("position", nearGeoPoint: myPFPoint, withinKilometers: 1.0)
        
        query.findObjectsInBackgroundWithBlock(){
            (sucursales: [PFObject]?, error: NSError?) -> Void in
            for mySucursal in sucursales! { // message is of PFObject type
                let myPosition = (mySucursal["position"] as! PFGeoPoint).location()
                self.beAndCv.append(Sucursales(idIn: mySucursal.objectId! , addressIn: mySucursal["address"] as! String, cityIn: mySucursal["city"] as! String, positionIn: myPosition , sucursalTypeIn: mySucursal["sucursalType"] as! String, atCashier: mySucursal["lastPeopleAtCashier"] as! Int,
                    atCustomerService: mySucursal["lastPeopleAtCustomerService"] as! Int,
                    meIn: mySucursal))
            }
            self.paintAnnotation("BE")
        }
    }
    
    func fillSucursal(mySuc : PFObject)->Void{
        for mySucursal in beAndCv {
            if mySucursal.id == mySucursalLook.objectId  {
                mySucursal.peopleAtCashier = (mySucursalLook["lastPeopleAtCashier"] as? Int)!
                mySucursal.peopleAtCustomerService = (mySucursalLook["lastPeopleAtCustomerService"] as? Int)!
            }
        }
        paintAnnotation("BE")
    }
    
    
    func paintAnnotation(itemToPaint: String) -> Void{
        
        //MARK: Position in map
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)

        for mySucursal in beAndCv {
        // message is of PFObject type
            if mySucursal.sucursalType == itemToPaint {

                let myPosition = mySucursal.position
                let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(myPosition.coordinate.latitude, myPosition.coordinate.longitude)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
                myMap.setRegion(region, animated: true)
                let pinLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(myPosition.coordinate.latitude, myPosition.coordinate.longitude)
                //MARK: Custom positioning
                var pointAnnotation:CustomPointAnnotation!
                var annotationView:MKPinAnnotationView!
                pointAnnotation = CustomPointAnnotation()
                if mySucursal.sucursalType == "BE"{
                    pointAnnotation.pinCustomImageName = "BE"
                }else{
                    pointAnnotation.pinCustomImageName = "CV"
                }
                pointAnnotation.coordinate = pointLocation
                pointAnnotation.title = mySucursal.address
                pointAnnotation.subtitle = "En mesón:\(mySucursal.peopleAtCustomerService) En cajas:\(mySucursal.peopleAtCashier) "
                pointAnnotation.mySucursal = mySucursal.me
                annotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
                myMap.addAnnotation(annotationView.annotation!)
            }
        }
    }
    
    func lookInside(mySuc:PFObject) {
        
        let popoverContent = (self.storyboard!.instantiateViewControllerWithIdentifier("KwakDetailViewController")) as! KwakDetailViewController
//        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
//        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
        
 //       let popover = nav.popoverPresentationController
//        let popover = popoverContent.popoverPresentationController
        popoverContent.mySucursal = mySuc
//        popoverContent.preferredContentSize = CGSizeMake(400,600)
//        popover!.delegate = self
//        popover!.sourceView = self.view
//        popover!.sourceRect = CGRectMake(100,100,0,0)
//        self.presentViewController(nav, animated: true, completion: nil)
//        self.presentViewController(popoverContent, animated: true, completion: nil)
        self.presentViewController(popoverContent, animated: true, completion:
            {
                print ("tamos daos")
            })
        
    }

    
// MARK: Annotations delegates for customizing
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            let btn = UIButton(type: .DetailDisclosure)
            anView!.rightCalloutAccessoryView = btn
        }
        else {
            anView!.annotation = annotation
        }
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.pinCustomImageName)
        return anView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let cpa = view.annotation as! CustomPointAnnotation
        mySucursalLook = cpa.mySucursal
        lookInside(cpa.mySucursal)
    }

    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("no te hasho shasho \(error)")
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {
            mapView.centerCoordinate = userLocation.location!.coordinate
            fillAllSucursales()
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let _ = view.annotation as? CustomPointAnnotation {
            print("somos hermanos")
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("bórrate hermano")
    }
    
    
}

