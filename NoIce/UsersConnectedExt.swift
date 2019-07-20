//
//  UsersConnectedExt.swift
//  NoIce
//
//  Created by Donelkys Santana on 6/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

extension UsersConnected: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  //COLLECTION VIEW FUNCTION
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MyVariables.usuariosMostrar.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell",for: indexPath) as! UserCollectionViewCell
    cell.initContent(user: MyVariables.usuariosMostrar[indexPath.row])//(image: MyVariables.usuariosMostrar[indexPath.row].FotoPerfil, hidden: !MyVariables.usuariosMostrar[indexPath.row].NewMsg)
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
    let vc = R.storyboard.main.chat()
    vc!.chatOpenPos = indexPath.row
    self.navigationController?.show(vc!, sender: nil)
  }
  
  func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
//    MyVariables.userLogged.ActualizarBloqueo(userBloqueado: MyVariables.usuariosMostrar[indexPath.row].id, completionHandler: { success in
//      if success {
//        MyVariables.usuariosMostrar.remove(at: indexPath.row)
//        DispatchQueue.main.async {
//          collectionView.deleteItems(at: [indexPath])
//        }
//      }
//    })
  }
}
