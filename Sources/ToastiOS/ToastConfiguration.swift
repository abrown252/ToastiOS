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

struct ToastConfiguration {
    let title: String
    let body: String?
    let image: UIImage?
    let edge: ToastEdge
    let displayDuration: TimeInterval
}
