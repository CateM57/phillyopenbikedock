//
//  DetailViewController.swift
//  JackRideIndego
//
//  Created by R on 5/24/15.
//  Copyright (c) 2015 JackAmoratis. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var dockMap: MKMapView!
    
    @IBOutlet var stationInfoLabel: UILabel!
    var tableRow = 0
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var jsonCopy = Array<Dictionary<String,JSON>>()
    var stationInfo : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        self.dockMap?.delegate = self
        
        /* Note: Default is false */
        //self.dockMap?.showsUserLocation = true
        
        
        if let coordinate = appDelegate.currentLocation?.coordinate {
            
            // region around user location
            var mapDisplayRegion = MKCoordinateRegionMakeWithDistance(coordinate, jsonCopy[tableRow]["distFromLoc"]!.double! * 2, jsonCopy[tableRow]["distFromLoc"]!.double! * 2 )
            dockMap?.setRegion(mapDisplayRegion, animated: true)
        }
        
        var dockCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: jsonCopy[tableRow]["bikeDockLat"]!.double!, longitude: jsonCopy[tableRow]["bikeDockLong"]!.double!)
        var pointAnnotation:CustomPointAnnotation = CustomPointAnnotation()
        
        class CustomPointAnnotation: MKPointAnnotation {
            var imageName: String!
        }
        
        
        pointAnnotation.coordinate = dockCoordinate
        //pointAnnotation.subtitle = "Tap for directions" //jsonCopy[tableRow]["name"]!.string
        pointAnnotation.title = jsonCopy[tableRow]["name"]!.string
        var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton // button with info sign in it
        
        //pointAnnotation. = button
        self.dockMap?.addAnnotation(pointAnnotation)
        self.dockMap.selectAnnotation(pointAnnotation,animated: false)
        self.dockMap.showAnnotations(self.dockMap.annotations, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0x1BDE28)
        //stationInfoLabel.text = appDelegate.json["features"][tableRow]["properties"]["name"].string
        println(jsonCopy[tableRow]["distFromLoc"]!)
        
        stationInfo = jsonCopy[tableRow]["name"]!.string! + "\n"
            + jsonCopy[tableRow]["addressStreet"]!.string! + "\n"
            + jsonCopy[tableRow]["addressCity"]!.string! + ", "
            + jsonCopy[tableRow]["addressState"]!.string! + " "
            + jsonCopy[tableRow]["addressZipCode"]!.string! + " "
            + "\n\n"
            
            + String(stringInterpolationSegment: jsonCopy[tableRow]["bikesAvailable"]!.int!)
            + " bikes available\n"
            
            + String(stringInterpolationSegment: jsonCopy[tableRow]["docksAvailable"]!.int!)
            + " docks available\n"
            + String(stringInterpolationSegment: jsonCopy[tableRow]["totalDocks"]!.int!)
            + " total docks"
        
        stationInfoLabel.text = stationInfo
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Note: Allows the app to inform the user that it was not possible to get their location */
    func mapView(mapView: MKMapView!, didFailToLocateUserWithError error: NSError!) {
        println("Failed to locate user")
    }
    
    /* Note: Allows the app to inform the user that the map did not load */
    func mapViewDidFailLoadingMap(mapView: MKMapView!, withError error: NSError!) {
        println("Failed loading map: \(error)")
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
