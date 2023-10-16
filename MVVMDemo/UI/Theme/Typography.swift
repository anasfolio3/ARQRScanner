//
//  Typography.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

// ERROR CASES
enum FontError: Error {
    case notFound
}

/// ProximaNova Font Enum
enum Typography: String {
    case regular = "OpenSans-Regular"
    case italic = "OpenSans-Italic"
    case bold = "OpenSans-Bold"
    case semiBold = "OpenSans-SemiBold"
    case light = "OpenSans-Light"
}

enum Fonts {
    static let secondaryButtonFont = UIFont(name: Typography.semiBold.rawValue, size: 14)
    static let dangerButtonFont = UIFont(name: Typography.bold.rawValue, size: 14)
}
