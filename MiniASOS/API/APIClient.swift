//
//  APIClient.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ProductCategotyType : Int {
   case woman = 0
   case man = 1
  
}


// API Response types
typealias ProductCategoriesResponse = ([ProductCategory], NSError?) -> Void
typealias AnyCategoryProductsResponse = ([Product], NSError?) -> Void
typealias ProducDetailsResponse = (ProductDetails, NSError?) -> Void
typealias JSONResponse = (JSON, NSError?) -> Void


typealias CategoriesMapResponse = ([ProductCategotyType:[ProductCategory]]) -> Void

/**
 * This class is used to integrate the RESTful Service API via JSON calls.
 * It exposes methods to fetch product categories and product listings, and product details.
 * The client callbacks are invoken on the Main Thread to allow todirectly update the UI.
 *
 */

class APIClient: NSObject {
    
    // Injected property
    var session: URLSession!

    
    //MARK: API Services
    
    /**
      Fetches the product categories for a ProductCategotyType
     
      @param type the ProductCategotyType of the product categories to fetch (i.e. .women, .men)
      @param onCompletion the completion block returning an array of ProductCategory
    */
    public func fetchProductCategories(type:ProductCategotyType, onCompletion:@escaping ProductCategoriesResponse) {
        
        let url = (type == .man) ? ASOSURL.Categories.man : ASOSURL.Categories.woman
        let request = fetchRequest(for: url!)
        execute(request: request, handler: { json, error -> Void in
            
            var listingsArray = [ProductCategory]()
            for item in json["Listing"].arrayValue {
                let category = ProductCategory(json:item)
                listingsArray.append(category)
            }
            onCompletion(listingsArray, error)
        })
    }
    
    /**
      Fetches the products for a given category.
     
      @param category the caregory of products to fetch. For the scope of this excersie is unused.
      @param onCompletion the completion block returning an array of Product
    */
    public func fetchProducts(for category:ProductCategory, onCompletion:@escaping AnyCategoryProductsResponse) {
        
        let url = ASOSURL.Product.products
        let request = fetchRequest(for: url!)
        execute(request: request, handler: { json, error -> Void in
            var listingsArray = [Product]()
            for item in json["Listings"].arrayValue {
                let category = Product(json:item)
                listingsArray.append(category)
            }
            onCompletion(listingsArray, error)
        })
    }
    
    /**
      Fetches the product details for a given productId
     
      @param productId the id of the product to fetch.
      @param onCompletion the completion block returning a ProductDetails
    */
    public func fetchProductDetails(productId:Int, onCompletion:@escaping ProducDetailsResponse) {
    
        let url = ASOSURL.Product.productDetails
        let request = fetchRequest(for: url!)
        execute(request: request, handler: { json, error -> Void in
            let productDetails = ProductDetails.init(productId: productId, json: json)
            onCompletion(productDetails, error)
        })
    }

    
    /**
      Downloads the prodcut categories for Women and Men concurrently.
      Uses a barrier to ensure both  API calls have returned before invocking the callback block.
    
      @param onCompletion the completion handler
     
     */
    public func fetchAllProductCategories(onCompletion: @escaping CategoriesMapResponse) {
    
       let concurrentQueue = DispatchQueue(label: "queue.categories", attributes: .concurrent)
       
       concurrentQueue.async(execute:{
            var categories = [ProductCategotyType:[ProductCategory]]()
            let group = DispatchGroup()
        
            group.enter()
            self.fetchProductCategories(type: .man, onCompletion: {result, error in
                categories[.man] = result
                group.leave()
            })
        
            group.enter()
            self.fetchProductCategories(type: .woman, onCompletion: {result, error in
                categories[.woman] = result
                group.leave()
            })
        
            group.wait()
        
            // update the UI on the main thread
            DispatchQueue.main.async(execute:{
                onCompletion(categories)
            })
        })
    }
    
    
    //MARK: Private
    private func fetchRequest(for url:URL) -> URLRequest {
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func execute(request:URLRequest, handler:@escaping JSONResponse) {
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            guard let data = data, error == nil else {
                handler(JSON.null, error as NSError?)
                return
            }
            let json = JSON(data:data)
            handler(json, error as NSError?)
        })
        task.resume()
    }

}
