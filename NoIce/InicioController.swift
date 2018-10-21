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
                        let settingsURL = URL(string: UIApplicationOpenSettingsURLString)!
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                            exit(0)
                        })
                    } else {
                        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
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
        /*if myvariables.userperfil.Posicion != myvariables.currentPosition {
               self.BuscarUsuariosConectados()
        }*/
    
        //myvariables.userperfil.ActualizarPosicion(posicionActual: myvariables.currentPosition)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.TimerStart(estado: 0)
    }
    
    //MARK: - ACTUALIZACION DE GEOLOCALIZACION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if myvariables.userperfil != nil{
            if myvariables.userperfil.Posicion.distance(from: locations.last!) > 10{
                myvariables.userperfil.ActualizarPosicion(posicionActual: locations.last!)
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
    func BuscarUsuariosConectados(){
        if myvariables.userperfil.Posicion != myvariables.currentPosition {
            let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(posicion, %@) < 300 and conectado == %@ and email != %@", myvariables.userperfil.Posicion, "1", myvariables.userperfil.Email)
            self.TimerStart(estado: 0)
            //let predicateUsuarioIn = NSPredicate(format: "conectado == %@ and email != %@", "1", myvariables.userperfil.Email)
            let queryUsuarioIn = CKQuery(recordType: "CUsuarios",predicate: predicateUsuarioIn)
            self.cloudContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
                if (error == nil) {
                    myvariables.usuariosMostrar.removeAll()
                    if (results?.count)! > 0{
                        var i = 0
                        while i < (results?.count)!{
                            let bloqueados = results?[i].value(forKey: "bloqueados") as! [String]
                            if  !bloqueados.contains(myvariables.userperfil.Email) && !myvariables.userperfil.bloqueados.contains(results?[i].value(forKey: "email") as! String){
                                let usuarioTemp = CUser(user: results![i])
                                usuarioTemp.BuscarNuevosMSG(EmailDestino: myvariables.userperfil.Email)
                                myvariables.usuariosMostrar.append(usuarioTemp)
                            }
                            i += 1
                        }
                    }else{
                        self.locationManager.stopUpdatingLocation()
                        let alertaClose = UIAlertController (title: NSLocalizedString("No user connected",comment:"No user connected"), message: NSLocalizedString("There aren't any user connected near you.", comment:"No user connected"), preferredStyle: UIAlertControllerStyle.alert)
                        alertaClose.addAction(UIAlertAction(title: NSLocalizedString("Close", comment:"Cerrar"), style: UIAlertActionStyle.default, handler: {alerAction in
                                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileController
                                self.navigationController?.show(vc, sender: nil)
                        }))
                        self.present(alertaClose, animated: true, completion: nil)
                    }
                }else{
                    print("ERROR DE CONSULTA " + error.debugDescription)
                }
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "UsersConnected") as! UsersConnected
                    self.navigationController?.show(vc, sender: nil)
                }
            }))
        }
    }
    //MARK: - ACTION BOTONES GRAFICOS
    @IBAction func ShowMenuBtn(_ sender: Any) {
        myvariables.userperfil.ActualizarConectado(estado: "0")
        sleep(3)
        exit(0)
    }

}

