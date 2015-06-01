//
//  AppDelegate.swift
//  JackRideIndego
//
//  Created by R on 5/23/15.
//  Copyright (c) 2015 JackAmoratis. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var currentLocation: CLLocation!
    var window: UIWindow?
    var json: JSON = []
    var myViewController:TabNearMeViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        testforconnect()
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .AuthorizedAlways:
            println("authorized")
        case .AuthorizedWhenInUse:
            println("authorized when in use")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            startLocation = nil
        case .Denied:
            println("denied")
        case .NotDetermined:
            println("not determined")
        case .Restricted:
            println("restricted")
        }
        
        // Override point for customization after application launch.
        return true
    }
    func testforconnect(){
        println("authorized when in use")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }
    
    func dotest(){
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .AuthorizedAlways:
            println("authorized")
        case .AuthorizedWhenInUse:
            println("worked")
        case .Denied:
            println("denied")
        case .NotDetermined:
            println("not yet")
            testforconnect()
        case .Restricted:
            println("restricted")
        }
    }
    func getJSON(urlToRequest: String) -> NSData{
        var x = NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
        println(x)
        return x
    }
    
    func makeAPICall(){
        self.json = JSON(data: getJSON("https://api.phila.gov/bike-share-stations/v1"))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.startLocation = nil
            NSNotificationCenter.defaultCenter().postNotificationName("ReloadHandler", object: false)
        })
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations[0] as! CLLocation
        currentLocation = location
        println("Latitude: \(location.coordinate.latitude). Longitude: \(location.coordinate.longitude).")
    }
    
    
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
            
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
}

