//
//  Extensions.swift
//  RIck&Morty
//
//  Created by Jahongir Anvarov on 09.05.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
