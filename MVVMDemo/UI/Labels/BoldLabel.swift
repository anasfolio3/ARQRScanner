//
//  BoldLabel.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class BoldLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = DesignVariables.FontSize.bold

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        clipsToBounds = true
        textColor = UIColor.primaryText
        self.font = UIFont(name: Typography.bold.rawValue, size: fontSize)
    }
}
