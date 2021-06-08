//
//  ProfileController.swift
//  NoIce
//
//  Created by Done Santana on 26/4/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//
import Foundation
import UIKit
import CloudKit
import AssetsLibrary
import CoreImage
import LocalAuthentication

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var camaraController: UIImagePickerController!
  let myContext = LAContext()
  
  //VISUAL VARS
  @IBOutlet weak var UserPerfilView: UIView!
  
  //CUSTOM CONTRAINS

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var buttonsView: UIView!
  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var isFaceId: UISwitch!
  @IBOutlet weak var bioSwitchText: UILabel!
  
  
  @IBOutlet weak var userPerfilPhoto: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.camaraController = UIImagePickerController()
    self.camaraController.delegate = self
    self.headerView.addShadow()
    self.buttonsView.addShadow()
    self.backBtn.addShadow()
    self.backBtn.tintColor = GlobalConstants.primaryColor
    
    //Define value for Custom Contrains
    let screenSize = UIScreen.main.bounds
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    self.userPerfilPhoto.contentMode = .scaleAspectFill
    //self.userPerfilPhoto.layer.cornerRadius = 25
    self.userPerfilPhoto.clipsToBounds = true
    self.userPerfilPhoto.image = globalVariables.userLogged.photoProfile
    print(globalVariables.userDefaults.bool(forKey: "isUsingBioAuth"))
    self.isFaceId.isOn = globalVariables.userDefaults.bool(forKey: "isUsingBioAuth")
    
    switch  myContext.biometricType {
    case .faceID:
      self.bioSwitchText.text = "Use Face ID"
    case .touchID:
      self.bioSwitchText.text = "Use Touch ID"
    default:
      print("")
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    
    //let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! NSString
    //let type: NSString = mediaType
    if camaraController.cameraDevice == .front{
      //let stringType = type as String
      self.camaraController.dismiss(animated: true, completion: nil)
      //let newimage = info[UIImagePickerControllerOriginalImage] as? UIImage
      
      let photoPreview = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
      globalVariables.userLogged.ActualizarPhoto(newphoto: photoPreview!)
      self.userPerfilPhoto.image = photoPreview
      /*
       let imagenURL = self.saveImageToFile(photoPreview!)
       
       let image: CIImage = CIImage(contentsOf: imagenURL)!
       
       let accuracy: [String: AnyObject] = [CIDetectorAccuracy: CIDetectorAccuracyHigh as AnyObject]
       let faceDetector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
       
       let faces = faceDetector.features(in: image) as! [CIFaceFeature]
       print("faces \(faces)")
       if faces.count > 0{
       globalVariables.userLogged.ActualizarPhoto(newphoto: photoPreview!)
       self.userPerfilPhoto.image = photoPreview
       }else{
       let EditPhoto = UIAlertController (title: NSLocalizedString("Error",comment:"Wrong Camara"), message: NSLocalizedString("The profile only accepts selfies photo. Please, make sure that your face is completely visible.", comment:""), preferredStyle: UIAlertControllerStyle.alert)
       
       EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a picture again", comment:"Yes"), style: UIAlertActionStyle.default, handler: {alerAction in
       self.camaraController.sourceType = .camera
       self.camaraController.cameraCaptureMode = .photo
       self.camaraController.cameraDevice = .front
       self.present(self.camaraController, animated: true, completion: nil)
       }))
       EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertActionStyle.destructive, handler: { action in
       }))
       self.present(EditPhoto, animated: true, completion: nil)
       }*/
      
      //globalVariables.userLogged.ActualizarPhoto(newphoto: newimage!)
      //self.userPerfilPhoto.image = newimage
      
    }else{
      self.camaraController.dismiss(animated: true, completion: nil)
      let EditPhoto = UIAlertController (title: NSLocalizedString("Error",comment:"Cambiar la foto de perfil"), message: NSLocalizedString("The profile only accepts selfies photo.", comment:""), preferredStyle: UIAlertController.Style.alert)
      
      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a picture again", comment:"Yes"), style: UIAlertAction.Style.default, handler: {alerAction in
        self.camaraController.sourceType = .camera
        self.camaraController.cameraCaptureMode = .photo
        self.camaraController.cameraDevice = .front
        self.present(self.camaraController, animated: true, completion: nil)
      }))
      EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertAction.Style.destructive, handler: { action in
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
  
  func checkifBioAuth(){
    let myLocalizedReasonString =  NSLocalizedString("Biometric Authntication", comment:"Yes")
    
    var authError: NSError?
    if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
      myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
        
        DispatchQueue.main.async {
          if evaluateError == nil {
          if success {
            //globalVariables.userDefaults.set(true, forKey: "isUsingBioAuth")
            globalVariables.userDefaults.set(self.isFaceId.isOn ? true : nil, forKey: "isUsingBioAuth")
            print("success \(globalVariables.userDefaults.bool(forKey: "isUsingBioAuth"))")
            // User authenticated successfully, take appropriate action
            //self.successLabel.text = "Awesome!!... User authenticated successfully"
          } else {
            print("Unsuccess")
            self.isFaceId.isOn = false
            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            // User did not authenticate successfully, look at error and take appropriate action
            //self.successLabel.text = "Sorry!!... User did not authenticate successfully"
          }
        }else{
          print(evaluateError.debugDescription)
          self.isFaceId.isOn = false
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
      self.isFaceId.isOn = false
      print("evaluation error")
      // Could not evaluate policy; look at authError and present an appropriate message to user
      //successLabel.text = "Sorry!!.. Could not evaluate policy."
    }
  }
  
  @IBAction func EditPhoto(_ sender: Any) {
    self.camaraController.sourceType = .camera
    self.camaraController.cameraCaptureMode = .photo
    self.camaraController.cameraDevice = .front
    self.present(self.camaraController, animated: true, completion: nil)
  }
  
  @IBAction func switchBioAuth(_ sender: Any) {
    //globalVariables.userDefaults.set(self.isFaceId.isOn ? true : false, forKey: "isUsingBioAuth")
    //print("Bio \(globalVariables.userDefaults.value(forKey: "isUsingBioAuth"))")
    self.checkifBioAuth()
//    if self.isFaceId.isOn{
//      self.checkifBioAuth()
//    }
  }
  
  @IBAction func ShareApp(_ sender: Any) {
    if let name = URL(string: "itms://itunes.apple.com/us/app/apple-store/id1290022053?mt=8") {
      let objectsToShare = [name]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      self.present(activityVC, animated: true, completion: nil)
    }
    else
    {
      // show alert for not available
    }
  }
  
  @IBAction func SignOut(_ sender: Any) {
    globalVariables.userLogged.desconnect()
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

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
