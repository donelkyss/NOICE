//
//  LoginController.swift
//  NoIce
//
//  Created by Donelkys Santana on 4/6/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit

extension LoginController{
    func generateUserUUID(){
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        print("unique ID: \(device_id)")
    }
    
    
}
