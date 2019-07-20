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
    self.collectionView.delegate = self
    self.collectionView.reloadSections(IndexSet(integer: 0))
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hiddeTextView))
    tapGesture.cancelsTouchesInView = false
    tapGesture.delegate = self
    self.collectionView.addGestureRecognizer(tapGesture)
    
    self.helpTextView.text = NSLocalizedString("Click photo to chat or Slide it to hide and block.", comment: "")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if MyVariables.usuariosMostrar.count == 0{
      let vc = R.storyboard.main.inicioView()
      //let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InicioView") as! InicioController
      self.navigationController?.show(vc!, sender: nil)
    }else{
      connectedTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BuscarUsuariosConectados), userInfo: nil, repeats: true)
      self.collectionView.reloadData()
    }
    
  }
  
  //CUSTOM FUNCTIONS
  @objc func BuscarUsuariosConectados(){
    let userLoggedReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: MyVariables.userLogged.id), action: .none)
    let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(posicion, %@) < 50 and conectado == %@ and recordID != %@",MyVariables.userLogged.Posicion, "1", userLoggedReference)
    let queryUsuarioIn = CKQuery(recordType: "UsersProfile",predicate: predicateUsuarioIn)
    self.userContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        //MyVariables.usuariosMostrar.removeAll()
        if (results?.count)! > 0{
          var i = 0
          while i < (results?.count)!{
            //
            //              let bloqueados = results?[i].value(forKey: "bloqueados") as! [String]
            //              if !bloqueados.contains(MyVariables.userLogged.recordID.recordName) && !MyVariables.userLogged.bloqueados.contains(results?[i].value(forKey: "recordName") as! String){
            //                print("hereee")
            //                let usuarioTemp = User(user: results![i])
            //                usuarioTemp.BuscarNuevosMSG(userDestino: MyVariables.userLogged!.recordID)
            //                MyVariables.usuariosMostrar.append(usuarioTemp)
            //              }
            let usuarioTemp = User(user: results![i])
            if !MyVariables.usuariosMostrar.contains{$0.id == usuarioTemp.id}{
              MyVariables.usuariosMostrar.append(usuarioTemp)
            }
            //usuarioTemp.BuscarNuevosMSG(userDestino: MyVariables.userLogged.id)
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
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: MyVariables.userLogged.id), action: .none)
    //let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.id), action: .none)
    let predicateMesajes = NSPredicate(format: "to == %@",toReference)
    
    let queryMSGVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
    
    self.userContainer.publicCloudDatabase.perform(queryMSGVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        if (results?.count)! > 0{
          var i = 0
          while i < (MyVariables.usuariosMostrar.count){
            if ((results?.contains{($0.value(forKey: "from") as? CKRecord.Reference)!.recordID.recordName == MyVariables.usuariosMostrar[i].id})!) {
              MyVariables.usuariosMostrar[i].NewMsg = true
            }else{
              MyVariables.usuariosMostrar[i].NewMsg = false
            }
            i += 1
          }
          DispatchQueue.main.async {
            self.collectionView.reloadData()
          }
        }
      }else{
        print(error.debugDescription)
      }
    }))
    
  }
  
  @objc func hiddeTextView(sender: UITapGestureRecognizer){
    self.helpView.isHidden = true
  }
  @IBAction func showMenu(_ sender: Any) {
    
  }
  
  @IBAction func CloseApp(_ sender: Any) {
    MyVariables.userLogged.ActualizarConectado(estado: "0")
  }
  @IBAction func showHelp(_ sender: Any) {
    self.helpView.isHidden = !self.helpView.isHidden
  }
  
}
