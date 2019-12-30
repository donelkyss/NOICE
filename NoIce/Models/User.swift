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
  var cloudId: String!
  var photoProfile: UIImage!
  var location: CLLocation!
  var bloqueados: [String]!
  var NewMsg: Bool!
  
  var UserContainer = CKContainer.default()
 
  //Create user from cloud data
  init(user: CKRecord){
    do{
      let photo = user.value(forKey: "photo") as! CKAsset
      let photoPerfil = try Data(contentsOf: photo.fileURL! as URL)
      self.photoProfile = UIImage(data: photoPerfil)!
    }catch{
      self.photoProfile = UIImage(named: "user")!
    }
    self.cloudId = user.recordID.recordName
    self.location = user.value(forKey: "location") as? CLLocation
    self.bloqueados = user.value(forKey: "bloqueados") as? [String]
    self.NewMsg = false
  }

  func Actualizarlocation(locationActual: CLLocation) {
    
    self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.cloudId), completionHandler: { (record, error) in
      if error != nil {
        print("Error fetching  position record: \(String(describing: error?.localizedDescription))")
      } else {
        record?.setObject(locationActual as CKRecordValue?, forKey: "location")
        // Save this record again
        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
          if saveError != nil {
            print("Error saving position: \(String(describing: saveError?.localizedDescription))")
            self.Actualizarlocation(locationActual: locationActual)
          } else {
            self.location = locationActual
          }
        })
      }
      
    })
  }
  
  func desconnect(){
    self.UserContainer.publicCloudDatabase.delete(withRecordID: CKRecord.ID(recordName: self.cloudId), completionHandler: { (record, error) in
      exit(0)
    })
  }
//  func ActualizarConectado(estado: String){
//    if estado == "0"{
//      self.UserContainer.publicCloudDatabase.delete(withRecordID: CKRecord.ID(recordName: self.cloudId), completionHandler: { (record, error) in
//        exit(0)
//      })
//    }else{
//      let imagenURL = self.saveImageToFile(self.photoProfile!)
//
//      GlobalVariables.userDefaults.set(imagenURL, forKey: "profilePhoto")
//
//      let photoContenido = CKAsset(fileURL: imagenURL)
//
//      let recordUser = CKRecord(recordType:"UsersConnected")
//      recordUser.setObject(photoContenido as CKRecordValue, forKey: "photo")
//      recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
//      recordUser.setObject(self.location as CKRecordValue, forKey: "location")
//
//      self.UserContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
//        if error == nil{
//          self.cloudId = record?.recordID.recordName
//        }else{
//          print("error \(error.debugDescription)")
//        }
//      })
//
//      self.bloqueados = ["nadie"]
//      self.location = pos
//      do{
//        let photoPerfil = try Data(contentsOf: photo.fileURL! as URL)
//        self.photoProfile = UIImage(data: photoPerfil)!
//      }catch{
//        self.photoProfile = UIImage(named: "user")!
//      }
////      let recordUser = CKRecord(recordType:"UsersConnected")
////      let userIdReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.cloudId), action: .deleteSelf)
////          recordUser.setObject(userIdReference as CKRecordValue, forKey: "userId")
////          recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
////          recordUser.setObject(self.location as CKRecordValue, forKey: "location")
////
////          self.UserContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
////            if error == nil{
////              self.cloudId = record?.recordID.recordName
////            }else{
////              print("error \(error.debugDescription)")
////            }
////          })
//    }
  
//    self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.cloudId), completionHandler: { (record, error) in
//      if error != nil {
//        print("Error fetching conectado record: \(String(describing: error?.localizedDescription))")
//      } else {
//        record?.setObject(estado as CKRecordValue?, forKey: "conectado")
//        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
//          if saveError != nil {
//            print("Error saving conectado: \(String(describing: saveError?.localizedDescription))")
//            self.ActualizarConectado(estado: estado)
//            exit(0)
//          } else {
//            if estado == "1"{
//              self.conectado = estado
//              print("Estado Acutalizado")
//            }else{
//              exit(0)
//            }
//          }
//        })
//      }
//    })
//  }
  
  func ActualizarPhoto(newphoto: UIImage){
    print("here")
    if !newphoto.isEqual(GlobalVariables.userLogged.photoProfile){

      let imagenURL = newphoto.saveImageToFile()
      let photoUser = CKAsset(fileURL: imagenURL)
      self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.cloudId), completionHandler: { (record, error) in
        if error != nil {
          print("Error fetching photo record: \(String(describing: error?.localizedDescription))")
        } else {
          record?.setObject(photoUser as CKRecordValue?, forKey: "photo")
          
          // Save this record again
          self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
            if saveError != nil {
              print("Error saving newPhoto: \(String(describing: saveError?.localizedDescription))")
              self.ActualizarPhoto(newphoto: newphoto)
            } else {
              self.photoProfile = newphoto
              GlobalVariables.userLogged.photoProfile = newphoto
            }
          })
        }
      })
    }else{
      print("photos are iquals")
    }
  }
  
//  func BuscarNuevosMSG(userDestino: String) {
//    let toReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: userDestino), action: .none)
//    let fromReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: self.cloudId), action: .none)
//    let predicateMesajes = NSPredicate(format: "to == %@ and from == %@",toReference, fromReference)
//
//    let queryMSGVista = CKQuery(recordType: "Messages",predicate: predicateMesajes)
//
//    self.UserContainer.publicCloudDatabase.perform(queryMSGVista, inZoneWith: nil, completionHandler: ({results, error in
//      if (error == nil) {
//        if (results?.count)! > 0{
//          self.NewMsg = true
//        }
//      }else{
//        print(error.debugDescription)
//      }
//    }))
//
//  }
  
  func ActualizarBloqueo(userToBlock: String, completionHandler: @escaping(Bool)->()){
    self.bloqueados.append(userToBlock)

    self.UserContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: self.cloudId), completionHandler: { (record, error) in
      if error != nil {
        print("Error fetching bloqueados record: \(String(describing: error?.localizedDescription))")
      } else {
        record?.setObject(self.bloqueados as CKRecordValue?, forKey: "bloqueados")
        // Save this record again
        self.UserContainer.publicCloudDatabase.save(record!, completionHandler: { (savedRecord, saveError) in
          if saveError != nil {
            completionHandler(false)
          } else {
            completionHandler(true)
          }
        })
      }
    })
  }
  
//  func CargarBloqueados(bloqueados: [String]){
//    self.bloqueados = bloqueados
//  }
  
}
