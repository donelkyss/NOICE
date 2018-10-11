//
//  ProfileController.swift
//  NoIce
//
//  Created by Done Santana on 26/4/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import GGLSignIn
import GoogleSignIn
import CloudKit
import AssetsLibrary
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var camaraController: UIImagePickerController!
    
    //VISUAL VARS
    @IBOutlet weak var UserPerfilView: UIView!
   
    //CUSTOM CONTRAINS
    @IBOutlet weak var profilePhotoHeight: NSLayoutConstraint!
    @IBOutlet weak var profilePhotoTop: NSLayoutConstraint!
    @IBOutlet weak var distanceBetweenButtons: NSLayoutConstraint!
    @IBOutlet weak var distanceSignOutShareButtons: NSLayoutConstraint!
    @IBOutlet weak var buttonsHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var userPerfilPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.camaraController = UIImagePickerController()
        self.camaraController.delegate = self

        //Define value for Custom Contrains
        let screenSize = UIScreen.main.bounds
       
        self.profilePhotoHeight.constant = screenSize.height / 4
       
        self.profilePhotoTop.constant = self.profilePhotoHeight.constant / 2
   
        self.buttonsHeight.constant = screenSize.height / 14
      
        self.distanceBetweenButtons.constant = screenSize.height / 36
        self.distanceSignOutShareButtons.constant = screenSize.height / 36
        
        self.userPerfilPhoto.contentMode = .scaleAspectFill
        self.userPerfilPhoto.layer.cornerRadius = self.profilePhotoHeight.constant / 6
        self.userPerfilPhoto.clipsToBounds = true
        self.userPerfilPhoto.image = myvariables.userperfil.FotoPerfil
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if let type:AnyObject = mediaType {
            if type is String {
                if camaraController.cameraDevice == .front{
                let stringType = type as! String
                self.camaraController.dismiss(animated: true, completion: nil)
                let newimage = info[UIImagePickerControllerOriginalImage] as? UIImage
                myvariables.userperfil.ActualizarPhoto(newphoto: newimage!)
                self.userPerfilPhoto.image = newimage
                }else{
                    self.camaraController.dismiss(animated: true, completion: nil)
                    let EditPhoto = UIAlertController (title: NSLocalizedString("Error",comment:"Cambiar la foto de perfil"), message: NSLocalizedString("The profile only accepts selfies photo.", comment:""), preferredStyle: UIAlertControllerStyle.alert)
                    
                    EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Take a picture again", comment:"Yes"), style: UIAlertActionStyle.default, handler: {alerAction in
                        self.camaraController.sourceType = .camera
                        self.camaraController.cameraCaptureMode = .photo
                        self.camaraController.cameraDevice = .front
                        self.present(self.camaraController, animated: true, completion: nil)
                    }))
                    EditPhoto.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:"Cancelar"), style: UIAlertActionStyle.destructive, handler: { action in
                    }))
                    self.present(EditPhoto, animated: true, completion: nil)
                }
            }
        }

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
        myvariables.userperfil.ActualizarConectado(estado: "0")
        sleep(2)
        FBSDKLoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
    }
    

}
