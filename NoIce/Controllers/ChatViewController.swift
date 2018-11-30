//
//  ChatVC.swift
//  Chat App For iOS 10
//
//  Created by MacBook on 11/23/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import CloudKit

class ChatViewController: JSQMessagesViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var chatOpenPos: Int!
    var MSGTimer : Timer!
    var MSGContainer = CKContainer.default()
    var tap: UITapGestureRecognizer!
    
    @IBOutlet weak var BlocUser: UIBarButtonItem!
    
    var mensajesMostrados = [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.BlocUser.isEnabled = false
        self.senderId = myvariables.userperfil.Email
        self.senderDisplayName = ""

        //Hide avatar
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        //Hide adjunte button
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        let image = myvariables.usuariosMostrar[self.chatOpenPos].FotoPerfil
        let imgBackground:UIImageView = UIImageView(frame: self.view.bounds)
        imgBackground.image = image
        imgBackground.contentMode = UIView.ContentMode.scaleAspectFill
        imgBackground.clipsToBounds = true
        self.collectionView?.backgroundView = imgBackground
        
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        collectionView.addGestureRecognizer(self.tap)
        //Descomentar, si el tap no debe interferir o cancelar otras acciones
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(self.tap)
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.BuscarNewMSG()
        MSGTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BuscarNewMSG), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
           self.MSGTimer.invalidate()
        
    }
    
    // COLLECTION VIEW FUNCTIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {

        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = mensajesMostrados[indexPath.item]
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1))
            //Blue color  red: 141/255, green: 168/255, blue: 217/255, alpha: 1
        }
         
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!{
        let message = mensajesMostrados[indexPath.item]
        
        if message.senderId == self.senderId {
            return nil //JSQMessagesAvatarImageFactory.avatarImage(with: myvariables.userperfil.FotoPerfil, diameter: 70)
        } else {
            return nil //JSQMessagesAvatarImageFactory.avatarImage(with: myvariables.usuariosMostrar[self.chatOpenPos].FotoPerfil, diameter: 70)
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return mensajesMostrados[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        self.dismissKeyboard()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = mensajesMostrados[indexPath.item]
        self.dismissKeyboard()
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player;
                self.present(playerController, animated: true, completion: nil)
            }
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mensajesMostrados.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
       
        cell.textView.textColor = UIColor.black

        return cell
    }
    
    // END COLLECTION VIEW FUNCTIONS
    @objc func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }
    
    // SENDING BUTTONS FUNCTIONS
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        mensajesMostrados.append(JSQMessage(senderId: myvariables.userperfil.Email, displayName: "", text: text))
        collectionView.reloadData()
        SendNewMessage(text: text)
        finishSendingMessage()
    }
    
    //FUNCTION TO SEARCH NEW MESSAGES
    @objc func BuscarNewMSG() {
        let predicateMesajes = NSPredicate(format: "destinoEmail == %@ and emisorEmail == %@", myvariables.userperfil.Email, myvariables.usuariosMostrar[self.chatOpenPos].Email)
        
        let queryVista = CKQuery(recordType: "CMensaje",predicate: predicateMesajes)
        queryVista.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        self.MSGContainer.publicCloudDatabase.perform(queryVista, inZoneWith: nil, completionHandler: ({results, error in
            if (error == nil) {
                
                if (results?.count)! > 0{
                    var i = 0
                    while i < (results?.count)!{
                        let MSG = JSQMessage(senderId: results?[i].value(forKey: "emisorEmail") as! String, displayName: "", text: results?[i].value(forKey: "textoMensaje") as! String)
                        self.EliminarMSGRead(record: (results?[i].recordID)!)
                        self.mensajesMostrados.append(MSG!)
                        myvariables.usuariosMostrar[self.chatOpenPos].NewMsg = false
                        i += 1
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }))
    }
    
    @IBAction func BlockUser(_ sender: Any) {
        self.BlocUser.isEnabled = false
        myvariables.userperfil.ActualizarBloqueo(emailBloqueado: myvariables.usuariosMostrar[self.chatOpenPos].Email){ success in
            if success{
                self.MSGTimer.invalidate()
                myvariables.usuariosMostrar.remove(at: self.chatOpenPos)
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InicioView") as! InicioController
                    self.navigationController?.show(vc, sender: nil)
                }
            }
        }
    }
   
    func EliminarMSGRead(record : CKRecord.ID) {
        self.MSGContainer.publicCloudDatabase.delete(withRecordID: record, completionHandler: {results, error in
            if error == nil{

            }else{
                print(error)
            }
        })
    }
    
    func SendNewMessage(text: String) {
            let newmensaje = CMensaje(emailEmisor: myvariables.userperfil.Email, emailDestino: myvariables.usuariosMostrar[chatOpenPos].Email, mensaje: text)
            newmensaje.EnviarMensaje()
    }
}

extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window = window else { return }
        if #available(iOS 11.0, *) {
            let anchor = window.safeAreaLayoutGuide.bottomAnchor
            bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1.0).isActive = true
        }
    }
}








































