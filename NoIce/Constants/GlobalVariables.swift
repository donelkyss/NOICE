//
//  globalVariables.swift
//  NoIce
//
//  Created by Donelkys Santana on 5/18/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import CloudKit

struct globalVariables {
  static var userLogged: User!
  static var currentPosition = CLLocation()
  static var usuariosMostrar: [User] = []
  static var userDefaults: UserDefaults = UserDefaults.standard
  static var localStoreService = LocalStoreService()
  //static var userRecordId: CKRecord!
  
}
