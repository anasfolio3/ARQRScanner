//
//  UIImageView+Extensions.swift
//  MVVMDemo
//
//  Created by Zayan Tharani on 27/06/2022.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    self.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
