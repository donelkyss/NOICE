//
//  UserConnectedCollection.swift
//  NoIce
//
//  Created by Donelkys Santana on 10/11/18.
//  Copyright © 2018 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import UserNotifications

class UsersConnected: UIViewController, UIGestureRecognizerDelegate{
  
  var userContainer = CKContainer.default()
  var connectedTimer: Timer!
  var newUsersSubscriptionID: CKSubscription.ID!
  var newMessageSubscriptionID: CKSubscription.ID!
  var usersConnected: [User] = [] {
    didSet{
      if self.usersConnected.count > 0 {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
          self.searchingView.isHidden = true
        }
      }
    }
  }
   var userConnectedNotificationCenter = UNUserNotificationCenter.current()
  
  //INTERFACES VARIABLES
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var helpView: UIView!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet weak var helpTextView: UITextView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var searchingView: UIView!
  @IBOutlet weak var backBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.headerView.addShadow()
    self.helpView.addShadow()
    self.backBtn.addShadow()
    self.collectionView.reloadSections(IndexSet(integer: 0))
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hiddeTextView))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    self.collectionView.addGestureRecognizer(tapGesture)
    
    self.helpTextView.text = NSLocalizedString("Click photo to chat or Slide it to hide and block.", comment: "")
    
    print("cloudId \(globalVariables.userLogged.cloudId)")
    
    self.userConnectedNotificationCenter.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.buscarUsuariosConectados()
    //connectedTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(buscarUsuariosConectados), userInfo: nil, repeats: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if self.newUsersSubscriptionID != nil{
      self.userContainer.publicCloudDatabase.delete(withSubscriptionID: self.newUsersSubscriptionID, completionHandler: { result, error in
        if let error = error {
          print(error.localizedDescription)
        }else{
          self.newUsersSubscriptionID = nil
        }
      })
    }
    
    if self.newMessageSubscriptionID != nil{
      self.userContainer.publicCloudDatabase.delete(withSubscriptionID: self.newMessageSubscriptionID, completionHandler: { result, error in
        if let error = error {
          print(error.localizedDescription)
        }else{
          self.newMessageSubscriptionID = nil
        }
      })
    }
  }
  
  //CUSTOM FUNCTIONS
  @objc func buscarUsuariosConectados(){
    print("buscando")
    let userLoggedReference = CKRecord.ID(recordName: globalVariables.userLogged.cloudId)
    let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(location, %@) < 100 and recordID != %@",globalVariables.userLogged.location, userLoggedReference)
    let queryUsuarioIn = CKQuery(recordType: "UsersConnected",predicate: predicateUsuarioIn)
    queryUsuarioIn.sortDescriptors = [CKLocationSortDescriptor(key: "location", relativeLocation: globalVariables.userLogged.location)]
    self.userContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        print("Something \(results?.count)")
        self.usersConnected.removeAll()
        if (results?.count)! > 0{
          print("users found")
          for userResult in results!{
            let usuarioTemp = User(user: userResult)
            self.usersConnected.append(usuarioTemp)
          }
          self.buscarNuevosMSG()
          self.createNewUsersConnectedSubscription()
          self.createNewMsgSubscription()
        }else{
          //self.connectedTimer.invalidate()
          DispatchQueue.main.async {
            let alertaClose = UIAlertController (title: NSLocalizedString("No user connected",comment:"No user connected"), message: NSLocalizedString("There aren't any user connected near you. You can go to any bar, disco or recreational places and try again. And please share the app with your friends to grow our community.", comment:"No user connected"), preferredStyle: UIAlertController.Style.alert)
            alertaClose.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment:"Settings"), style: UIAlertAction.Style.default, handler: {alerAction in
              //self.connectedTimer.invalidate()
              let vc  = R.storyboard.main.profileView()
              self.navigationController?.setNavigationBarHidden(false, animated: true)
              self.navigationController?.show(vc!, sender: nil)
            }))
            self.present(alertaClose, animated: true, completion: nil)
            
          }
        }
       
      }else{
        print("ERROR DE CONSULTA " + error.debugDescription)
      }
    }))
    
  }
  
  func buscarNuevosMSG() {
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: globalVariables.userLogged.cloudId), action: .none)
    //let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.id), action: .none)
    let predicateMesajes = NSPredicate(format: "to == %@",toReference)
    
    let queryMSGVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
    
    self.userContainer.publicCloudDatabase.perform(queryMSGVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        if (results?.count)! > 0{
          var i = 0
          while i < (self.usersConnected.count){
            if ((results?.contains{($0.value(forKey: "from") as? CKRecord.Reference)!.recordID.recordName == self.usersConnected[i].cloudId})!) {
              self.usersConnected[i].NewMsg = true
            }else{
              self.usersConnected[i].NewMsg = false
            }
            i += 1
          }
        }
      }else{
        print(error.debugDescription)
      }
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
      
    }))
  }
  
  func createNewUsersConnectedSubscription(){
    print("working userConnected")
    //UNUserNotificationCenter.current().delegate = self
    let predicate = NSPredicate(format:"distanceToLocation:fromLocation:(location, %@) < 100 and recordID != %@", globalVariables.userLogged.location, CKRecord.ID(recordName: globalVariables.userLogged.cloudId))
    let subscription = CKQuerySubscription(recordType: "UsersConnected", predicate: predicate, options: [.firesOnRecordCreation,.firesOnRecordDeletion])
    
    let notification = CKSubscription.NotificationInfo()
    notification.shouldSendContentAvailable = true
    notification.soundName = "default"
    subscription.notificationInfo = notification
    
    self.userContainer.publicCloudDatabase.save(subscription) { result, error in
      if let error = error {
        print(error.localizedDescription)
      }else{
        self.newUsersSubscriptionID = result?.subscriptionID
      }
    }
  }
  
  func createNewMsgSubscription(){
    print("working message")
    let predicate = NSPredicate(format: "to = %@",CKRecord.ID(recordName: globalVariables.userLogged.cloudId))
    let subscription = CKQuerySubscription(recordType: "Messages", predicate: predicate, options: [.firesOnRecordCreation])
    let notification = CKSubscription.NotificationInfo()
    notification.soundName = "default"
    notification.shouldSendContentAvailable = true
    
    subscription.notificationInfo = notification
    
    self.userContainer.publicCloudDatabase.save(subscription) { result, error in
      if let error = error {
        print(error.localizedDescription)
      }else{
        self.newMessageSubscriptionID = result?.subscriptionID
      }
    }
  }
  
  func updateUsersConnected(userId: String){
    if self.usersConnected.contains(where: {$0.cloudId == userId}){
      self.usersConnected.removeAll{$0.cloudId == userId}
      print("user desconnected")
    }else{
      self.userContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: userId), completionHandler: { (record, error) in
        if (error == nil) {
          print("Something \(record?.value(forKey: "id") as! String)")
            let usuarioTemp = User(user: (record)!)
            self.usersConnected.append(usuarioTemp)
          }
      
      })
    }
  }
  
  func getRecordFromSubscription(recordName: String){
    let index = self.usersConnected.firstIndex(where: {$0.cloudId == recordName})
    print("index \(index)")
    if index != nil{
      self.usersConnected.remove(at: index!)
      print("user desconnected")
    }else{
      self.userContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: recordName), completionHandler: { (record, error) in
        if (error == nil) {
          if (record?.value(forKey: "recordType") as! String) == "Messages"{
            let newMessage = Message(newMessage: record!)
            if newMessage.to == globalVariables.userLogged.cloudId{
              let userIndex = self.usersConnected.firstIndex(where: {$0.cloudId == newMessage.from})
              self.usersConnected[userIndex!].NewMsg = true
              DispatchQueue.main.async {
                self.collectionView.reloadData()
              }
            }
          }else{
            print("new user connected")
            let usuarioTemp = User(user: (record)!)
            if !self.usersConnected.contains(where: {$0.cloudId == usuarioTemp.cloudId}){
              self.usersConnected.append(usuarioTemp)
            }
            //self.usersConnected.removeDupl
            print(self.usersConnected)
          }
        }
      })
    }
  }
  
  func blockUser(userToBlock: String){
    globalVariables.userLogged.ActualizarBloqueo(userToBlock: userToBlock, completionHandler: { success in
      if success {
        self.usersConnected.removeAll{$0.id == userToBlock}
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    })
  }
  
  @objc func hiddeTextView(sender: UITapGestureRecognizer){
    self.helpView.isHidden = true
  }
  
  @IBAction func showMenu(_ sender: Any) {
    
  }
  
  @IBAction func CloseApp(_ sender: Any) {
    globalVariables.userLogged.desconnect()//desconnect
  }
  
  @IBAction func showHelp(_ sender: Any) {
    self.helpView.isHidden = !self.helpView.isHidden
  }

}

extension UsersConnected: UserCollectionDelegate{
  func apiRequest(_ controller: UserCollectionViewCell, didHideUser userId: String) {
    self.blockUser(userToBlock: userId)
  }
}
