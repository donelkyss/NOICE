//
//  AppDelegate.swift
//  NoIce
//
//  Created by Done Santana on 13/1/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var Appcontainer = CKContainer.default()
  
  var backgrounTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
  var myTimer: Timer?
  var BackgroundSeconds = 0
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //Avoid lock screen when app is open
    application.isIdleTimerDisabled = true
    //GMSServices.provideAPIKey("AIzaSyBnKURUhbBUr74PbpPgtPA1driuRaTShGo")
    // Override point for customization after application launch.
    
    //FBSDKApplicationDelegate.sharedInstance().application( application, didFinishLaunchingWithOptions: launchOptions)
    //return true
    
    return true
  }
  
  @objc func TimerMethod(sender: Timer){
    let backgroundTimeRemaining = UIApplication.shared.backgroundTimeRemaining
    if backgroundTimeRemaining == Double.greatestFiniteMagnitude{
      print("Background Time Remaining = Undetermined")
    }else{
      if BackgroundSeconds <= 1200{
        BackgroundSeconds += 1
      }else{
        if MyVariables.userLogged != nil{
          MyVariables.userLogged.ActualizarConectado(estado: "0")
        }
      }
    }
  }
  
  func endBackgroundTask(){
    if let timer = self.myTimer{
      timer.invalidate()
      self.myTimer = nil
      UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(self.backgrounTaskIdentifier.rawValue))
      self.backgrounTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    }
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return true
    //return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    /*if MyVariables.userLogged != nil{
     MyVariables.userLogged.ActualizarConectado(estado: "0")
     sleep(2)
     }*/
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self,selector: #selector(TimerMethod), userInfo: nil, repeats: true)
    backgrounTaskIdentifier = application.beginBackgroundTask(withName: "task1", expirationHandler: {
      [weak self] in
      self!.endBackgroundTask()
    })
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    if backgrounTaskIdentifier != UIBackgroundTaskIdentifier.invalid{
      endBackgroundTask()
    }
    let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
    badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
      if error != nil {
        print("Error resetting badge: \(String(describing: error))")
      }
      else {
        
      }
    }
    application.applicationIconBadgeNumber = 0
    CKContainer.default().add(badgeResetOperation)
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    //MyVariables.socketConexion.connect()
    /*if MyVariables.userLogged != nil{
     MyVariables.userLogged.ActualizarConectado(estado: "1")
     sleep(2)
     }*/
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //self.saveContext()
    if MyVariables.userLogged != nil{
      MyVariables.userLogged.ActualizarConectado(estado: "0")
      sleep(2)
    }
  }
  
  
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIBackgroundTaskIdentifier(_ input: Int) -> UIBackgroundTaskIdentifier {
  return UIBackgroundTaskIdentifier(rawValue: input)
}
