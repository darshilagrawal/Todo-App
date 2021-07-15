//
//  Helper.swift
//  Todoey
//
//  Created by Darshil Agrawal on 15/07/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

