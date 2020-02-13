//
//  CollectionViewCell.swift
//  NoIce
//
//  Created by Donelkys Santana on 10/11/18.
//  Copyright © 2018 Done Santana. All rights reserved.
//

import Foundation
import UIKit

protocol UserCollectionDelegate: class {
  func apiRequest(_ controller: UserCollectionViewCell, didHideUser userId: String)
}

class UserCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate{
  weak var delegate: UserCollectionDelegate?
  var pan: UIPanGestureRecognizer!
  var userConnected: User!
  
  @IBOutlet weak var userPhoto: UIImageView!
  @IBOutlet weak var newMsg: UIImageView!
  @IBOutlet weak var hideBtn: UIButton!
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
  }
  
  func initContent(user: User){
    self.contentView.addShadow()
    self.userConnected = user
    self.userPhoto.addShadow()
    self.userPhoto.image = user.photoProfile
    self.newMsg.isHidden = !user.NewMsg
    //self.hideBtn.addBorder()
    
    pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
    pan.delegate = self
    self.addGestureRecognizer(pan)
  }
  
  @objc func onPan(_ pan: UIPanGestureRecognizer) {
    if pan.state == UIGestureRecognizer.State.began {
      
    } else if pan.state == UIGestureRecognizer.State.changed {
      
    } else {
      if abs(pan.velocity(in: self).x) > 500 {
        let collectionView: UICollectionView = self.superview as! UICollectionView
        let indexPath: IndexPath = collectionView.indexPathForItem(at: (self.center))!
        print("indexPath \(indexPath)")
        collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
        
      } else {
        UIView.animate(withDuration: 0.2, animations: {
          self.setNeedsLayout()
          self.layoutIfNeeded()
        })
      }
    }
  }
  
  @IBAction func hideUser(_ sender: Any) {
    self.delegate?.apiRequest(self, didHideUser: self.userConnected.id)
  }
  
  
  func apiRequest(_ controller: UserCollectionDelegate, didHideUser userId: String){}
  
}
