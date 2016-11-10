//
//  Utils.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 08/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    static public func goldColor() -> UIColor {
        return  UIColor.init(red: 234, green: 197, blue: 55)
    }
    
    static public func noImageColor() -> UIColor {
        return  UIColor.init(red: 234, green: 234, blue: 234)
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
