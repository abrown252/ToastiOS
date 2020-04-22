//
//  ToastEdge.swift
//  ToastIOS
//
//  Created by Alex Brown on 21/04/2020.
//  Copyright © 2020 AJB. All rights reserved.
//

import Foundation

public enum ToastEdge: Int {
    case top = 1
    case bottom
    
    var tag: Int {
        return 100 + self.rawValue
    }
}
