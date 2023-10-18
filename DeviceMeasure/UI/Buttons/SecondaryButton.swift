//
//  SecondaryButton.swift
//  SafaPayDemo
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class SecondaryButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: DesignVariables.Button.secondaryButtonHeight).isActive = true

        layer.cornerRadius = DesignVariables.CornerRadius.buttonCornerRadius
        tintColor = .secondaryText
        titleLabel?.font = Fonts.secondaryButtonFont
        layer.borderWidth = 1
        layer.borderColor = UIColor.accentColor.cgColor
    }
}
