//
//  DrawerDelegate.swift
//  Echolo
//
//  Created by Cameron Gallarno on 2/17/15.
//  Copyright (c) 2015 Avionic. All rights reserved.
//

import Foundation
import UIKit

class DrawerDelegate: NSObject, MSDynamicsDrawerViewControllerDelegate{
    let storyboard : UIStoryboard
    let dynamicsDrawerViewController : MSDynamicsDrawerViewController

    let mainVC : UIViewController
    let leftVC : UIViewController
    let rightVC : UIViewController
    
    class var sharedInstance: DrawerDelegate {
        struct Static {
            static var instance: DrawerDelegate?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DrawerDelegate()
        }
        
        return Static.instance!
    }
    
    override init(){
        println("DRAWERDELEGATE::init")
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.dynamicsDrawerViewController = UIApplication.sharedApplication().windows[0].rootViewController as! MSDynamicsDrawerViewController

        println("DRAWERDELEGATE::init super.init()")
        
        self.mainVC = storyboard.instantiateViewControllerWithIdentifier("MainViewVC") as! UIViewController
        self.leftVC = storyboard.instantiateViewControllerWithIdentifier("LeftDrawerVC") as! UIViewController
        self.rightVC = storyboard.instantiateViewControllerWithIdentifier("RightDrawerVC") as! UIViewController

        super.init()
        
        dynamicsDrawerViewController.delegate = self
        dynamicsDrawerViewController.setDrawerViewController(leftVC, forDirection: .Left)
        dynamicsDrawerViewController.setDrawerViewController(rightVC, forDirection: .Right)
        dynamicsDrawerViewController.addStyler(MSDynamicsDrawerShadowStyler(), forDirection: (.Left | .Right))
        
        self.dynamicsDrawerViewController.paneViewController = mainVC
        
        println("DRAWERDELEGATE::init complete")
    }
    

    
    func revealDrawer(forDirection direction:MSDynamicsDrawerDirection) {
        dynamicsDrawerViewController.setPaneState(.Open, inDirection: direction, animated: true, allowUserInterruption: false) { () -> Void in
            println("DRAWERDELEGATE::openDrawer Complete")
        }
    }
    
    func closeDrawer(completion: () -> Void) {
        dynamicsDrawerViewController.setPaneState(.Closed, animated: true, allowUserInterruption: false) { () -> Void in
            completion()
        }
    }
    
    func openDrawerWide(completion: (() -> Void)?){
        dynamicsDrawerViewController.setPaneState(.OpenWide, animated: true, allowUserInterruption: false) { () -> Void in
            println("openDrawerWide completion");
            if let callback = completion{
                callback()
            }
        }
    }
    
    func closeDrawerWide(completion: (() -> Void)?){
        dynamicsDrawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: false) { () -> Void in
            println("closeDrawerWide");
            if let callback = completion{
                callback()
            }
        }
    }
}