//
//  Extension + UIView.swift
//  BookCatalogue
//
//  Created by Julia on 08.02.2023.
//

import UIKit

extension UIView {
    
    func makeShadowWith(offset: CGSize = CGSize(width: 0, height: 0), shadowRadius: CGFloat = 3, shadowColor: CGColor = UIColor.black.cgColor, shadowOpacity: Float = 0.3) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
    }
}
