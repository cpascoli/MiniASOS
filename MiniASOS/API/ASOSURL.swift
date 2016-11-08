//
//  ASOSURL.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 08/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

struct ASOSURL {

    struct Categories {
        static let man = URL(string:"https://dl.dropboxusercontent.com/u/1559445/ASOS/SampleApi/cats_men.json")
        static let woman = URL(string:"https://dl.dropboxusercontent.com/u/1559445/ASOS/SampleApi/cats_women.json")
    }
    
    struct Product {
        static let products = URL(string:"https://dl.dropboxusercontent.com/u/1559445/ASOS/SampleApi/anycat_products.json?catid=#catId")
        static let productDetails = URL(string:"https://dl.dropboxusercontent.com/u/1559445/ASOS/SampleApi/anyproduct_details.json?catid=#prod_id_here")
    }

}
