//
//  LAContentExt.swift
//  NoIce
//
//  Created by Donelkys Santana on 6/6/21.
//  Copyright © 2021 Done Santana. All rights reserved.
//

import Foundation
import LocalAuthentication

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error through fabric
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }

        return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }

}
