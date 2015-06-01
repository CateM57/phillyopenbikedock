//
//  TabNearMeViewController.swift
//  JackRideIndego
//
//  Created by R on 5/23/15.
//  Copyright (c) 2015 JackAmoratis. All rights reserved.
//
import UIKit
import CoreLocation
class TabNearMeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var jsonCopy = Array<Dictionary<String,JSON>>()
    var locationTestTimer : NSTimer!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var dict = Dictionary<String, JSON>()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelDistance: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelBikesAvailable: UILabel!
    @IBOutlet var enableServicesNoticeUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableHandler:", name:"ReloadHandler", object: nil)
        appDelegate.makeAPICall() }
    
    func reloadTableHandler(notification:NSNotification){
        testLocation()
    }
    
    func testLocation(){
        locationTestTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: true)
    }
    
    func reloadTable(){
        if appDelegate.currentLocation == nil {
            println("test")
            return
        }else{
            locationTestTimer.invalidate()
            println("timer invalidated - location established")
        }
        
        for (index, value) in enumerate(appDelegate.json["features"]) {
            let bikeDockLat = appDelegate.json["features"][index]["geometry"]["coordinates"][1].doubleValue
            let bikeDockLong:Double = appDelegate.json["features"][index]["geometry"]["coordinates"][0].doubleValue
            let bikeDockLocation = CLLocation(latitude: bikeDockLat, longitude: bikeDockLong)
            
            if appDelegate.currentLocation == nil{
                enableServicesNoticeUIView.hidden = false
                println("current location nil!")
            }else{
                enableServicesNoticeUIView.hidden = true
                var dist = appDelegate.currentLocation.distanceFromLocation(bikeDockLocation)
                var appDelJF = appDelegate.json["features"]
                for (indexCount, element) in enumerate(appDelegate.json["features"][index]["properties"]){
                    if appDelegate.json["features"][index]["properties"][element.0] != nil{
                        dict[element.0] = appDelegate.json["features"][index]["properties"][element.0]
                    } else {
                        dict[element.0] = "nil"
                    }
                }
                
                if dist.isNaN == true {
                    dist = 1.0
                }
                
                let rr : JSON! = JSON(String(format: "%.1f", dist * 0.00062137))
                dict["bikeDockLat"] = JSON(bikeDockLat)
                dict["bikeDockLong"] = JSON(bikeDockLong)
                dict["distFromLoc"] = JSON(dist)
                dict["dist"] = rr
                jsonCopy.append(dict)
                
                
                dict["bikeDockCoordinates"] = JSON(bikeDockLocation)
            }
            jsonCopy.sort{
                (($0 as Dictionary<String, JSON>)["dist"]?.string) < (($1 as Dictionary<String, JSON>)["dist"]!.string)
            }
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() }
    // Dispose of any resources that can be recreated.
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        if appDelegate.currentLocation != nil{
            
            let bikeDockLat = appDelegate.json["features"][indexPath.row]["geometry"]["coordinates"][0].doubleValue
            let bikeDockLong:Double = appDelegate.json["features"][indexPath.row]["geometry"]["coordinates"][1].doubleValue
            println(String(stringInterpolationSegment: bikeDockLat))
            println(String(stringInterpolationSegment: bikeDockLong))
            let bikeDockLocation = CLLocation(latitude: bikeDockLat, longitude: bikeDockLong)
            let distanceString : String! = jsonCopy[indexPath.row]["dist"]!.string
            (cell.viewWithTag(100) as! UILabel).text = "\(distanceString!) miles"
            (cell.viewWithTag(110) as! UILabel).text = jsonCopy[indexPath.row]["name"]!.string
            var ba1 : String = String(stringInterpolationSegment:jsonCopy[indexPath.row]["bikesAvailable"]!.int!)
            var ba2 :String = String(stringInterpolationSegment:jsonCopy[indexPath.row]["docksAvailable"]!.int!)
            (cell.viewWithTag(120) as! UILabel).text = "\(ba1) bikes avail. | \(ba2) open docks"
            return cell
        }else{
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appDelegate.currentLocation != nil{
            return appDelegate.json["features"].count
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "nearbyDetailViewSegue" {
            if let destination = segue.destinationViewController as? DetailViewController {
                if let tableRow = tableView.indexPathForSelectedRow()?.row {
                    destination.tableRow = tableRow
                    destination.jsonCopy = jsonCopy
                } } } }
    
    
}
