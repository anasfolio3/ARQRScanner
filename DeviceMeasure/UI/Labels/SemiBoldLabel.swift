//
//  SemiBoldLabel.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class SemiBoldLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = DesignVariables.FontSize.semiBold
    @IBInspectable var fontColor: UIColor = .primaryText {
        didSet {
            textColor = fontColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        clipsToBounds = true
        textColor = fontColor
        self.font = UIFont(name: Typography.semiBold.rawValue, size: fontSize)
    }
}
