//
//  PrimaryLabel.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class RegularLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = DesignVariables.FontSize.regualar
    @IBInspectable var fontColor: UIColor = .primaryText

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        clipsToBounds = true
        textColor = fontColor
        self.font = UIFont(name: Typography.regular.rawValue, size: fontSize)
    }
}
