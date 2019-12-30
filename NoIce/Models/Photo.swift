//
//  Photo.swift
//  NoIce
//
//  Created by Donelkys Santana on 8/29/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import RealmSwift

class Photo: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var photoUrl: String = ""
  @objc dynamic var photoImg: NSData? = nil
  @objc dynamic var lastUpdated: Date = Date()
  
  convenience init(id: String, photo: UIImage,lastUpdated: Date){
    self.init()
    self.id = id
    self.photoImg = photo.jpegData(compressionQuality: 0.5) as NSData?
    self.photoUrl = String(describing: photo.saveImageToFile())
    self.lastUpdated = lastUpdated
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  func isFromToday() -> Bool{
    let calendar = Calendar.current
    return calendar.isDateInToday(self.lastUpdated)
  }
}
