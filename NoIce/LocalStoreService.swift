//
//  LocalStoreService.swift
//  NoIce
//
//  Created by Donelkys Santana on 8/29/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import RealmSwift


class LocalStoreService {
  lazy var realm:Realm = {
    return try! Realm()
  }()
  
  func getPhotoFromLocalStore() -> Photo?{
    let photo = self.realm.objects(Photo.self)
    
    if photo.count != 0 {
      return photo.first!
    }else{
      return nil
    }
  }
  
  func saveObjectArray(objects: [Object]){
    DispatchQueue.main.async {
      try! self.realm.write {
        for object in objects{
          self.realm.add(object, update: .all)
        }
      }
    }
  }
  
  func removeObjectFromCache(object_id: String, objectType: Object.Type){
    let object = self.realm.objects(objectType).filter(NSPredicate(format:"id == %@",object_id))
    try! self.realm.write {
      self.realm.delete(object)
    }
  }
  
  func removeAllObjects(objectType: Object.Type){
    DispatchQueue.main.async {
      let objects = self.realm.objects(objectType)
      try! self.realm.write {
        self.realm.delete(objects)
      }
    }
  }
  
  func updateDate(){
    try! self.realm.write {
      realm.objects(Photo.self).first?.lastUpdated = Date()
    }
  }
}
