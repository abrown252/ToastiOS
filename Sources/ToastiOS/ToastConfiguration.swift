//
//  ToastConfiguration.swift
//  ToastIOS
//
//  Created by Alex Brown on 20/04/2020.
//  Copyright © 2020 AJB. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

public struct ToastConfiguration {
    let title: String
    let body: String?
    let accessoryView: ToastAccessory?
    let edge: ToastEdge
    let displayDuration: TimeInterval
    
    public init(title: String, body: String?, accessoryView: ToastAccessory?, edge: ToastEdge, displayDuration: TimeInterval) {
        self.title = title
        self.body = body
        self.accessoryView = accessoryView
        self.edge = edge
        self.displayDuration = displayDuration
    }
}
