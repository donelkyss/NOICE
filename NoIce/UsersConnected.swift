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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.delegate = self
    self.collectionView.reloadSections(IndexSet(integer: 0))
    
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
    
    let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(posicion, %@) < 300 and conectado == %@",MyVariables.userLogged.Posicion, "1")
    let queryUsuarioIn = CKQuery(recordType: "UsersProfile",predicate: predicateUsuarioIn)
    self.userContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        
        MyVariables.usuariosMostrar.removeAll()
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
            if results![i].recordID.recordName != MyVariables.userLogged.id{
              let usuarioTemp = User(user: results![i])
              usuarioTemp.BuscarNuevosMSG(userDestino: MyVariables.userLogged.id)
              MyVariables.usuariosMostrar.append(usuarioTemp)
            }
            i += 1
          }
        }
      }else{
        print("ERROR DE CONSULTA " + error.debugDescription)
      }
    }))
    
    
   
//    let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(posicion, %@) < 100 and conectado == %@ and recordName != %@", MyVariables.userLogged.Posicion, "1", MyVariables.userLogged.recordID.recordName)
//
//    let queryUsuarioIn = CKQuery(recordType: "UsersProfile",predicate: predicateUsuarioIn)
//    self.userContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
//      if (error == nil) {
//        MyVariables.usuariosMostrar.removeAll()
//
//        //if (results?.count)! != MyVariables.usuariosMostrar.count{
//        if (results?.count)! > 0{
//          var bloqueados = [String]()
//          var i = 0
//          while i < (results?.count)!{
//            bloqueados = results?[i].value(forKey: "bloqueados") as! [String]
//            if  !bloqueados.contains(MyVariables.userLogged.recordID.recordName) && !MyVariables.userLogged.bloqueados.contains(results?[i].value(forKey: "recordName") as! String){
//              let usuarioTemp = User(user: results![i])
//              usuarioTemp.BuscarNuevosMSG(userDestino: MyVariables.userLogged!.recordID)
//              MyVariables.usuariosMostrar.append(usuarioTemp)
//            }
//            i += 1
//          }
//          DispatchQueue.main.async {
//            self.collectionView.reloadData()
//          }
//        }else{
//          self.connectedTimer.invalidate()
//          let alertaClose = UIAlertController (title: NSLocalizedString("No user connected",comment:"No user connected"), message: NSLocalizedString("There aren't any user connected near you.", comment:"No hay usuarios conectados"), preferredStyle: UIAlertController.Style.alert)
//          alertaClose.addAction(UIAlertAction(title: NSLocalizedString("Close", comment:"Cerrar"), style: UIAlertAction.Style.default, handler: {alerAction in
//            let vc = R.storyboard.main.profileView()
//            //let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileController
//            self.navigationController?.show(vc!, sender: nil)
//          }))
//          self.present(alertaClose, animated: true, completion: nil)
//        }
//      }else{
//        print("ERROR DE CONSULTA " + error.debugDescription)
//      }
//    }))
    
  }
  
  @objc func hiddeTextView(sender: UITapGestureRecognizer){
    self.helpView.isHidden = true
  }

  @IBAction func CloseApp(_ sender: Any) {
    MyVariables.userLogged.ActualizarConectado(estado: "0")
  }
  @IBAction func showHelp(_ sender: Any) {
    self.helpView.isHidden = !self.helpView.isHidden
  }
  
}
