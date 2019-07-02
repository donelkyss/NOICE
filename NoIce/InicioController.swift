//
//  ViewController.swift
//  NoIce
//
//  Created by Done Santana on 13/1/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import CloudKit

class InicioController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITextFieldDelegate{
  //MARK: - PROPIEDADES DE LA CLASE
  var locationManager = CLLocationManager()
  var camaraPerfilController: UIImagePickerController!
  var userTimer = Timer()
  
  
  //CLOUD VARIABLES
  var cloudContainer = CKContainer.default()
  var userContainer = CKContainer.default()
  var photoAsset: CKAsset!
  
  //Visual variables
  
  @IBOutlet weak var SearchingView: UIView!
  
  
  override func viewDidLoad(){
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    //MARK: -INICIALIZAR CAMARA
    self.camaraPerfilController = UIImagePickerController()
    self.camaraPerfilController.delegate = self
    
    //MARK: -INICIALIZAR GEOLOCALIZACION
    self.locationManager.delegate = self
    
    self.navigationItem.setHidesBackButton(true, animated:true)
    
    if CLLocationManager.locationServicesEnabled(){
      switch(CLLocationManager.authorizationStatus()) {
        
      case .restricted, .denied, .notDetermined:
        let locationAlert = UIAlertController (title: NSLocalizedString("Location Error", comment: ""), message: (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) + NSLocalizedString(" searches the users closer to your position. Please go to Settings, active the Location services and open ", comment: "") + (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) + NSLocalizedString(" again.", comment: ""), preferredStyle: .alert)
        locationAlert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: {alerAction in
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
        
      case .authorizedAlways, .authorizedWhenInUse:
        self.TimerStart(estado: 1)
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        break
      }
    }else{
      let locationAlert = UIAlertController (title: NSLocalizedString("Location Error", comment: ""), message: (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) + NSLocalizedString(" searches the users closer to your position. Please go to Settings, active the Location services and open ", comment: "") + (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String) + NSLocalizedString(" again.", comment: ""), preferredStyle: .alert)
      locationAlert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: {alerAction in
        exit(0)
      }))
      self.present(locationAlert, animated: true, completion: nil)
    }
    // Do any additional setup after loading the view, typically from a nib.
    
    //PARA MOSTRAR Y OCULTAR EL TECLADO
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //CHECK LOCATION PERMISSIONS
    //solicitud de autorización para acceder a la localización del usuario
    /*if MyVariables.userLogged.Posicion != MyVariables.currentPosition {
     self.BuscarUsuariosConectados()
     }*/
    
    //MyVariables.userLogged.ActualizarPosicion(posicionActual: MyVariables.currentPosition)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.TimerStart(estado: 0)
  }
  
  //MARK: - ACTUALIZACION DE GEOLOCALIZACION
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if MyVariables.userLogged != nil{
      if MyVariables.userLogged.Posicion.distance(from: locations.last!) > 20{
        MyVariables.userLogged.ActualizarPosicion(posicionActual: locations.last!)
      }
    }
  }
  
  //MARK: -FUNCIONES GOOGLE SIGN-IN DELEGATE
  
  // The sign-in flow has finished and was successful if |error| is |nil|.
  
  //FUNCTION TIMER
  func TimerStart(estado: Int){
    if estado == 1{
      self.userTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BuscarUsuariosConectados), userInfo: nil, repeats: true)
    }else{
      self.userTimer.invalidate()
    }
  }
  
  //MARK: - BUSCAR USUARIOS CONECTADOS
  //MEJORAR ESTA FUNCION CAMBIAR EL CICLO FOR:
  @objc func BuscarUsuariosConectados(){
    
    if MyVariables.userLogged.Posicion != MyVariables.currentPosition {
      let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(posicion, %@) < 300 and conectado == %@",MyVariables.userLogged.Posicion, "1")
      self.TimerStart(estado: 0)
      //let predicateUsuarioIn = NSPredicate(format: "conectado == %@ and email != %@", "1", MyVariables.userLogged.Email)
      let queryUsuarioIn = CKQuery(recordType: "UsersProfile",predicate: predicateUsuarioIn)
      self.cloudContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
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
          
          if MyVariables.usuariosMostrar.count > 0{
            DispatchQueue.main.async {
              let vc = R.storyboard.main.usersConnected()
              self.navigationController?.setNavigationBarHidden(false, animated: true)
              self.navigationController?.show(vc!, sender: nil)
            }
          }else{
            self.locationManager.stopUpdatingLocation()
            let alertaClose = UIAlertController (title: NSLocalizedString("No user connected",comment:"No user connected"), message: NSLocalizedString("There aren't any user connected near you.", comment:"No user connected"), preferredStyle: UIAlertController.Style.alert)
            alertaClose.addAction(UIAlertAction(title: NSLocalizedString("Close", comment:"Cerrar"), style: UIAlertAction.Style.default, handler: {alerAction in
              let vc  = R.storyboard.main.profileView()
              //let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileController
              self.navigationController?.setNavigationBarHidden(false, animated: true)
              self.navigationController?.show(vc!, sender: nil)
            }))
            self.present(alertaClose, animated: true, completion: nil)
          }
        }else{
          print("ERROR DE CONSULTA " + error.debugDescription)
        }
      }))
    }
  }
  
  //MARK: - ACTION BOTONES GRAFICOS
  @IBAction func ShowMenuBtn(_ sender: Any) {
    MyVariables.userLogged.ActualizarConectado(estado: "0")
    sleep(3)
    exit(0)
  }
  
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
