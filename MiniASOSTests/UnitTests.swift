//
//  MiniASOSTests.swift
//  MiniASOSTests
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import MiniASOS

class UnitTests: XCTestCase {
    
    var appBuilder:AppBuilder!
 
    override func setUp() {
        super.setUp()
        appBuilder = AppBuilder()
    }
    
    override func tearDown() {
        self.appBuilder = nil
        super.tearDown()
    }
    
    //MARK: ViewController Tests
    
    func testMainStoriboard() {
        let storyboard = appBuilder.mainStoryboard()
        XCTAssertNotNil(storyboard, "the main storiboard is nil")
    }
    
    func testSplashScreen() {
        let viewController = appBuilder.newSplashScreen()
        XCTAssertNotNil(viewController, "the SplashScreenViewController is nil")
        XCTAssert((viewController as Any) is SplashScreenViewController, "SplashScreenViewController is wrong type")
    }
    
    func testMenuViewController() {
        
        let viewController = appBuilder.newMenuViewController()
        XCTAssertNotNil(viewController, "the MenuViewController is nil")
        XCTAssert((viewController as Any) is MenuViewController, "MenuViewController is wrong type")

        _ = viewController.view
        XCTAssertNotNil(viewController.segmentedControl, "the segmentedControl is nil")
        XCTAssertNotNil(viewController.tableView, "the tableView is nil")
    }
    
    func testProductListingsViewController() {
        
        let viewController = appBuilder.newProductListingsViewController()
        XCTAssertNotNil(viewController, "the ProductListingsViewController is nil")
        XCTAssert((viewController as Any) is ProductListingsViewController, "ProductListingsViewController is wrong type")

        XCTAssertNotNil(viewController.api, "the apiClient is nil")
        XCTAssertNotNil(viewController.imageDownloader, "the imageDownloader is nil")
        XCTAssertNotNil(viewController.favouritesManager, "the favouritesManager is nil")
        XCTAssertNotNil(viewController.basketManager, "the basketManager is nil")
        
        _ = viewController.view
        XCTAssertNotNil(viewController.collectionView, "the collectionView is nil")

    }
    
    func testProductDetailsViewContoller() {
        
        let viewController = appBuilder.newProductDetailsViewController()
        XCTAssertNotNil(viewController, "the ProductDetailsViewContoller is nil")
        XCTAssert((viewController as Any) is ProductDetailViewController, "ProductDetailViewController is wrong type")

        XCTAssertNotNil(viewController.imageDownloader, "the imageDownloader is nil")
        XCTAssertNotNil(viewController.favouritesManager, "the favouritesManager is nil")
        XCTAssertNotNil(viewController.basketManager, "the basketManager is nil")
        
        _ = viewController.view
        XCTAssertNotNil(viewController.brandNameLabel, "the brandNameLabel is nil")
        XCTAssertNotNil(viewController.imageCarouselContainerView, "the imageCarouselContainerView is nil")
        XCTAssertNotNil(viewController.productDescriptionLabel, "the collectionView is nil")
        XCTAssertNotNil(viewController.addToBagButton, "the addToBagButton is nil")
        XCTAssertNotNil(viewController.carouselContainerView, "the carouselContainerView is nil")
        
    }
    
    func testMainScreenViewController() {
    
        let categories = [ProductCategotyType:[ProductCategory]]()
        let viewController = appBuilder.newMainScreenViewController(productCategories: categories)
        XCTAssertNotNil(viewController, "the MainScreenViewController is nil")
        XCTAssert((viewController as Any) is ContainerViewController, "MainScreenViewController is wrong type")
        
        XCTAssertNotNil(viewController.imageDownloader, "the imageDownloader is nil")
        XCTAssertNotNil(viewController.menuViewController, "the menuViewController is nil")
        XCTAssertNotNil(viewController.menuViewController.delegate, "the menuViewController.delegate is nil")
    }

  
    //MARK: Data Managers Tests
    
    func testBasketManager() {
        
        let basket = appBuilder.basketManager
        XCTAssertEqual(basket.totalItemsCount(), 0, "basket isn the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703489), 0, "basket isn the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703264), 0, "basket isn the wrong state")
        
        // adding the first item   
        let item1 = productDetailsA()
        basket.add(product: item1)
        XCTAssertEqual(basket.totalItemsCount(), 1, "basket isn the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703489), 1, "basket isn the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703264), 0, "basket isn the wrong state")
        
        // adding a second item
        let item2 = productDetailsB()
        basket.add(product: item2)
        XCTAssertEqual(basket.totalItemsCount(), 2, "basket isn the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703489), 1, "basket is in the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703264), 1, "basket is in the wrong state")
        

        // adding a third item of the second product
        let item3 = productDetailsB()
        basket.add(product: item3)
        XCTAssertEqual(basket.totalItemsCount(), 3, "basket isn the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703489), 1, "basket is in the wrong state")
        XCTAssertEqual(basket.itemCount(for: 1703264), 2, "basket is in the wrong state")
        
    }

    func testFavouritesManager() {
    
        let favourites = appBuilder.favouritesManager
        
        let item1 = productA()
        let item2 = productB()
        
        favourites.add(product: item1)
        XCTAssertTrue(favourites.isFavourite(product: item1), "item1 should be favourite")
        XCTAssertFalse(favourites.isFavourite(product: item2), "item2 should not be favourite")
        
        favourites.add(product: item2)
        XCTAssertTrue(favourites.isFavourite(product: item2), "item2 should be favourite")

    }
 
    // MARK: Private
    
    private func productA() -> Product {
        let json = "{\"ProductId\": 1743838, \"Brand\": \"ASOS\", \"Title\": \"ASOS Blouse With Tipped Drop Collar\"}"
        return Product(json:JSON.parse(json))
    }
    
    private func productB() -> Product {
        let json = "{\"ProductId\": 1755616, \"Brand\": \"ASOS\", \"Title\": \"ASOS Mini Skirt With Pocket Front Panel\"}"
        return Product(json:JSON.parse(json))
    }
    
    private func productDetailsA() -> ProductDetails {
        let json = "{\"ProductId\": 1703489, \"Brand\": \"ASOS\", \"Description\": \"Fringed crop top...\"}"
        return ProductDetails(json:JSON.parse(json))
    }
    
    private func productDetailsB() -> ProductDetails {
        let json = "{\"ProductId\": 1703264, \"Brand\": \"ASOS\", \"Description\": \"Top With Beading...\"}"
        return ProductDetails(json:JSON.parse(json))
    }
}
