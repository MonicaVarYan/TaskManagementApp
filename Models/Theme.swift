//
//  Theme.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-08-10.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard

enum AssetsColor : String {
    case Dark
    case Light
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        var colorName = "0-" + name.rawValue
        if let theme = defaults.string(forKey: "theme"){
            colorName = theme + "-" + name.rawValue //THEME-UIELEMENT
        }
        
        return UIColor(named: colorName)
    }
    
    static func appColorByColor(_ color: Int, name: AssetsColor) -> UIColor? {
        let colorName =  String(color) + "-" + name.rawValue
        return UIColor(named: colorName)
    }
}
