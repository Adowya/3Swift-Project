//
//  SecondViewController.swift
//  FlySupCaen
//
//  Created by Clément on 17/06/2014.
//  Copyright (c) 2014 Clement. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblFly: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "gradient8")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returning to view
    override func viewWillAppear(animated: Bool) {
        tblFly.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            flyMgr.removeFly(indexPath.row)
            tblFly.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flyMgr.flys.count
    }
    
//    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FlyList")
//        
//        cell.textLabel!.text = flyMgr.flys[indexPath.row].departure
//        cell.detailTextLabel?.text = flyMgr.flys[indexPath.row].arrival
//        
//        return cell
//        
//    }
    
    
    
}
