//
//  User.swift
//  NoIce
//
//  Created by Done Santana on 14/1/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

class User{
  //Atributos
  var id: String!
  var FotoPerfil: UIImage!
  var Posicion: CLLocation!
  var conectado: String!
  var NewMsg: Bool!
  var bloqueados: [String]!
  
  var UserContainer = CKContainer.default()
 
  //Métodos
  init(user: CKRecord){
    do{
      let photo = user.value(forKey: "foto") as! CKAsset
      let photoPerfil = try Data(contentsOf: photo.fileURL! as URL)
      self.FotoPerfil = UIImage(data: photoPerfil)!
    }catch{
      self.FotoPerfil = UIImage(named: "user")!
    }
    self.id = user.recordID.recordName
    self.Posicion = user.value(forKey: "posicion") as? CLLocation
    self.bloqueados = user.value(forKey: "bloqueados") as? [String]
    self.conectado = "1"
    self.NewMsg = false
    
  }
  
  init(NombreApellidos: String, Email: String, photo: CKAsset, pos: CLLocation){
    
    let recordUser = CKRecord(recordType:"Users")
    recordUser.setObject(photo as CKRecordValue, forKey: "foto")
    recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
    recordUser.setObject("1" as CKRecordValue, forKey: "conectado")
    recordUser.setObject(pos as CKRecordValue, forKey: "posicion")
    
    self.UserContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
      if error == nil{
        self.id = record?.recordID.recordName
      }else{
        print("error \(error.debugDescription)")
      }
    })
    
    self.bloqueados = ["nadie"]
    self.Posicion = pos
    do{
      let photoPerfil = try Data(contentsOf: photo.fileURL! as URL)
      self.FotoPerfil = UIImage(data: photoPerfil)!
    }catch{
      self.FotoPerfil = UIImage(named: "user")!
    }
    self.conectado = "1"
    self.NewMsg = false
  }

  func ActualizarPosicion(posicionActual: CLLocation) {
    
    self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.id), completionHandler: { (record, error) in
      if error != nil {
        print("Error fetching  position record: \(String(describing: error?.localizedDescription))")
      } else {
        record?.setObject(posicionActual as CKRecordValue?, forKey: "posicion")
        // Save this record again
        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
          if saveError != nil {
            print("Error saving position: \(String(describing: saveError?.localizedDescription))")
            self.ActualizarPosicion(posicionActual: posicionActual)
          } else {
            print("position updated")
            self.Posicion = posicionActual
          }
        })
      }
      
    })
  }
  
  func ActualizarConectado(estado: String){
    
    self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.id), completionHandler: { (record, error) in
      if error != nil {
        print("Error fetching conectado record: \(String(describing: error?.localizedDescription))")
      } else {
        record?.setObject(estado as CKRecordValue?, forKey: "conectado")
        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
          if saveError != nil {
            print("Error saving conectado: \(String(describing: saveError?.localizedDescription))")
            self.ActualizarConectado(estado: estado)
            exit(0)
          } else {
            if estado == "1"{
              self.conectado = estado
              print("Estado Acutalizado")
            }else{
              exit(0)
            }
          }
        })
      }
    })
  }
  
  func ActualizarPhoto(newphoto: UIImage){
    let imagenURL = self.saveImageToFile(newphoto)
    let photoUser = CKAsset(fileURL: imagenURL)
    self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.id), completionHandler: { (record, error) in
      if error != nil {
        print("Error fetching photo record: \(String(describing: error?.localizedDescription))")
      } else {
        
        record?.setObject(photoUser as CKRecordValue?, forKey: "foto")
        
        // Save this record again
        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
          if saveError != nil {
            print("Error saving newPhoto: \(String(describing: saveError?.localizedDescription))")
            self.ActualizarPhoto(newphoto: newphoto)
          } else {
            self.FotoPerfil = newphoto
            MyVariables.userLogged.FotoPerfil = newphoto
          }
        })
      }
    })
  }
  
  func BuscarNuevosMSG(userDestino: String) {
    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: userDestino), action: .none)
    let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.id), action: .none)
    let predicateMesajes = NSPredicate(format: "to == %@ and from == %@",toReference, fromReference)
    
    let queryMSGVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
    
    self.UserContainer.publicCloudDatabase.perform(queryMSGVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        if (results?.count)! > 0{
          self.NewMsg = true
        }
      }else{
        print(error.debugDescription)
      }
    }))
    
  }
  
//  func ActualizarBloqueo(emailBloqueado: String, completionHandler: @escaping(Bool)->()){
//    self.bloqueados.append(emailBloqueado)
//
//    self.UserContainer.publicCloudDatabase.fetch(withRecordID: self.id, completionHandler: { (record, error) in
//      if error != nil {
//        print("Error fetching bloqueados record: \(String(describing: error?.localizedDescription))")
//      } else {
//        record?.setObject(self.bloqueados as CKRecordValue?, forKey: "bloqueados")
//        // Save this record again
//        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
//          if saveError != nil {
//            completionHandler(false)
//          } else {
//            completionHandler(true)
//          }
//        })
//      }
//
//    })
//  }
//  func CargarBloqueados(bloqueados: [String]){
//    self.bloqueados = bloqueados
//  }
  
  //RENDER IMAGEN
  func saveImageToFile(_ image: UIImage) -> URL
  {
    let filemgr = FileManager.default
    
    let dirPaths = filemgr.urls(for: .documentDirectory,
                                in: .userDomainMask)
    
    let fileURL = dirPaths[0].appendingPathComponent("currentImage.jpg")
    
    if let renderedJPEGData =
      image.jpegData(compressionQuality: 0.5) {
      try! renderedJPEGData.write(to: fileURL)
    }
    
    return fileURL
  }
  
}
