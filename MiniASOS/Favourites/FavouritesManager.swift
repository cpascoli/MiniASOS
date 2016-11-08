//
//  FavouritesManager.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

/**
 * This class manages the user Favourites Products.
 * Favourites Products are returned ordered by alphabetically.
 */

class FavouritesManager: NSObject {
    
    private var faves = Set<Product>()
    
    
    public func add(product:Product) {
        faves.insert(product)
    }
    
    public func remove(product:Product) {
        faves.remove(product)
    }

    public func isFavourite(product:Product) -> Bool {
        return faves.contains(product)
    }
    
    public func favourites() -> [Product] {
        return self.faves.sorted(by:{$0.title < $1.title})
    }
}
