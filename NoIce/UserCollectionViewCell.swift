//
//  CollectionViewCell.swift
//  NoIce
//
//  Created by Donelkys Santana on 10/11/18.
//  Copyright © 2018 Done Santana. All rights reserved.
//

import Foundation
import UIKit

class UserCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate{
    
    var pan: UIPanGestureRecognizer!
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var newMsg: UIImageView!
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
    func displayContent(image: UIImage, hidden: Bool){
        self.userPhoto.image = image
        self.newMsg.isHidden = hidden
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
    }
    
    func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizerState.began {
         
        } else if pan.state == UIGestureRecognizerState.changed {
      
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                print("center \(self.center)")
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
}
