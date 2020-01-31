//
//  LoginController.swift
//  NoIce
//
//  Created by Done Santana on 21/4/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CloudKit
import Vision

class LoginController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var uuid: String!
  var locationManager = CLLocationManager()
  var loginContainer = CKContainer.default()
  var camaraPerfilController: UIImagePickerController!
  var dataRegistration: [String]!
  
  @IBOutlet weak var loginView: UIView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var loadingAnimation: UIView!
  
  override func viewDidLoad(){
    super.viewDidLoad()
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      self.uuid = uuid
    }
    
    self.locationManager.delegate = self
    self.loadingAnimation.addShadow()
    self.camaraPerfilController = UIImagePickerController()
    self.camaraPerfilController.delegate = self
    
    if self.appUpdateAvailable(){
      
      let alertaVersion = UIAlertController (title: "Application version", message: "Dear customer, it is necessary to update to the latest version of the application available in the AppStore. Do you want to do it at this time?", preferredStyle: .alert)
      alertaVersion.addAction(UIAlertAction(title: "Yes", style: .default, handler: {alerAction in
        UIApplication.shared.open(URL(string: GlobalConstants.itunesURL)!)
      }))
      alertaVersion.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
        exit(0)
      }))
      self.present(alertaVersion, animated: true, completion: nil)
      
    }
    self.getUserPhoto()
  }
  
  //MARK:- CHECK LOCATION PERMISSIONS
  override func viewDidAppear(_ animated: Bool) {
    
    if CLLocationManager.locationServicesEnabled(){
      switch(CLLocationManager.authorizationStatus()) {
      case .notDetermined:
        self.locationManager.requestWhenInUseAuthorization()
      case .restricted, .denied:
        self.showLocationError()
      case .authorizedAlways, .authorizedWhenInUse:
        //self.TimerStart(estado: 1)
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        break
      }
    }else{
      self.showLocationError()
    }
    
  }
  
  //MARK: - ACTUALIZACION DE GEOLOCALIZACION
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if GlobalVariables.userLogged != nil && CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
      if GlobalVariables.userLogged.location.distance(from: locations.last!) > 20{
        GlobalVariables.userLogged.Actualizarlocation(locationActual: locations.last!)
      }
    }else{
      print("here")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch(CLLocationManager.authorizationStatus()) {
    case .notDetermined:
      self.locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      self.showLocationError()
    case .authorizedAlways, .authorizedWhenInUse:
      //self.TimerStart(estado: 1)
      self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      self.locationManager.startUpdatingLocation()
      break
    }
  }
  
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
  
  func getUserPhoto(){
    //TODO:- Search the photo locally
    let photoStored = GlobalVariables.localStoreService.getPhotoFromLocalStore()
    
    if photoStored != nil && photoStored!.isFromToday(){
//      print(photoStored?.lastUpdated)
//      let photoUrl = photoStored?.photoUrl
//      if photoStored!.isFromToday(){
        self.connectUser(photo: UIImage(data: photoStored?.photoImg as! Data)!)
        self.loadingView.isHidden = false
//      }else{
//        let EditPhoto = UIAlertController (title: NSLocalizedString("Photo update",comment:"Photo update"), message: NSLocalizedString("The photo you are trying to use is not from today. We recommend you to take a new one to have more chance of dating success.", comment:""), preferredStyle: UIAlertController.Style.alert)
//
//        EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take new picture.", comment:"Yes"), style: UIAlertAction.Style.default, handler: {alerAction in
//          self.camaraPerfilController.sourceType = .camera
//          self.camaraPerfilController.cameraCaptureMode = .photo
//          self.camaraPerfilController.cameraDevice = .front
//          self.present(self.camaraPerfilController, animated: true, completion: nil)
//        }))
//        EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Use it", comment:"Use it"), style: UIAlertAction.Style.destructive, handler: { action in
//          GlobalVariables.localStoreService.updateDate()
//          self.connectUser(photo: UIImage(data: photoStored?.photoImg! as! Data)!)
//          self.loadingView.isHidden = false
//        }))
//        self.present(EditPhoto, animated: true, completion: nil)
//      }
    }else{
      let EditPhoto = UIAlertController (title: NSLocalizedString("Face photo",comment:"Create profil photo"), message: NSLocalizedString("Is required you have a photo in the app to allows other user recognize you. Please take photo to you face.", comment:""), preferredStyle: UIAlertController.Style.alert)
      
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
    
    let recordUser = CKRecord(recordType:"UsersConnected")
    recordUser.setObject(self.uuid as CKRecordValue, forKey: "id")
    recordUser.setObject(photoContenido as CKRecordValue, forKey: "photo")
    recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
    recordUser.setObject(GlobalVariables.currentPosition as CKRecordValue, forKey: "location")
    
    let predicateKapsuleVista = NSPredicate(format: "id == %@", self.uuid)
    
    let queryKapsuleVista = CKQuery(recordType: "UsersConnected",predicate: predicateKapsuleVista)
    
    self.loginContainer.publicCloudDatabase.perform(queryKapsuleVista, inZoneWith: nil, completionHandler: ({results, error in
      
      if (error == nil) {
        if results?.count != 0{
          let recordID = results?[0].recordID
          self.loginContainer.publicCloudDatabase.delete(withRecordID: recordID!, completionHandler: { (record, error) in
            
          })
        }
        
        self.loginContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
          if error == nil{
            GlobalVariables.userLogged = User(user: record!)
            GlobalVariables.localStoreService.removeAllObjects(objectType: Photo.self)
            GlobalVariables.localStoreService.saveObjectArray(objects: [Photo(id: UUID().uuidString, photo: photo, lastUpdated: Date())])
            GlobalVariables.userLogged.userRegister()
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
  
//  func getUserLogin(){
//    let photoProfile = self.getUserPhoto()
//
//    if GlobalVariables.userDefaults.string(forKey: "userRecordID") != nil{
//      loginContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: GlobalVariables.userDefaults.string(forKey: "userRecordID")!), completionHandler: { (record, error) in
//        if error != nil {
//          print("Error fetching  position record: \(String(describing: error?.localizedDescription))")
//        } else {
//          GlobalVariables.userLogged = User(user: record!)
//          DispatchQueue.main.async {
//            self.loadingView.isHidden = true
//            self.loadingAnimation.isHidden = true
//            let vc = R.storyboard.main.usersConnected()
//            self.navigationController?.show(vc!, sender: nil)
//            //            let vc = R.storyboard.main.inicioView()
//            //            self.navigationController?.show(vc!, sender: nil)
//          }
//        }
//      })
//    }else {
//      registerUser()
//    }
//  }
  
//  func getUserLogin(){
//    if GlobalVariables.userDefaults.string(forKey: "userRecordID") != nil{
//      loginContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: GlobalVariables.userDefaults.string(forKey: "userRecordID")!), completionHandler: { (record, error) in
//        if error != nil {
//          print("Error fetching  position record: \(String(describing: error?.localizedDescription))")
//        } else {
//          GlobalVariables.userLogged = User(user: record!)
//          GlobalVariables.userLogged.ActualizarConectado(estado: "1")
//          DispatchQueue.main.async {
//            self.loadingView.isHidden = true
//            self.loadingAnimation.isHidden = true
//            let vc = R.storyboard.main.usersConnected()
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController?.show(vc!, sender: nil)
//            //            let vc = R.storyboard.main.inicioView()
//            //            self.navigationController?.show(vc!, sender: nil)
//          }
//        }
//      })
//    }else {
//      registerUser()
//    }
//  }
  
//  func registerUser(){
//    loadingView.isHidden = true
//    loadingAnimation.isHidden = true
//  }
  
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
//      GlobalVariables.userDefaults.set(imagenURL, forKey: "profilePhoto")
//
//      let fotoContenido = CKAsset(fileURL: imagenURL)
//
//      let recordUser = CKRecord(recordType:"UsersProfile")
//      recordUser.setObject(fotoContenido as CKRecordValue, forKey: "photo")
//      recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
//      recordUser.setObject("1" as CKRecordValue, forKey: "conectado")
//      recordUser.setObject(GlobalVariables.currentPosition as CKRecordValue, forKey: "location")
//
//      self.loginContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
//        if error == nil{
//          GlobalVariables.userLogged = User(user: record!)
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
  
  @IBAction func loginUser(_ sender: Any) {
    
    let EditPhoto = UIAlertController (title: NSLocalizedString("Profile photo",comment:"Create profil photo"), message: NSLocalizedString("Is required you have a photo in your profile. Take a profile picture.", comment:""), preferredStyle: UIAlertController.Style.alert)
    
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


//class LoginController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//  var locationManager = CLLocationManager()
//  var loginContainer = CKContainer.default()
//  var camaraPerfilController: UIImagePickerController!
//  var dataRegistration: [String]!
//
//  @IBOutlet weak var loginView: UIView!
//  @IBOutlet weak var loadingView: UIVisualEffectView!
//  @IBOutlet weak var loadingAnimation: UIView!
//
//  override func viewDidLoad(){
//    super.viewDidLoad()
//
//    self.generateUserUUID() //BD0F883E-FEA1-4F99-8DE1-627C465E9EF7
//
//    self.loadingAnimation.addShadow()
//    self.camaraPerfilController = UIImagePickerController()
//    self.camaraPerfilController.delegate = self
//
//    if self.appUpdateAvailable(){
//
//      let alertaVersion = UIAlertController (title: "Application version", message: "Dear customer, it is necessary to update to the latest version of the application available in the AppStore. Do you want to do it at this time?", preferredStyle: .alert)
//      alertaVersion.addAction(UIAlertAction(title: "Yes", style: .default, handler: {alerAction in
//        UIApplication.shared.open(URL(string: GlobalConstants.itunesURL)!)
//      }))
//      alertaVersion.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
//        exit(0)
//      }))
//      self.present(alertaVersion, animated: true, completion: nil)
//
//    }
//
//    self.getUserLogin()
//
//  }
//
//  func appUpdateAvailable() -> Bool
//  {
//    let storeInfoURL: String = GlobalConstants.storeBundleURL
//    var upgradeAvailable = false
//
//    // Get the main bundle of the app so that we can determine the app's version number
//    let bundle = Bundle.main
//    if let infoDictionary = bundle.infoDictionary {
//      // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
//      let urlOnAppStore = URL(string: storeInfoURL)
//      if let dataInJSON = try? Data(contentsOf: urlOnAppStore!) {
//        // Try to deserialize the JSON that we got
//        if let lookupResults = try? JSONSerialization.jsonObject(with: dataInJSON, options: JSONSerialization.ReadingOptions()) as! Dictionary<String, Any>{
//          // Determine how many results we got. There should be exactly one, but will be zero if the URL was wrong
//          if let resultCount = lookupResults["resultCount"] as? Int {
//            if resultCount == 1 {
//              // Get the version number of the version in the App Store
//              //self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
//              if let appStoreVersion = (lookupResults["results"]as! Array<Dictionary<String, AnyObject>>)[0]["version"] as? String {
//                // Get the version number of the current version
//                if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
//                  // Check if they are the same. If not, an upgrade is available.
//                  if appStoreVersion > currentVersion {
//                    upgradeAvailable = true
//                  }
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//    return upgradeAvailable
//  }
//
//  func getUserLogin(){
//    if UserDefaults.standard.string(forKey: "userRecordID") != nil{
//      loginContainer.publicCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: UserDefaults.standard.string(forKey: "userRecordID")!), completionHandler: { (record, error) in
//        if error != nil {
//          print("Error fetching  position record: \(String(describing: error?.localizedDescription))")
//        } else {
//          GlobalVariables.userLogged = User(user: record!)
//          GlobalVariables.userLogged.ActualizarConectado(estado: "1")
//          DispatchQueue.main.async {
//            self.loadingView.isHidden = true
//            self.loadingAnimation.isHidden = true
//            let vc = R.storyboard.main.usersConnected()
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController?.show(vc!, sender: nil)
////            let vc = R.storyboard.main.inicioView()
////            self.navigationController?.show(vc!, sender: nil)
//          }
//        }
//      })
//    }else {
//      registerUser()
//    }
//  }
//
//  func registerUser(){
//    loadingView.isHidden = true
//    loadingAnimation.isHidden = true
//  }
//
//
//  //MARK: -EVENTO PARA DETECTAR FOTO Y VIDEO TIRADA
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    self.registerUser()
//    // Local variable inserted by Swift 4.2 migrator.
//    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//    if camaraPerfilController.cameraDevice == .front{
//      //let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! NSString
//      self.camaraPerfilController.dismiss(animated: true, completion: nil)
//      let photoPreview = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
//
//      let imagenURL = self.saveImageToFile(photoPreview!)
//
//      let fotoContenido = CKAsset(fileURL: imagenURL)
//
//      let recordUser = CKRecord(recordType:"UsersProfile")
//      recordUser.setObject(fotoContenido as CKRecordValue, forKey: "photo")
//      recordUser.setObject(["nadie"] as CKRecordValue, forKey: "bloqueados")
//      recordUser.setObject("1" as CKRecordValue, forKey: "conectado")
//      recordUser.setObject(GlobalVariables.currentPosition as CKRecordValue, forKey: "location")
//
//      self.loginContainer.publicCloudDatabase.save(recordUser, completionHandler: {(record, error) in
//        if error == nil{
//          GlobalVariables.userLogged = User(user: record!)
//          UserDefaults.standard.set(record?.recordID.recordName, forKey: "userRecordID")
//          DispatchQueue.main.async {
//            self.loadingView.isHidden = true
//            self.loadingAnimation.isHidden = true
//            let vc = R.storyboard.main.usersConnected()
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController?.show(vc!, sender: nil)
////            let vc = R.storyboard.main.inicioView()
////            self.navigationController?.show(vc!, sender: nil)
//          }
//        }else{
//          print("error \(String(describing: error))")
//        }
//      })
//
//    }else{
//      self.camaraPerfilController.dismiss(animated: true, completion: nil)
//      let EditPhoto = UIAlertController (title: NSLocalizedString("Error",comment:"Wrong Camara"), message: NSLocalizedString("The profile only accepts selfies photo.", comment:""), preferredStyle: UIAlertController.Style.alert)
//
//      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a picture again", comment:"Yes"), style: UIAlertAction.Style.default, handler: {alerAction in
//        self.camaraPerfilController.sourceType = .camera
//        self.camaraPerfilController.cameraCaptureMode = .photo
//        self.camaraPerfilController.cameraDevice = .front
//        self.present(self.camaraPerfilController, animated: true, completion: nil)
//      }))
//      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertAction.Style.destructive, handler: { action in
//        exit(0)
//      }))
//      self.present(EditPhoto, animated: true, completion: nil)
//    }
//
//  }
//  //RENDER IMAGEN
//  func saveImageToFile(_ image: UIImage) -> URL
//  {
//    let filemgr = FileManager.default
//
//    let dirPaths = filemgr.urls(for: .documentDirectory,
//                                in: .userDomainMask)
//
//    let fileURL = dirPaths[0].appendingPathComponent(image.description)
//
//    if let renderedJPEGData =
//      image.jpegData(compressionQuality: 0.5) {
//      try! renderedJPEGData.write(to: fileURL)
//    }
//
//    return fileURL
//  }
//
//  @IBAction func loginUser(_ sender: Any) {
//
//    let EditPhoto = UIAlertController (title: NSLocalizedString("Profile photo",comment:"Create profil photo"), message: NSLocalizedString("Is required you have a photo in your profile. Take a profile picture.", comment:""), preferredStyle: UIAlertController.Style.alert)
//
//    EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a photo", comment:"Yes"), style: UIAlertAction.Style.default, handler: {alerAction in
//
//      self.camaraPerfilController.sourceType = .camera
//      self.camaraPerfilController.cameraCaptureMode = .photo
//      self.camaraPerfilController.cameraDevice = .front
//      self.present(self.camaraPerfilController, animated: true, completion: nil)
//
//    }))
//    EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertAction.Style.destructive, handler: { action in
//      exit(0)
//    }))
//    self.present(EditPhoto, animated: true, completion: nil)
//  }
//}

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
