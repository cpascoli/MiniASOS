//
//  AppBuilder.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

/**
 * The AppBuilder is the singleton responsible to construct and assembly other singletons and ViewContollers.
 * It uses the Dependency Injection to provide the required dependencies to the objects.
 */

import UIKit

class AppBuilder: NSObject {
    
    let favouritesManager = FavouritesManager()
    let basketManager = BasketManager()
    let api = APIClient()
    let imageDownloader = ImageDownloader()
    
    override init() {
    
        let session = URLSession(configuration:.default, delegate: imageDownloader, delegateQueue: OperationQueue.main)
        api.session = session
        imageDownloader.session = session
    }
    
    //MARK: ViewContollers
    
    func newSplashScreen() -> SplashScreenViewController {
        
        let viewController = mainStoryboard().instantiateViewController(withIdentifier: "SplashScreen") as! SplashScreenViewController
        return viewController;
    }
    
    func newMenuViewController() -> MenuViewController {
         let viewController  = mainStoryboard().instantiateViewController(withIdentifier:"Menu") as! MenuViewController
         return viewController
    }
    
    func newProductListingsViewController() -> ProductListingsViewController {
        let viewController = mainStoryboard().instantiateViewController(withIdentifier:"Main") as! ProductListingsViewController
        viewController.api = self.api
        viewController.imageDownloader = self.imageDownloader
        viewController.favouritesManager = self.favouritesManager
        viewController.basketManager = self.basketManager
        return viewController
    }
    
    func newProductDetailsViewController() -> ProductDetailViewController {
        
        let viewController = mainStoryboard().instantiateViewController(withIdentifier: "ProductDetails") as! ProductDetailViewController
        viewController.favouritesManager = favouritesManager
        viewController.basketManager = self.basketManager
        viewController.imageDownloader = self.imageDownloader
        return viewController;
    }
    
    func newMainScreenViewController(productCategories: [ProductCategotyType:[ProductCategory]]) -> ContainerViewController {
        
        let mainViewController = ContainerViewController()
        mainViewController.imageDownloader = imageDownloader
        
        let menuViewController = self.newMenuViewController()
        menuViewController.productCategories = productCategories
        let productListingsViewController = self.newProductListingsViewController()
        let navigationController = UINavigationController(rootViewController: productListingsViewController)
        
        mainViewController.menuViewController = menuViewController
        productListingsViewController.delegate = mainViewController
        
        // block fetch the details for a Product and transition to the ProductDetails screen
        productListingsViewController.productTapped =  { product in
           
            let productDetailsViewController = self.newProductDetailsViewController()
            productListingsViewController.navigationController?.pushViewController(productDetailsViewController, animated: true)
            self.api.fetchProductDetails(productId: product.productId, onCompletion: { productDetails, error in
                productDetailsViewController.product = productDetails
            })
        }

        menuViewController.delegate = productListingsViewController
        mainViewController.productListingNavigationController = navigationController
        return mainViewController;
    }

    
    //MARK: Private
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle(for:type(of:self)))
    }
}


