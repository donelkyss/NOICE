//
//  LoginFunctionsExt.swift
//  NoIce
//
//  Created by Donelkys Santana on 6/4/21.
//  Copyright © 2021 Done Santana. All rights reserved.
//

import UIKit
import CoreLocation
import CloudKit
import Vision
import KeychainSwift
import LocalAuthentication

extension LoginController{
  func showLocationError(){
    let locationAlert = UIAlertController (title: NSLocalizedString("Location Error", comment: ""), message: (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) + NSLocalizedString(" searches the users closer to your position. Please go to Settings, active the Location services and open ", comment: "") + (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) + NSLocalizedString(" again.", comment: ""), preferredStyle: .alert)
    locationAlert.addAction(UIAlertAction(title: NSLocalizedString("Active Location", comment: ""), style: .default, handler: {alerAction in
      if #available(iOS 10.0, *) {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { success in
          exit(0)
        })
      } else {
        if let url = NSURL(string:UIApplication.openSettingsURLString) {
          UIApplication.shared.openURL(url as URL)
          exit(0)
        }
      }
    }))
    self.present(locationAlert, animated: true, completion: nil)
  }
  
  func appUpdateAvailable() -> Bool
  {
    let storeInfoURL: String = GlobalConstants.storeBundleURL
    var upgradeAvailable = false
    
    // Get the main bundle of the app so that we can determine the app's version number
    let bundle = Bundle.main
    if let infoDictionary = bundle.infoDictionary {
      // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
      let urlOnAppStore = URL(string: storeInfoURL)
      if let dataInJSON = try? Data(contentsOf: urlOnAppStore!) {
        // Try to deserialize the JSON that we got
        if let lookupResults = try? JSONSerialization.jsonObject(with: dataInJSON, options: JSONSerialization.ReadingOptions()) as! Dictionary<String, Any>{
          // Determine how many results we got. There should be exactly one, but will be zero if the URL was wrong
          if let resultCount = lookupResults["resultCount"] as? Int {
            if resultCount == 1 {
              // Get the version number of the version in the App Store
              //self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
              if let appStoreVersion = (lookupResults["results"]as! Array<Dictionary<String, AnyObject>>)[0]["version"] as? String {
                // Get the version number of the current version
                if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                  // Check if they are the same. If not, an upgrade is available.
                  if appStoreVersion > currentVersion {
                    upgradeAvailable = true
                  }
                }
              }
            }
          }
        }
      }
    }
    return upgradeAvailable
  }
  
  func checkifBioAuth(){
    let myLocalizedReasonString = NSLocalizedString("Biometric Authentication", comment:"Yes")
    
    var authError: NSError?
    if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
      myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
        
        DispatchQueue.main.async {
          if evaluateError == nil {
            if success {
              globalVariables.userDefaults.set(true, forKey: "isUsingBioAuth")
              print("success")
              self.getUserPhoto()
              // User authenticated successfully, take appropriate action
              //self.successLabel.text = "Awesome!!... User authenticated successfully"
            } else {
              print("Unsuccess")
              let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
              ac.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(ac, animated: true)
              //globalVariables.userDefaults.set(false, forKey: "isUsingBioAuth")
              // User did not authenticate successfully, look at error and take appropriate action
              //self.successLabel.text = "Sorry!!... User did not authenticate successfully"
            }
          }else{
            print(evaluateError.debugDescription)
            let ac = UIAlertController(title: "Authentication failed", message: "You have to active Biometric Id on Settings.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler:{ alertAction in
              let settingsURL = URL(string: UIApplication.openSettingsURLString)!
              UIApplication.shared.open(settingsURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { success in
                exit(0)
              })
            }))
            self.present(ac, animated: true)
          }
        }
      }
    } else {
      globalVariables.userDefaults.set(nil, forKey: "isUsingBioAuth")
      self.getUserPhoto()
      print("evaluation error")
      // Could not evaluate policy; look at authError and present an appropriate message to user
      //successLabel.text = "Sorry!!.. Could not evaluate policy."
    }
  }
  
  func getUserPhoto(){
    //TODO:- Search the photo locally
    let photoStored = globalVariables.localStoreService.getPhotoFromLocalStore()
    if photoStored != nil && photoStored!.isFromToday(){
        self.connectUser(photo: UIImage(data: photoStored?.photoImg as! Data)!)
        self.loadingView.isHidden = false

    }else{
      let EditPhoto = UIAlertController (title: NSLocalizedString("Face photo",comment:"Create profile photo"), message: NSLocalizedString("\(Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) only requires you a photo to allows other users recognize you. Please take photo to you face.", comment:""), preferredStyle: UIAlertController.Style.alert)
      
      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a photo", comment:"Yes"), style: UIAlertAction.Style.default, handler: {alerAction in
        
        self.camaraPerfilController.sourceType = .camera
        self.camaraPerfilController.cameraCaptureMode = .photo
        self.camaraPerfilController.cameraDevice = .front
        self.present(self.camaraPerfilController, animated: true, completion: nil)
        
      }))
      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertAction.Style.destructive, handler: { action in
        exit(0)
      }))
      self.present(EditPhoto, animated: true, completion: nil)
    }
  }
  
  func connectUser(photo: UIImage){
    let imagenURL = self.saveImageToFile(photo)
    
    let photoContenido = CKAsset(fileURL: imagenURL)
    
    print(globalVariables.currentPosition)
    let predicateBriceVista = NSPredicate(format: "id == %@", self.uuid)
    
    let queryBriceVista = CKQuery(recordType: "UsersConnected",predicate: predicateBriceVista)
    print("buscando el ususario")
    self.loginContainer.publicCloudDatabase.perform(queryBriceVista, inZoneWith: nil, completionHandler: ({results, error in
      if (error == nil) {
        print("termine de buscar el ususario")
        let recordUser = results?.count != 0 ? (results?.first)! as CKRecord : CKRecord(recordType:"UsersConnected")

        recordUser.setObject(self.uuid as CKRecordValue, forKey: "id")
        recordUser.setObject(photoContenido as CKRecordValue, forKey: "photo")
        recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
        recordUser.setObject(globalVariables.currentPosition as CKRecordValue, forKey: "location")

        self.loginContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
          if error == nil{
            print("usuario salvado")
            globalVariables.userLogged = User(user: record!)
            globalVariables.localStoreService.removeAllObjects(objectType: Photo.self)
            globalVariables.localStoreService.saveObjectArray(objects: [Photo(id: UUID().uuidString, photo: photo, lastUpdated: Date())])
            globalVariables.userLogged.userRegister()
            self.loginOk()
          }else{
            print("error \(error.debugDescription)")
          }
        })
      }else{
        print("Consulta error")
      }
    }))

  }
  
  func loginOk() {
    DispatchQueue.main.async {
      self.loadingView.isHidden = true
      let vc = R.storyboard.main.usersConnected()
     
      
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      self.navigationController?.show(vc!, sender: nil)
      //            let vc = R.storyboard.main.inicioView()
      //            self.navigationController?.show(vc!, sender: nil)
    }
  }
  
  
  //MARK: -EVENTO PARA DETECTAR FOTO Y VIDEO TIRADA
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //self.registerUser()
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    
    if camaraPerfilController.cameraDevice == .front{
      //let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! NSString
      self.camaraPerfilController.dismiss(animated: true, completion: nil)
      let photoPreview = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
      
      self.connectUser(photo: photoPreview!)
      
      self.loadingView.isHidden = false
//      let imagenURL = self.saveImageToFile(photoPreview!)
//
//      globalVariables.userDefaults.set(imagenURL, forKey: "profilePhoto")
//
//      let fotoContenido = CKAsset(fileURL: imagenURL)
//
//      let recordUser = CKRecord(recordType:"UsersProfile")
//      recordUser.setObject(fotoContenido as CKRecordValue, forKey: "photo")
//      recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
//      recordUser.setObject("1" as CKRecordValue, forKey: "conectado")
//      recordUser.setObject(globalVariables.currentPosition as CKRecordValue, forKey: "location")
//
//      self.loginContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
//        if error == nil{
//          globalVariables.userLogged = User(user: record!)
//          UserDefaults.standard.set(record?.recordID.recordName, forKey: "userRecordID")
//          DispatchQueue.main.async {
//            self.loadingView.isHidden = true
//            self.loadingAnimation.isHidden = true
//            let vc = R.storyboard.main.usersConnected()
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController?.show(vc!, sender: nil)
//            //            let vc = R.storyboard.main.inicioView()
//            //            self.navigationController?.show(vc!, sender: nil)
//          }
//        }else{
//          print("error \(String(describing: error))")
//        }
//      })
      
    }else{
      self.camaraPerfilController.dismiss(animated: true, completion: nil)
      let EditPhoto = UIAlertController (title: NSLocalizedString("Error",comment:"Wrong Camara"), message: NSLocalizedString("The profile only accepts selfies photo.", comment:""), preferredStyle: UIAlertController.Style.alert)
      
      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a picture again", comment:"Yes"), style: UIAlertAction.Style.default, handler: {alerAction in
        self.camaraPerfilController.sourceType = .camera
        self.camaraPerfilController.cameraCaptureMode = .photo
        self.camaraPerfilController.cameraDevice = .front
        self.present(self.camaraPerfilController, animated: true, completion: nil)
      }))
      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertAction.Style.destructive, handler: { action in
        exit(0)
      }))
      self.present(EditPhoto, animated: true, completion: nil)
    }
    
  }
  //RENDER IMAGEN
  func saveImageToFile(_ image: UIImage) -> URL
  {
    let filemgr = FileManager.default
    
    let dirPaths = filemgr.urls(for: .documentDirectory,
                                in: .userDomainMask)
    
    let fileURL = dirPaths[0].appendingPathComponent(image.description)
    
    if let renderedJPEGData =
      image.jpegData(compressionQuality: 0.5) {
      try! renderedJPEGData.write(to: fileURL)
    }
    
    return fileURL
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
  return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
