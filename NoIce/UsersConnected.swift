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

class UsersConnected: UIViewController, UIGestureRecognizerDelegate {
  
  var userContainer = CKContainer.default()
  var connectedTimer: Timer!
  
  //INTERFACES VARIABLES
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var helpView: UIView!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet weak var helpTextView: UITextView!
  @IBOutlet weak var headerView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.headerView.addShadow()
    self.helpView.addShadow()
    self.collectionView.reloadSections(IndexSet(integer: 0))
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hiddeTextView))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    self.collectionView.addGestureRecognizer(tapGesture)
    
    self.helpTextView.text = NSLocalizedString("Click photo to chat or Slide it to hide and block.", comment: "")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if GlobalVariables.usuariosMostrar.count == 0{
      let vc = R.storyboard.main.inicioView()
      self.navigationController?.show(vc!, sender: nil)
    }else{
      connectedTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(BuscarUsuariosConectados), userInfo: nil, repeats: true)
      self.collectionView.reloadData()
    }
    
  }
  
  //CUSTOM FUNCTIONS
  @objc func BuscarUsuariosConectados(){
    print("buscando")
    let userLoggedReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: GlobalVariables.userLogged.cloudId), action: .none)
    let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(location, %@) < 100 and recordID != %@",GlobalVariables.userLogged.location, userLoggedReference)
    let queryUsuarioIn = CKQuery(recordType: "UsersConnected",predicate: predicateUsuarioIn)
    queryUsuarioIn.sortDescriptors = [CKLocationSortDescriptor(key: "location", relativeLocation: GlobalVariables.userLogged.location)]
    self.userContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        GlobalVariables.usuariosMostrar.removeAll()
        if (results?.count)! > 0{
          var i = 0
          while i < (results?.count)!{
//            let bloqueados = results?[i].value(forKey: "bloqueados") as! [String]
//            if !bloqueados.contains(GlobalVariables.userLogged.cloudId) && !GlobalVariables.userLogged.bloqueados.contains(results?[i].value(forKey: "recordName") as! String){
//              let usuarioTemp = User(user: results![i])
//              if !GlobalVariables.usuariosMostrar.contains{$0.id == usuarioTemp.id}{
//                GlobalVariables.usuariosMostrar.append(usuarioTemp)
//              }
//              //usuarioTemp.BuscarNuevosMSG(userDestino: GlobalVariables.userLogged!.recordID)
//              //GlobalVariables.usuariosMostrar.append(usuarioTemp)
//            }
            let usuarioTemp = User(user: results![i])
            if !GlobalVariables.usuariosMostrar.contains{$0.cloudId == usuarioTemp.cloudId}{
              print("here")
              GlobalVariables.usuariosMostrar.append(usuarioTemp)
            }
            //usuarioTemp.BuscarNuevosMSG(userDestino: GlobalVariables.userLogged.cloudId)
            i += 1
          }
          self.BuscarNuevosMSG()
        }
      }else{
        print("ERROR DE CONSULTA " + error.debugDescription)
      }
    }))
    
  }
  
  func BuscarNuevosMSG() {
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: GlobalVariables.userLogged.cloudId), action: .none)
    //let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.id), action: .none)
    let predicateMesajes = NSPredicate(format: "to == %@",toReference)
    
    let queryMSGVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
    
    self.userContainer.publicCloudDatabase.perform(queryMSGVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        if (results?.count)! > 0{
          var i = 0
          while i < (GlobalVariables.usuariosMostrar.count){
            if ((results?.contains{($0.value(forKey: "from") as? CKRecord.Reference)!.recordID.recordName == GlobalVariables.usuariosMostrar[i].id})!) {
              GlobalVariables.usuariosMostrar[i].NewMsg = true
            }else{
              GlobalVariables.usuariosMostrar[i].NewMsg = false
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
  
  func blockUser(userToBlock: String){
    GlobalVariables.userLogged.ActualizarBloqueo(userToBlock: userToBlock, completionHandler: { success in
      if success {
        GlobalVariables.usuariosMostrar.removeAll{$0.id == userToBlock}
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
    GlobalVariables.userLogged.desconnect()//desconnect
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
