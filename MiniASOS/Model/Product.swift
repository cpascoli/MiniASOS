//
//  Product.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import SwiftyJSON

struct Product : Hashable, Equatable {

    let productId:Int
    let currentPrice:String
    let imageUrl:String
    let title:String

    init (json:JSON) {
        productId = json["ProductId"].intValue
        currentPrice = json["CurrentPrice"].stringValue
        imageUrl = json["ProductImageUrl"][0].stringValue
        title = json["Title"].stringValue        
    }
    
    var hashValue: Int {
        return productId.hashValue
    }
}

func == (a: Product, b: Product) -> Bool {
    return a.productId == b.productId
}
