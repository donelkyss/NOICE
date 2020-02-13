//
//  ProfileController.swift
//  NoIce
//
//  Created by Done Santana on 26/4/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import CloudKit
import AssetsLibrary
import CoreImage

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var camaraController: UIImagePickerController!
  
  //VISUAL VARS
  @IBOutlet weak var UserPerfilView: UIView!
  
  //CUSTOM CONTRAINS

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var buttonsView: UIView!
  @IBOutlet weak var backBtn: UIButton!
  
  
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
    self.userPerfilPhoto.image = GlobalVariables.userLogged.photoProfile
    
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
      GlobalVariables.userLogged.ActualizarPhoto(newphoto: photoPreview!)
      self.userPerfilPhoto.image = photoPreview
      /*
       let imagenURL = self.saveImageToFile(photoPreview!)
       
       let image: CIImage = CIImage(contentsOf: imagenURL)!
       
       let accuracy: [String: AnyObject] = [CIDetectorAccuracy: CIDetectorAccuracyHigh as AnyObject]
       let faceDetector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
       
       let faces = faceDetector.features(in: image) as! [CIFaceFeature]
       print("faces \(faces)")
       if faces.count > 0{
       GlobalVariables.userLogged.ActualizarPhoto(newphoto: photoPreview!)
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
      
      //GlobalVariables.userLogged.ActualizarPhoto(newphoto: newimage!)
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
  
  @IBAction func EditPhoto(_ sender: Any) {
    self.camaraController.sourceType = .camera
    self.camaraController.cameraCaptureMode = .photo
    self.camaraController.cameraDevice = .front
    self.present(self.camaraController, animated: true, completion: nil)
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
    GlobalVariables.userLogged.desconnect()
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
