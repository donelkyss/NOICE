//
//  UserNotificationService.swift
//  NoIce
//
//  Created by Donelkys Santana on 8/16/20.
//  Copyright © 2020 Done Santana. All rights reserved.
//

import UIKit
import UserNotifications

//protocol NotificationServiceDelegate: class {
//  func notificationResult(_ controller: NotificationService, updateUserConnected userID: String)
//  func notificationResult(_ controller: NotificationService, newMessageReceived messageID: String)
//}
//
//final class NotificationService{
//  weak var delegate: NotificationServiceDelegate?
//
//
//  func getNewUsersConnected(predicate: NSPredicate?){
//    print("working good")
//    UNUserNotificationCenter.current().delegate = self
//    let predicate = NSPredicate(format:"distanceToLocation:fromLocation:(location, %@) < 100 and recordID != %@", GlobalVariables.userLogged.location, CKRecord.ID(recordName: GlobalVariables.userLogged.cloudId))
//    let subscription = CKQuerySubscription(recordType: "UsersConnected", predicate: predicate, options: [.firesOnRecordCreation,.firesOnRecordDeletion])
//
//    let notification = CKSubscription.NotificationInfo()
//    //notification.alertBody = "There's a new user connected."
//    notification.soundName = "default"
//    notification.shouldSendContentAvailable = true
//
//    subscription.notificationInfo = notification
//
//    self.userContainer.publicCloudDatabase.save(subscription) { result, error in
//      if let error = error {
//        print(error.localizedDescription)
//      }else{
//        self.newUsersSubscriptionID = result?.subscriptionID
//      }
//    }
//  }
//}
//
//extension NotificationService: UNUserNotificationCenterDelegate{
//  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//    print("notification here \(response.notification.request.content)")
//  }
//
//  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    guard let responseData = notification.request.content.userInfo["ck"] as? [String: AnyObject]else {
//      //completionHandler(.failed)
//      return
//    }
//
//    guard let user = responseData["qry"] as? [String: AnyObject]else {
//      //completionHandler(.failed)
//      return
//    }
//    print("here \(user["rid"])")
//    self.updateUsersConnected(userId: (user["rid"] as? String)!)
//    completionHandler([.alert, .sound, .badge])
//  }
//}
