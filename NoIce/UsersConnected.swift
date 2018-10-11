//
//  UserConnectedCollection.swift
//  NoIce
//
//  Created by Donelkys Santana on 10/11/18.
//  Copyright © 2018 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class UsersConnected: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var userContainer = CKContainer.default()
    var connectedTimer: Timer!
    
    //INTERFACES VARIABLES
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.reloadSections(IndexSet(integer: 0))
        
        //self.collectionView.backgroundView = UIImageView.init(image: UIImage(named: "background"))
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.BuscarUsuariosConectados()
        
        if myvariables.usuariosMostrar.count == 0{
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InicioView") as! ViewController
            self.navigationController?.show(vc, sender: nil)
        }else{
            connectedTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(BuscarUsuariosConectados), userInfo: nil, repeats: true)
            //self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
    }
    
    //CUSTOM FUNCTIONS
    func BuscarUsuariosConectados(){
        
        let predicateUsuarioIn = NSPredicate(format: "distanceToLocation:fromLocation:(posicion, %@) < 300 and conectado == %@ and email != %@", myvariables.userperfil.Posicion, "1", myvariables.userperfil.Email)
        
        let queryUsuarioIn = CKQuery(recordType: "CUsuarios",predicate: predicateUsuarioIn)
        self.userContainer.publicCloudDatabase.perform(queryUsuarioIn, inZoneWith: nil, completionHandler: ({results, error in
            if (error == nil) {
                myvariables.usuariosMostrar.removeAll()
                //if (results?.count)! != myvariables.usuariosMostrar.count{
                if (results?.count)! > 0{
                    var bloqueados = [String]()
                    var i = 0
                    while i < (results?.count)!{
                        let usuarioTemp = CUser(nombreapellidos: results?[i].value(forKey: "nombreApellidos") as! String, email: results?[i].value(forKey: "email") as! String)
                        usuarioTemp.BuscarNuevosMSG(EmailDestino: myvariables.userperfil.Email)
                        bloqueados = results?[i].value(forKey: "bloqueados") as! [String]
                        
                        if  !bloqueados.contains(myvariables.userperfil.Email) && !myvariables.userperfil.bloqueados.contains(usuarioTemp.Email){
                            let photo = results?[i].value(forKey: "foto") as! CKAsset
                            let photoPerfil = NSData(contentsOf: photo.fileURL as URL)
                            let imagenEmisor = UIImage(data: photoPerfil as! Data)!
                            
                            usuarioTemp.GuardarFotoPerfil(photo: imagenEmisor)
                            myvariables.usuariosMostrar.append(usuarioTemp)
                        }
                        i += 1
                    }
                }else{
                    self.connectedTimer.invalidate()
                    let alertaClose = UIAlertController (title: NSLocalizedString("No user connected",comment:"No user connected"), message: NSLocalizedString("There aren't any user connected near you.", comment:"No hay usuarios conectados"), preferredStyle: UIAlertControllerStyle.alert)
                    alertaClose.addAction(UIAlertAction(title: NSLocalizedString("Close", comment:"Cerrar"), style: UIAlertActionStyle.default, handler: {alerAction in
                        //self.tableView.reloadData()
                        self.collectionView.reloadData()
                        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileController
                        self.navigationController?.show(vc, sender: nil)
                    }))
                    self.present(alertaClose, animated: true, completion: nil)
                }
            }else{
                print("ERROR DE CONSULTA " + error.debugDescription)
            }
        }))
        DispatchQueue.main.async {
            //self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    func BuscarNewMsg() {
        //self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    //COLLECTION VIEW FUNCTION
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myvariables.usuariosMostrar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell",for: indexPath) as! UserCollectionViewCell
        cell.displayContent(image: myvariables.usuariosMostrar[indexPath.row].FotoPerfil, hidden: !myvariables.usuariosMostrar[indexPath.row].NewMsg)
        cell.userPhoto.layer.cornerRadius = (cell.userPhoto.frame.width) / 8
        cell.userPhoto.contentMode = .scaleAspectFill
        cell.userPhoto.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionViewLayout.invalidateLayout()
        let cellWidthSize = UIScreen.main.bounds.width / 2.5
        return CGSize(width: cellWidthSize, height: cellWidthSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "Chat") as! ChatViewController
        vc.chatOpenPos = indexPath.row
        self.navigationController?.show(vc, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        print("deleting cell")
        myvariables.usuariosMostrar.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
    
    
}
