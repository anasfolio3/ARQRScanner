//
//  CaptionLabel.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class CaptionLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = DesignVariables.FontSize.caption
    @IBInspectable var fontName: String = Typography.light.rawValue

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        clipsToBounds = true
        textColor = UIColor.secondaryText
        self.font = UIFont(name: fontName, size: fontSize)
    }
}
