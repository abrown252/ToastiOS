//
//  ToastAccessory.swift
//  ToastiOS
//
//  Created by Alex Brown on 24/04/2020.
//

import Foundation
import UIKit

public struct ToastAccessory {
    
    public enum AccessoryViewPosition: Int {
        case left = 1
        case right
    }
    
    let accessoryView: UIView
    let position: AccessoryViewPosition
    
    public init(accessoryView: UIView, position: AccessoryViewPosition) {
        self.accessoryView = accessoryView
        self.position = position
    }
}
