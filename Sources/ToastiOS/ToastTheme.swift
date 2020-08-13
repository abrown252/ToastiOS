//
//  File.swift
//  
//
//  Created by Alex Brown on 13/08/2020.
//

import Foundation
import UIKit

public struct ToastTheme {
    let backgroundColor: UIColor
    let titleColor: UIColor
    let bodyColor: UIColor
}

public extension ToastTheme {
    static var standard: ToastTheme {
        var backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
        }

        var labelColor = UIColor.darkText
        if #available(iOS 13.0, *) {
            labelColor = .label
        }

        return ToastTheme(backgroundColor: backgroundColor,
                          titleColor: labelColor,
                          bodyColor: labelColor)
    }
}
