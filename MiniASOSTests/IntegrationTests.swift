//
//  IntegrationTests.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 08/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import XCTest
import SwiftyJSON

class IntegrationTests: XCTestCase {
    
    var appBuilder:AppBuilder!
    
    override func setUp() {
        super.setUp()
        appBuilder = AppBuilder()
    }
    
    override func tearDown() {
        self.appBuilder = nil
        super.tearDown()
    }
    
    //MARK: API tests
    
    func testFetchAllProductCategories() {
        
        // request product categories for women and men
        let theExpectation = expectation(description: "fetch the product categories for women and men.")
        appBuilder.api.fetchAllProductCategories(onCompletion: {categories -> Void in
            
            XCTAssertNotNil(categories, "categories results is nil")
            XCTAssertTrue(categories[.woman]!.count > 0, "woman categories is empty")
            XCTAssertTrue(categories[.man]!.count > 0, "man categories is empty")
            
            // check the default category
            let defaultCategory = categories[.woman]?.first
            XCTAssert((defaultCategory as Any) is ProductCategory, "defaultCategory is of wrong type")
            XCTAssertEqual(defaultCategory!.categoryId, "catalog01_1000_2623", "invalid default product category")
            XCTAssertEqual(defaultCategory!.name, "New In: Clothing", "invalid default product category")
            theExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30000, handler: { error in
            XCTAssertNil(error, "Request timeout!")
        })
    }
    
    
    func testFetchProductsForCategory() {
        
        let category = defaultProductCategory()
        
        let theExpectation = expectation(description: "fetch the products for a given category.")
        appBuilder.api.fetchProducts(for: category, onCompletion: {products, error -> Void in
            
            XCTAssertNotNil(products, "product array is nil")
            XCTAssertTrue(products.count > 0, "product array is empty")
            
            // check the first product returned by the api
            let firstProduct = products.first
            XCTAssert((firstProduct as Any) is Product, "Product is of the wrong type")
            XCTAssertEqual(firstProduct?.productId, 1743838, "invalid first product")
            
            theExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30000, handler: { error in
            XCTAssertNil(error, "Request timeout!")
        })
    }

    
    func testFetchProductDetails() {
        
        let product = productA()
        
        let theExpectation = expectation(description: "fetch the details for a product.")
        appBuilder.api.fetchProductDetails(productId:product.productId , onCompletion: {productDetails, error -> Void in
            
            XCTAssertNotNil(productDetails, "productDetails is nil")
            XCTAssert((productDetails as Any) is ProductDetails, "productDetails is of the wrong type")
            XCTAssertEqual(productDetails.productId, 1743838, "productDetails has invalid productId")
            XCTAssertEqual(productDetails.brand, "ASOS", "productDetails has invalid brand")
            XCTAssertEqual(productDetails.currentPrice, "£35.00", "productDetails has invalid price")
            
            theExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30000, handler: { error in
            XCTAssertNil(error, "Request timeout!")
        })
    }
    
    //MARK: ImageDownloader tests

    func testFetchImageSmall() {
    
        let smallImageUrl = "http://images.asos.com/inv/media/8/3/8/3/1743838/creamblack/image1xl.jpg"
        let theExpectation = expectation(description: "fetch a small image.")

        // Test the cache is empty
        let imageInCache = appBuilder.imageDownloader.imageCache.get(key: smallImageUrl)
        XCTAssertNil(imageInCache, "imageCache should not return an image")
        
        _ = appBuilder.imageDownloader.fetchImage(for: smallImageUrl, onCompletion: { image, error in
           
            XCTAssert((image as Any) is UIImage, "image is of the wrong type")
            
            // Test that imageCache contains this image
            let imageInCache = self.appBuilder.imageDownloader.imageCache.get(key: smallImageUrl)
            XCTAssertNotNil(imageInCache, "imageCache should have the cache")
            XCTAssertEqual(image, imageInCache, "cache returned the same image")
            
            theExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30000, handler: { error in
            XCTAssertNil(error, "Request timeout!")
        })

    }
    
    func testFetchImageLarge() {
        
        let largeImageUrl = "http://images.asos.com/inv/media/9/8/4/3/1703489/red/image1xxl.jpg"
        let theExpectation = expectation(description: "fetch a large image.")
        
        _ = appBuilder.imageDownloader.fetchImage(for: largeImageUrl, onCompletion: { image, error in
            
            // Test that the large image has been resized before being returned.
            XCTAssert((image as Any) is UIImage, "image is of the wrong type")
            XCTAssertEqual(image?.size.width, 400, "Image was not resized")
            
            theExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 30000, handler: { error in
            XCTAssertNil(error, "Request timeout!")
        })
    }
    
    //MARK: Privates

    private func defaultProductCategory() -> ProductCategory {
        let json = "{\"CategoryId\": \"catalog01_1000_2623\", \"Name\": \"New In: Clothing\", \"ProductCount\": 211}"
        return ProductCategory(json:JSON.parse(json))
    }
    
    private func productA() -> Product {
        let json = "{\"ProductId\": 1743838, \"Brand\": \"ASOS\", \"Title\": \"ASOS Blouse With Tipped Drop Collar\"}"
        return Product(json:JSON.parse(json))
    }
    
}
