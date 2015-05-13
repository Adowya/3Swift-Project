//
//  FirstViewController.swift
//  FlySupCaen
//
//  Created by Clément on 17/06/2014.
//  Copyright (c) 2014 Clement. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {


    
    var counterSec: Int = 0
    var counterMin: Int = 0
    var counterHour: Int = 0
    var goButtonTouched: Bool = false
    var TheTimer = NSTimer()
    var startDate = NSDate()
    var local = CLLocationManager()
    var distances = NSMutableArray()
    
    var labeLocation: String = ""

    ////////////RealLocation///////////
//    var currentLocation = CLLocation()
    ///////////////////////////////////
    
    //Fake location_Caen
    var currentLocation:CLLocation = CLLocation(latitude: 49.183333, longitude: -0.35)


    
    @IBOutlet var LblButton : UIButton?
    @IBOutlet var LblCounter : UILabel?
    @IBOutlet var LblDepTime : UILabel?
    @IBOutlet var LblArrTime : UILabel?
    @IBOutlet var LblDurration : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient5")!)
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnStart_Click(sender:UIButton){
        //Change button to Stop
        if self.goButtonTouched == true {
            self.goBtnStop()
        }else {
            //Start location
            getUserLocation()
            
            //Alert Ask
            let alert = UIAlertController(title: "Do you want to START flying ?", message:nil, preferredStyle:.Alert)
            //Alert Action
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            
            let otherAction = UIAlertAction(title: "Start", style: .Default){ action in
                //Initialize
                self.counterSec = 0
                self.counterMin = 0
                self.counterHour = 0
                self.LblDepTime?.text = ""
                self.LblArrTime?.text = ""
                self.LblDurration?.text = ""
                self.goButtonTouched = true
                self.LblButton?.setTitle("Stop", forState: UIControlState.Normal)
                
                //Departure = date.now()
                var currentDate:CFGregorianDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
                
                self.TheTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
                
                self.LblDepTime?.text = NSString(format:"%@ - %02d/%02d/%02d - %02dh%02d", self.labeLocation, currentDate.day, currentDate.month, currentDate.year, currentDate.hour, currentDate.minute)
                
            }
            alert.addAction(cancelAction)
            alert.addAction(otherAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func goBtnStop() {
        //Start location
        getUserLocation()
        
        //Alert Ask
        let alert = UIAlertController(title: "Do you want to STOP flying ?", message:nil, preferredStyle:.Alert)
        //Alert Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
        }
        
        let otherAction = UIAlertAction(title: "STOP", style: .Default){ action in
            self.goButtonTouched = false
            //Stop counter
            self.TheTimer.invalidate()
            //Change button
            self.LblButton?.setTitle("Start", forState: UIControlState.Normal)
            
            //Arrival = Aeroport + date.now()
            let currentDate:CFGregorianDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
            
            self.LblArrTime?.text = NSString(format:"%@ - %02d/%02d/%02d - %02dh%02d", self.labeLocation, currentDate.day, currentDate.month, currentDate.year, currentDate.hour, currentDate.minute)
            
            //Duration
            self.LblDurration?.text = self.LblCounter?.text
            
            //Persist fly
            var departure: String = self.LblDepTime!.text!
            var arrival: String = self.LblArrTime!.text!+" - "+self.LblDurration!.text!
            
            println("departure = \(departure)")
            println("arrival = \(arrival)")
            
            flyMgr.addFly(departure, arrival: arrival)
            
        }
        alert.addAction(cancelAction)
        alert.addAction(otherAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    

    func getAirportLocation(){
        let path = NSBundle.mainBundle().pathForResource("airports", ofType: "plist")
        var anError : NSError?
        
        
        let data = NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingUncached, error: &anError)
//        let data : NSData! = NSData.dataWithContentsOfFile(path!, options: NSDataReadingOptions.DataReadingUncached, error: &anError)
        let dict : AnyObject! = NSPropertyListSerialization.propertyListWithData(data!, options: 0,format: nil, error: &anError)

        var ArrayCode = NSMutableArray()
        if (dict != nil){
            if let ocDictionary = dict as? NSDictionary {
                var swiftDict : Dictionary<String,AnyObject!> = Dictionary<String,AnyObject!>()
                for key : AnyObject in ocDictionary.allKeys{
                    let stringKey : String = key as String
                    
                    //Table code
                    ArrayCode.addObject(stringKey)
                    
                    println("---------------INFO----------------")
                    println("AirPortCode = \(stringKey)")

                    if let keyValue : AnyObject = ocDictionary.valueForKey(stringKey){
                        swiftDict[stringKey] = keyValue
                        var airLat : CLLocationDegrees? = keyValue.valueForKey("Lat")?.doubleValue
                        var airLng : CLLocationDegrees? = keyValue.valueForKey("Lng")?.doubleValue
                        var airName : AnyObject = keyValue.valueForKey("Name")!
                        println("Airport Name : \(airName)")

                        //AirPort Location Object
                        var airPortLocation:CLLocation = CLLocation(latitude: airLat!, longitude: airLng!)

                        //Distance between each Airport with UserLocation
                        var distance:CLLocationDistance = airPortLocation.distanceFromLocation(self.currentLocation)
                        
                        // var total = Int((distance as NSString).integerValue)
                    
                        //Table distance
                        distances.addObject((distance as NSNumber).integerValue)
                        
                        println("AirPortLocation : \(airPortLocation)")
                        println("-----------------------------------")
                        println("CurrentLocation : \(self.currentLocation)")
                        println("-----------------------------------")
                        println("Distance = \(distance)")
                        println("-----------------------------------")
                        
                    }
                }
                
                //Find min value of distance
                let min : NSNumber = (distances as AnyObject).valueForKeyPath("@min.doubleValue")!.doubleValue!
                
                println("-----------------------------------")
                println("----------Nearest Airport----------")
                println("-----------------------------------")
                println("-----------------------------------")
                println("Distance mini = \(min)")

                //Find index for this min value
                let indexOfmin : NSInteger = distances.indexOfObject(min)
                //Find object have the same Index and return value: CodeAir
                let codeAir : AnyObject = ArrayCode.objectAtIndex(indexOfmin)
                
                //Send this value to the Label LblDepTime/LblArrTime
                self.labeLocation = codeAir as String
                    
                println("CODE = \(codeAir)")
                println("Find this 'CODE' in this console for find the Nearest Airport Info")

            } else {
                //return nil
            }
        } else if let theError = anError {
            println("Sorry, couldn't read the file \(path?.lastPathComponent):\n\t"+theError.localizedDescription)
        }
        
    }
    
    //Location Manager
    func locationManager(manager:CLLocationManager,didUpdateToLocation newLocation:CLLocation,fromLocation oldLocation:CLLocation){
        
        if let currentLocation = newLocation as CLLocation? {
            
            var myLat:NSString = "\(currentLocation.coordinate.latitude)"
            var myLon:NSString = "\(currentLocation.coordinate.longitude)"
            
        }
    }
    
    //Get Geo Position of User and the Nearest AirPortCode
    func getUserLocation()
    {
        locationManager(local, didUpdateToLocation: currentLocation, fromLocation: currentLocation)
        getAirportLocation()
    }
    
    //Counter
    func updateTimer() {
        if self.counterSec == 60 {
            self.counterSec = 0
            self.counterMin += 1
            if self.counterMin == 60  {
                self.counterHour += 1
                self.counterMin = 0
            }
        }
        self.LblCounter?.text = NSString(format:"%i Hour %i Min %i Sec", self.counterHour, self.counterMin, self.counterSec++)
    }

    
}

