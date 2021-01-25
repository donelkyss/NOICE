//
//  ChatVC.swift
//  Chat App For iOS 10
//
//  Created by MacBook on 11/23/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import UIKit
import MessageKit
import MobileCoreServices
import AVKit
import CloudKit
import UserNotifications

class ChatViewController: MessagesViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
  
  var chatOpenPos: Int!
  var userSelected: User!
  var MSGTimer : Timer!
  var chatContainer = CKContainer.default()
  var newMessageSubscriptionID: CKSubscription.ID!
  var newUsersSubscriptionID: CKSubscription.ID!
  var tap: UITapGestureRecognizer!
  var topMenu = UIView()
  
  let screenBounds = UIScreen.main.bounds
  
  var messageList: [Message] = []
  
  var firstMessage = true
  
  var userMessageNotificationCenter = UNUserNotificationCenter.current()
  
  @IBOutlet weak var BloUser: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messageCellDelegate = self
    messageInputBar.delegate = self

    self.BloUser.isEnabled = false
    //    self.senderId = GlobalVariables.userLogged.Email
    //    self.senderDisplayName = ""
    
    //Hide adjunte button
    //self.inputToolbar.contentView.leftBarButtonItem = nil
    
    let image = self.userSelected.photoProfile
    
    let imgBackground:UIImageView = UIImageView(frame: self.view.bounds)
    imgBackground.image = image
    imgBackground.contentMode = UIView.ContentMode.scaleAspectFill
    imgBackground.clipsToBounds = true
    
    messagesCollectionView.backgroundView = imgBackground
    
    self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    messagesCollectionView.addGestureRecognizer(self.tap)
    //view.addGestureRecognizer(self.tap)
    //Descomentar, si el tap no debe interferir o cancelar otras acciones
    //tap.cancelsTouchesInView = false
    
    let navController = navigationController!
    let bannerHeight = navController.navigationBar.frame.size.height
    let logoContainer = UIView(frame: CGRect(x: 0, y: 1, width: bannerHeight-2, height: bannerHeight-2))
    
    let imageView = UIImageView(image: image)
    imageView.frame = CGRect(x: 0, y: 0, width: bannerHeight-2, height: bannerHeight-2)
    imageView.layer.cornerRadius = bannerHeight / 6
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    logoContainer.addSubview(imageView)
    navigationItem.titleView = logoContainer
    
    self.createTopMenu()
    
    self.userMessageNotificationCenter.delegate = self
    
    self.createNewUsersConnectedSubscription()
    self.createNewMsgSubscription()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.buscarNewMSG()
    //MSGTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(buscarNewMSG), userInfo: nil, repeats: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    //self.MSGTimer.invalidate()
    if self.newMessageSubscriptionID != nil{
      self.chatContainer.publicCloudDatabase.delete(withSubscriptionID: self.newMessageSubscriptionID, completionHandler: { result, error in
        if let error = error {
          print(error.localizedDescription)
        }else{
          self.newMessageSubscriptionID = nil
        }
      })
    }
  }
  
  // MARK: - Helpers
  
  func createTopMenu(){
    self.topMenu.removeFromSuperview()
    self.topMenu = UIView()
    self.topMenu.frame = CGRect(x: 20, y: self.view.bounds.origin.y + 35, width: screenBounds.width - 40, height: 60)
    self.topMenu.layer.cornerRadius = 15
    //self.topMenu.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 0.9)
    //self.topMenu.addShadow()
    
    self.topMenu.tintColor = .black
    
    let baseTitle = UILabel()
    baseTitle.frame = CGRect(x: screenBounds.width/2 - 100, y: 20, width: 220, height: 21)
    baseTitle.textColor = .darkText
    baseTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    baseTitle.text = "Chat"
    //topMenu.addSubview(baseTitle)
    
    let closeBtn = UIButton(type: UIButton.ButtonType.system)
    closeBtn.frame = CGRect(x: topMenu.frame.width - 40, y: 15, width: 30, height: 30)
    closeBtn.setTitleColor(.black, for: .normal)
    closeBtn.setImage(UIImage(named: "close"), for: UIControl.State())
    closeBtn.addTarget(self, action: #selector(closeApp), for: .touchUpInside)
    //topMenu.addSubview(closeBtn)
    
    let usersBtn = UIButton(type: UIButton.ButtonType.system)
    usersBtn.frame = CGRect(x: 10, y: 15, width: 40, height: 40)
    usersBtn.setTitleColor(.black, for: .normal)
    //sendReportBtn.setTitle("PREVIOUS", for: .normal)
    //usersBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 20.0)
    //usersBtn.addBorder()
    usersBtn.setImage(UIImage(named: "users"), for: UIControl.State())
    usersBtn.addTarget(self, action: #selector(showUsers), for: .touchUpInside)
    usersBtn.backgroundColor = .white
    usersBtn.layer.cornerRadius = 5
    usersBtn.addShadow()
    topMenu.addSubview(usersBtn)
    
    let blockUserBtn = UIButton(type: UIButton.ButtonType.system)
    blockUserBtn.frame = CGRect(x: topMenu.frame.width - 140, y: 15, width: 90, height: 30)
    blockUserBtn.setTitleColor(.red, for: .normal)
    blockUserBtn.setTitle("Block", for: .normal)
    usersBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
    //blockUserBtn.setImage(UIImage(named: "bl"), for: UIControl.State())
    blockUserBtn.addTarget(self, action: #selector(showUsers), for: .touchUpInside)
    //topMenu.addSubview(blockUserBtn)
    
    self.view.addSubview(topMenu)
  }
  
  func insertNewMessage(_ message: Message) {
    self.configureMessageCollectionView()
    
    if !messageList.contains{$0.id == message.id}{
      messageList.append(message)
      messageList.sort{$0.sentDate < $1.sentDate}
      messagesCollectionView.reloadData()
      //      let isLatestMessage = messageList.index(of: message) == (messageList.count - 1)
      //      let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
      //
      //      if shouldScrollToBottom {
      //        DispatchQueue.main.async {
      //          self.messagesCollectionView.scrollToBottom(animated: true)
      //        }
      //      }
    }
    
  }
  
  func createNewUsersConnectedSubscription(){
    let predicate = NSPredicate(format:"recordID = %@",CKRecord.ID(recordName: self.userSelected.cloudId))
    let subscription = CKQuerySubscription(recordType: "UsersConnected", predicate: predicate, options: [.firesOnRecordCreation,.firesOnRecordDeletion])
    
    let notification = CKSubscription.NotificationInfo()
    notification.shouldSendContentAvailable = true
    notification.soundName = "default"
    subscription.notificationInfo = notification
    
    self.chatContainer.publicCloudDatabase.save(subscription) { result, error in
      if let error = error {
        print(error.localizedDescription)
      }else{
        self.newUsersSubscriptionID = result?.subscriptionID
      }
    }
  }
  
  func createNewMsgSubscription(){
    print("creating chat message subscription")
    let predicate =  NSPredicate(format: "from == %@ and to == %@",CKRecord.ID(recordName: self.userSelected.cloudId),CKRecord.ID(recordName: GlobalVariables.userLogged.cloudId))
    let subscription = CKQuerySubscription(recordType: "Messages", predicate: predicate, options: [.firesOnRecordCreation])
    
    let notification = CKSubscription.NotificationInfo()
    notification.soundName = "default"
    notification.shouldSendContentAvailable = true
    subscription.notificationInfo = notification
    
    self.chatContainer.publicCloudDatabase.save(subscription) { result, error in
      if let error = error {
        print(error.localizedDescription)
      }else{
        self.newMessageSubscriptionID = result?.subscriptionID
      }
    }
  }
  
  func getRecordFromSubscription(recordName: String){
    if self.userSelected.cloudId == recordName{
      DispatchQueue.main.async {
        let alertaClose = UIAlertController (title: NSLocalizedString("User disconnected",comment:"No user connected"), message: NSLocalizedString("The user were chatting with you has disconnected.", comment:"No user connected"), preferredStyle: UIAlertController.Style.alert)
        alertaClose.addAction(UIAlertAction(title: NSLocalizedString("Find other users connected", comment:"Settings"), style: UIAlertAction.Style.default, handler: {alerAction in
          //self.connectedTimer.invalidate()
          let vc  = R.storyboard.main.usersConnected()
          self.navigationController?.setNavigationBarHidden(false, animated: true)
          self.navigationController?.show(vc!, sender: nil)
        }))
        self.present(alertaClose, animated: true, completion: nil)
        
      }
    }else{
      self.chatContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: recordName), completionHandler: { (record, error) in
        if (error == nil) {
          if (record?.value(forKey: "recordType") as! String) == "Messages"{
            
            let newMessage = Message(newMessage: record!)
            if newMessage.to == GlobalVariables.userLogged.cloudId{
              self.messageList.append(newMessage)
              DispatchQueue.main.async {
                self.configureMessageCollectionView()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
              }
            }
          }else{
            
          }
        }
      })
    }
  }
  
  // END COLLECTION VIEW FUNCTIONS
  @objc func dismissKeyboard() {
    //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
    messageInputBar.inputTextView.resignFirstResponder()
  }
  
  // SENDING BUTTONS FUNCTIONS
  
  //    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
  //      mensajesMostrados.append(JSQMessage(senderId: GlobalVariables.userLogged.Email, displayName: "", text: text))
  //      collectionView.reloadData()
  //      SendNewMessage(text: text)
  //      finishSendingMessage()
  //    }
  //
  //FUNCTION TO SEARCH NEW messageList
  @objc func buscarNewMSG() {
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: GlobalVariables.userLogged.cloudId), action: .none)
    let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.userSelected.cloudId), action: .none)
    let predicateMesajes = NSPredicate(format: "to == %@ and from == %@",toReference,fromReference)
    
    let queryVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
    queryVista.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    self.chatContainer.publicCloudDatabase.perform(queryVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        if (results!.count) > 0{
          var i = 0
          while i < (results!.count){
            let message = Message(newMessage: results![i])
            self.eliminarMSGRead(record: (results![i].recordID))
            if !self.messageList.contains{$0.id == message.id}{
              self.messageList.append(message)
              self.userSelected.NewMsg = false
            }
            
            i += 1
          }
        }
      }else{
        print(error.debugDescription)
      }
      DispatchQueue.main.async {
        self.configureMessageCollectionView()
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
      }
    }))
  }
  
  @objc func showUsers(){
    let vc = R.storyboard.main.usersConnected()
    self.navigationController?.show(vc!, sender: nil)
  }
  
  @objc func closeApp(){
    GlobalVariables.userLogged.desconnect()
  }
  
  @IBAction func BlockUser(_ sender: Any) {
    self.BloUser.isEnabled = false
    GlobalVariables.userLogged.ActualizarBloqueo(userToBlock: self.userSelected.id){ success in
      if success{
        self.MSGTimer.invalidate()
        GlobalVariables.usuariosMostrar.remove(at: self.chatOpenPos)
        DispatchQueue.main.async {
          let vc = R.storyboard.main.inicioView()
          self.navigationController?.show(vc!, sender: nil)
        }
      }
    }
  }
  
  func eliminarMSGRead(record : CKRecord.ID) {
    self.chatContainer.publicCloudDatabase.delete(withRecordID: record, completionHandler: {results, error in
      if error == nil{
        
      }else{
        print(error.debugDescription)
      }
    })
  }
  
  func SendNewMessage(text: String) {
    let newmensaje = Message(from: GlobalVariables.userLogged.cloudId, to: GlobalVariables.usuariosMostrar[chatOpenPos].id, text: text)
  }
  
  func configureMessageCollectionView() {
    
    let outgoingAvatarOverlap: CGFloat = 15
    let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
    layout?.sectionInset = UIEdgeInsets(top: self.messageList.count == 1 ? 80 : 10, left: 8, bottom: 1, right: 8)
    
    // Hide the outgoing avatar and adjust the label alignment to line up with the messages
    layout?.setMessageOutgoingAvatarSize(.zero)
    layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
    layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
    
    // Set outgoing avatar to overlap with the message bubble
    layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: 5, right: 0)))
    layout?.setMessageIncomingAvatarSize(.zero)//CGSize(width: 30, height: 30))
    layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: outgoingAvatarOverlap, left: 3, bottom: 2, right: 18))
    
    layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
    layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
    layout?.setMessageIncomingAccessoryViewPosition(.messageBottom)
    layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
    layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
    
    self.messagesCollectionView.reloadData()
    self.messagesCollectionView.scrollToBottom(animated: true)
  }
}
