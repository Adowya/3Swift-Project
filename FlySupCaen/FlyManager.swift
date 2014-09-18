//
//  FlyManager.swift
//  FlySupCaen
//
//  Created by Clément on 17/06/2014.
//  Copyright (c) 2014 Clement. All rights reserved.
//

import UIKit
import CoreData


var flyMgr: flyManager = flyManager()

struct Fly {
    var departure = "departure"
    var arrival = "arrival"
    
}

class flyManager: NSObject {
    
    var flys = Fly[]()
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    
    
    init(){
        
        var tempFlys:NSArray = persistenceHelper.list("Fly")
        
        for res:AnyObject in tempFlys{
            
            flys.append(Fly(
                departure:res.valueForKey("departure")as String,
                arrival:res.valueForKey("arrival") as String
                ))
        }
    }
    
    
    func addFly(departure:String, arrival: String){
        
        var dicFly: Dictionary<String, String> = Dictionary<String,String>()
        
        dicFly["departure"] = departure
        dicFly["arrival"] = arrival

        
        if(persistenceHelper.save("Fly", parameters: dicFly)){
            
            flys.append(Fly(departure:departure, arrival:arrival))
            
        }
    }
    
    
    func removeFly(index:Int){
        
        var value:String = flys[index].departure
        
        if(persistenceHelper.remove("Fly", key: "departure", value: value)){
            flys.removeAtIndex(index)
        }
        
    }
    

}