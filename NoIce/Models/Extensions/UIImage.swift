//
//  UIImage.swift
//  NoIce
//
//  Created by Donelkys Santana on 9/4/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

extension UIImage{
  //RENDER IMAGEN
  func saveImageToFile() -> URL
  {
    let filemgr = FileManager.default
    
    let dirPaths = filemgr.urls(for: .documentDirectory,
                                in: .userDomainMask)
    
    let fileURL = dirPaths[0].appendingPathComponent("currentImage.jpg")
    
    if let renderedJPEGData =
      self.jpegData(compressionQuality: 0.5) {
      try! renderedJPEGData.write(to: fileURL)
    }
    
    return fileURL
  }
}
