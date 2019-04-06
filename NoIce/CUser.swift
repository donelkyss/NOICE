//
//  CUser.swift
//  NoIce
//
//  Created by Done Santana on 14/1/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

class CUser{
    //Atributos
    var NombreApellidos: String!
    var Email: String!
    var Telefono: String!
    var FotoPerfil: UIImage!
    var Posicion: CLLocation!
    var UserContainer = CKContainer.default()
    var conectado: String!
    var NewMsg: Bool!
    var bloqueados: [String]!
    var recordID: CKRecord.ID!
    
    //Métodos
    init(user: CKRecord){
        do{
            let photo = user.value(forKey: "foto") as! CKAsset
            let photoPerfil = try Data(contentsOf: photo.fileURL as URL)
            self.FotoPerfil = UIImage(data: photoPerfil)!
        }catch{
            self.FotoPerfil = UIImage(named: "user")!
        }
        self.recordID = user.recordID
        self.NombreApellidos = user.value(forKey: "nombreApellidos") as? String
        self.Email = user.value(forKey: "email") as? String
        self.Telefono = "999999999"//user.value(forKey: "telefono") as! String
        self.Posicion = user.value(forKey: "posicion") as? CLLocation
        self.bloqueados = user.value(forKey: "bloqueados") as? [String]
        self.conectado = "1"
        self.NewMsg = false
    
    }
    
    init(NombreApellidos: String, Email: String, photo: CKAsset, pos: CLLocation){
        
        let recordUser = CKRecord(recordType:"CUsuarios")
        recordUser.setObject(Email as CKRecordValue, forKey: "email")
        recordUser.setObject(NombreApellidos as CKRecordValue, forKey: "nombreApellidos")
        recordUser.setObject(photo as CKRecordValue, forKey: "foto")
        recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
        recordUser.setObject("1" as CKRecordValue, forKey: "conectado")
        recordUser.setObject(pos as CKRecordValue, forKey: "posicion")
        
        self.UserContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
            if error == nil{
               self.recordID = record?.recordID
            }else{
                print("error \(error.debugDescription)")
            }
        })
        
        self.bloqueados = ["nadie"]
        self.Posicion = pos
        self.NombreApellidos = NombreApellidos
        self.Email = Email
        do{
            let photoPerfil = try Data(contentsOf: photo.fileURL as URL)
            self.FotoPerfil = UIImage(data: photoPerfil)!
        }catch{
            self.FotoPerfil = UIImage(named: "user")!
        }
        self.Telefono = "999999999"//user.value(forKey: "telefono") as! String
        self.Posicion = pos
        self.conectado = "1"
        self.NewMsg = false
        
    }
    
    func ActualizarTelefono(movil: String){
        self.Telefono = movil
    }
    
    func ActualizarPosicion(posicionActual: CLLocation) {
        
        self.UserContainer.publicCloudDatabase.fetch(withRecordID: self.recordID!, completionHandler: { (record, error) in
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
        
        self.UserContainer.publicCloudDatabase.fetch(withRecordID: self.recordID, completionHandler: { (record, error) in
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
        self.UserContainer.publicCloudDatabase.fetch(withRecordID: self.recordID, completionHandler: { (record, error) in
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
                        myvariables.userperfil.FotoPerfil = newphoto
                    }
                })
            }
        })
    }
    
    func BuscarNuevosMSG(EmailDestino: String) {
        
        let predicateMesajes = NSPredicate(format: "destinoEmail == %@ and emisorEmail ==%@",EmailDestino,self.Email)
        
        let queryMSGVista = CKQuery(recordType: "CMensaje",predicate: predicateMesajes)
        
        self.UserContainer.publicCloudDatabase.perform(queryMSGVista, inZoneWith: nil, completionHandler: ({results, error in
            if (error == nil) {
                if (results?.count)! > 0{
                    self.NewMsg = true
                }
            }
        }))
        
    }
    
    func ActualizarBloqueo(emailBloqueado: String, completionHandler: @escaping(Bool)->()){
        self.bloqueados.append(emailBloqueado)
        
        self.UserContainer.publicCloudDatabase.fetch(withRecordID: self.recordID, completionHandler: { (record, error) in
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
    func CargarBloqueados(bloqueados: [String]){
        self.bloqueados = bloqueados
    }
    
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
