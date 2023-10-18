//
//  UIColor+Extensions.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

extension UIColor {
    /// Get white component of current color
    var whiteComponent: CGFloat {
        var white: CGFloat = 0.0
        getWhite(&white, alpha: nil)
        return white
    }
}

public extension UIColor {
    /// Creates color from hexadecimal string
    ///
    /// Example input string cab be with # prefix i.e. #FF00FF or FF00FF
    /// - Parameters:
    ///   - hexString: Valid hexadecimal string
    ///   - alpha: Alpha value of color, default is 1.0

    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = hexString.hasPrefix("#") ? 1 : 0
        var intRGB: UInt64 = 0
        scanner.scanHexInt64(&intRGB)
        let red = (intRGB & 0xFF0000) >> 16
        let green = (intRGB & 0xFF00) >> 8
        let blue = intRGB & 0xFF
        self.init(red: CGFloat(red) / 0xFF, green: CGFloat(green) / 0xFF, blue: CGFloat(blue) / 0xFF, alpha: alpha)
    }

    ///  hexadecimal (a hex triplet) representation of current color.
    var hexString: String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red * 0xFF), Int(red * 0xFF), Int(green * 0xFF))
    }
}

@objc extension UIColor {
    static let primaryText = UITraitCollection.current.userInterfaceStyle == .dark ? UIColor("#ffffff") : UIColor("#05122E")
    static let secondaryText = UITraitCollection.current.userInterfaceStyle == .dark ? UIColor("#f5f3f2") : UIColor("#3B4A57")
    static let accentColor = UIColor("#b1f7ad")
}
