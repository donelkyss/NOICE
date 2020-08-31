//
//  UsersConnectedExt.swift
//  NoIce
//
//  Created by Donelkys Santana on 6/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit
import UserNotifications

extension UsersConnected: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  //COLLECTION VIEW FUNCTION
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(self.usersConnected.count)
    return self.usersConnected.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell",for: indexPath) as! UserCollectionViewCell
    cell.delegate = self
    cell.initContent(user: self.usersConnected[indexPath.row])//(image: self.usersConnected[indexPath.row].photoProfile, hidden: !self.usersConnected[indexPath.row].NewMsg)
    cell.userPhoto.layer.cornerRadius = (cell.userPhoto.frame.width) / 8
    cell.userPhoto.contentMode = .scaleAspectFill
    cell.userPhoto.clipsToBounds = true
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    collectionViewLayout.invalidateLayout()
    let cellWidthSize = UIScreen.main.bounds.width / 2.5
    return CGSize(width: cellWidthSize, height: cellWidthSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = R.storyboard.main.chat()
    vc!.userSelected = self.usersConnected[indexPath.row]
    self.navigationController?.show(vc!, sender: nil)
  }
  
  func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    self.blockUser(userToBlock: self.usersConnected[indexPath.row].id)
  }
}

extension UsersConnected: UNUserNotificationCenterDelegate{
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("notification here \(response.notification.request.content)")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print(notification.request.content)
    guard let responseData = notification.request.content.userInfo["ck"] as? [String: AnyObject]else {
      //completionHandler(.failed)
      return
    }
   
    guard let user = responseData["qry"] as? [String: AnyObject]else {
      //completionHandler(.failed)
      return
    }
    print("here \(user["rid"])")
    self.getRecordFromSubscription(recordName: (user["rid"] as? String)!)
    //self.updateUsersConnected(userId: (user["rid"] as? String)!)
    completionHandler([.alert, .sound, .badge])
  }
  
}
