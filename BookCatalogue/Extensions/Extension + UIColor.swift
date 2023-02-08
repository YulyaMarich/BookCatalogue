//
//  Extension + UIColor.swift
//  BookCatalogue
//
//  Created by Julia on 08.02.2023.
//

import UIKit

extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(named: "backgroundColor") ?? .orange
    }
    
    static var lightBrownColor: UIColor {
        return UIColor(named: "lightBrownColor") ?? .orange
    }
}
