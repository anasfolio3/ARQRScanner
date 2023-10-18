//
//  UIImageView+Extensions.swift
//  DeviceMeasure
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    private var _isRounded = false

    @IBInspectable var isRounded: Bool {
        get {
            return self._isRounded
        }
        set {
            _isRounded = newValue
            makeRound()
        }
    }

    private func makeRound() {
        if self._isRounded {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
        } else {
            self.layer.cornerRadius = 0
        }
    }
}
