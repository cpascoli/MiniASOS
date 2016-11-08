//
//  ProductCategory.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit
import SwiftyJSON

public struct ProductCategory {

    let categoryId:String
    let name:String
    let productCount:Int

    init (json:JSON) {
        categoryId = json["CategoryId"].stringValue
        name = json["Name"].stringValue
        productCount = json["ProductCount"].intValue
    }
}
