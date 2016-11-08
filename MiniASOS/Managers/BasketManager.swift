//
//  BasketManager.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 07/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

protocol BasketObserver : class {
    func basketDidChange(basket:BasketManager)
}

/**
 * This class manages the Basket of products the user wants to buy.
 * the
 */

class BasketManager: NSObject {

    private var items = [Int:Int]()
    private var observers = [BasketObserver]()
    
    /**
     * @param product a new item that is being added to the basket.
     */
    public func add(product:ProductDetails) {
       var count = items[product.productId]
       if count == nil  {
            count = 0
       }
       items[product.productId] = count! + 1
       notifyObservers()
    }
    
    /**
     * @return the array of the different products in the basket.
     */
    public func productIds() -> [Int] {
       return Array(items.keys)
    }
    
    /**
     * @param productId the id of the product.
     * @return the number of items in the basket for the given product id.
     */
    public func itemCount(for productId:Int) -> Int {
        var count = items[productId]
        if count == nil {
            count = 0
        }
        return count!
    }
    
    /** 
     * @return the total number of items in the basket.
     */
    public func totalItemsCount() -> Int {
        var count = 0
        for (_, value) in items {
           count = count + value
        }
        return count
    }
    
    //MARK: Basket Observers
    
    /**
     * @param observer a new observer that wasnt to be notified of a change in the basket.
     */
    public func addObserver(observer:BasketObserver) {
        observers.append(observer)
        observer.basketDidChange(basket:self)
    }
    
    /**
     * @param observer the observer that wants to be removed from updates to the basket.
     */
    public func removeObserver(observer:BasketObserver) {
        for (index, element) in observers.enumerated() {
            if element == observer {
               observers.remove(at:index)
            }
        }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.basketDidChange(basket:self)
        }
    }
}

func ==(lhs: BasketObserver, rhs: BasketObserver) -> Bool {
    return lhs === rhs
}
