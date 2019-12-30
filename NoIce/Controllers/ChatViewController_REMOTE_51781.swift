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

class ChatViewController: MessagesViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
  
  var chatOpenPos: Int!
  var MSGTimer : Timer!
  var MSGContainer = CKContainer.default()
  var tap: UITapGestureRecognizer!
  var topMenu = UIView()
  
  var messageList: [Message] = []
  
  var firstMessage = true
  
  @IBOutlet weak var BloUser: UIBarButtonItem!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messageCellDelegate = self
    messageInputBar.delegate = self
    
    let screenBounds = UIScreen.main.bounds
    
    self.BloUser.isEnabled = false
    //    self.senderId = MyVariables.userLogged.Email
    //    self.senderDisplayName = ""
    
    //Hide adjunte button
    //self.inputToolbar.contentView.leftBarButtonItem = nil
    
    let image = MyVariables.usuariosMostrar[self.chatOpenPos].FotoPerfil
    
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
    
    //Tab bar User Photo
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
    
    self.topMenu.removeFromSuperview()
    self.topMenu = UIView()
    self.topMenu.frame = CGRect(x: 20, y: self.view.bounds.origin.y + 50, width: screenBounds.width - 40, height: 50)
    self.topMenu.layer.cornerRadius = 15
    self.topMenu.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 0.9)
    self.topMenu.addShadow()
    
    self.topMenu.tintColor = .black
    
    let baseTitle = UILabel()
    baseTitle.frame = CGRect(x: screenBounds.width/2 - 100, y: 15, width: 220, height: 21)
    baseTitle.textColor = .darkText
    baseTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    baseTitle.text = "Chat"
    topMenu.addSubview(baseTitle)
    
    let closeBtn = UIButton(type: UIButton.ButtonType.system)
    closeBtn.frame = CGRect(x: topMenu.frame.width - 40, y: 10, width: 30, height: 30)
    closeBtn.setTitleColor(.black, for: .normal)
    //sendReportBtn.setTitle("NEXT", for: .normal)
    //closeBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 20.0)
    //closeBtn.addBorder()
    closeBtn.setImage(UIImage(named: "close"), for: UIControl.State())
    closeBtn.addTarget(self, action: #selector(closeApp), for: .touchUpInside)
    topMenu.addSubview(closeBtn)
    
    let usersBtn = UIButton(type: UIButton.ButtonType.system)
    usersBtn.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
    usersBtn.setTitleColor(.black, for: .normal)
    //sendReportBtn.setTitle("PREVIOUS", for: .normal)
    //usersBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 20.0)
    //usersBtn.addBorder()
    usersBtn.setImage(UIImage(named: "users"), for: UIControl.State())
    usersBtn.addTarget(self, action: #selector(showUsers), for: .touchUpInside)
    topMenu.addSubview(usersBtn)
    
    let blockUserBtn = UIButton(type: UIButton.ButtonType.system)
    blockUserBtn.frame = CGRect(x: topMenu.frame.width - 140, y: 10, width: 90, height: 30)
    blockUserBtn.setTitleColor(.red, for: .normal)
    blockUserBtn.setTitle("Block", for: .normal)
    usersBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
    //usersBtn.addBorder()
    blockUserBtn.setImage(UIImage(named: "bl"), for: UIControl.State())
    blockUserBtn.addTarget(self, action: #selector(showUsers), for: .touchUpInside)
    topMenu.addSubview(blockUserBtn)
    
    self.view.addSubview(topMenu)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.BuscarNewMSG()
    MSGTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BuscarNewMSG), userInfo: nil, repeats: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.MSGTimer.invalidate()
  }
  
  // MARK: - Helpers
  
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
  
  
  
  // END COLLECTION VIEW FUNCTIONS
  @objc func dismissKeyboard() {
    //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
    print("here")
    messageInputBar.inputTextView.resignFirstResponder()
  }
  
  // SENDING BUTTONS FUNCTIONS
  
  //    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
  //      mensajesMostrados.append(JSQMessage(senderId: MyVariables.userLogged.Email, displayName: "", text: text))
  //      collectionView.reloadData()
  //      SendNewMessage(text: text)
  //      finishSendingMessage()
  //    }
  //
  //FUNCTION TO SEARCH NEW messageList
  @objc func BuscarNewMSG() {
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: MyVariables.userLogged.id), action: .none)
    let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: MyVariables.usuariosMostrar[self.chatOpenPos].id), action: .none)
    let predicateMesajes = NSPredicate(format: "to == %@ and from == %@",toReference,fromReference)
    
    let queryVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
    queryVista.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    self.MSGContainer.publicCloudDatabase.perform(queryVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        if (results!.count) > 0{
          //self.messageList.removeAll()
          var i = 0
          while i < (results!.count){
            let message = Message(newMessage: results![i])
            self.EliminarMSGRead(record: (results![i].recordID))
            if !self.messageList.contains{$0.id == message.id}{
              self.messageList.append(message)
              MyVariables.usuariosMostrar[self.chatOpenPos].NewMsg = false
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
    MyVariables.userLogged.ActualizarConectado(estado: "0")
  }
  
  @IBAction func BlockUser(_ sender: Any) {
    self.BloUser.isEnabled = false
    //      MyVariables.userLogged.ActualizarBloqueo(emailBloqueado: MyVariables.usuariosMostrar[self.chatOpenPos].Email){ success in
    //        if success{
    //          self.MSGTimer.invalidate()
    //          MyVariables.usuariosMostrar.remove(at: self.chatOpenPos)
    //          DispatchQueue.main.async {
    //            let vc = R.storyboard.main.inicioView()
    //            //let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InicioView") as! InicioController
    //            self.navigationController?.show(vc!, sender: nil)
    //          }
    //        }
    //      }
  }
  
  func EliminarMSGRead(record : CKRecord.ID) {
    self.MSGContainer.publicCloudDatabase.delete(withRecordID: record, completionHandler: {results, error in
      if error == nil{
        
      }else{
        print(error.debugDescription)
      }
    })
  }
  
  func SendNewMessage(text: String) {
    let newmensaje = Message(from: MyVariables.userLogged.id, to: MyVariables.usuariosMostrar[chatOpenPos].id, text: text)
  }
  
  func configureMessageCollectionView() {
    
    let outgoingAvatarOverlap: CGFloat = 15
    let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
    layout?.sectionInset = UIEdgeInsets(top: self.messageList.count == 1 ? 80 : 5, left: 8, bottom: 1, right: 8)
    
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



//    // COLLECTION VIEW FUNCTIONS
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
//
//      let bubbleFactory = JSQMessagesBubbleImageFactory()
//      let message = mensajesMostrados[indexPath.item]
//      collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
//      if message.senderId == self.senderId {
//        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
//      } else {
//        return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1))
//        //Blue color  red: 141/255, green: 168/255, blue: 217/255, alpha: 1
//      }
//
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!{
//      let message = mensajesMostrados[indexPath.item]
//
//      if message.senderId == self.senderId {
//        return nil //JSQMessagesAvatarImageFactory.avatarImage(with: MyVariables.userLogged.FotoPerfil, diameter: 70)
//      } else {
//        return nil //JSQMessagesAvatarImageFactory.avatarImage(with: MyVariables.usuariosMostrar[self.chatOpenPos].FotoPerfil, diameter: 70)
//      }
//
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
//      return mensajesMostrados[indexPath.item]
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
//      self.dismissKeyboard()
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
//
//      let msg = mensajesMostrados[indexPath.item]
//      self.dismissKeyboard()
//      if msg.isMediaMessage {
//        if let mediaItem = msg.media as? JSQVideoMediaItem {
//          let player = AVPlayer(url: mediaItem.fileURL)
//          let playerController = AVPlayerViewController()
//          playerController.player = player;
//          self.present(playerController, animated: true, completion: nil)
//        }
//      }
//
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//      return mensajesMostrados.count;
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
//      cell.textView.textColor = UIColor.black
//
//      return cell
//    }
