//
//  ProductDetails.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 07/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import SwiftyJSON

struct ProductDetails {

    var productId:Int
    let brand:String
    let productDescription:String
    let currentPrice:String
    var imageUrls = [String]()
    
    init (json:JSON) {
        productId = json["ProductId"].intValue
        brand = json["Brand"].stringValue
        currentPrice = json["CurrentPrice"].stringValue
        productDescription = json["Description"].stringValue
        for url in json["ProductImageUrls"].arrayValue {
            imageUrls.append(url.stringValue)
        }
    }
    
    // Note: This initializer is needed only to allow to override the productId returned by anyproduct_details.json
    //       Withouth this hack the user basket would contain only products with the same productId.
    init (productId:Int, json:JSON) {
        self.init(json:json)
        self.productId = productId
    }
}
