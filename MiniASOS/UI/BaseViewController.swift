//
//  BaseViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 07/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

/**
 * A Base ViewController class used by Listings and Product details screens 
 * to handle the Basket and Favourites.
 */

class BaseViewController: UIViewController, BasketObserver {

    // Injected Dependencies
    var favouritesManager:FavouritesManager!
    var basketManager:BasketManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.basketManager.addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.basketManager.removeObserver(observer: self)
    }
    
    //MARK: BasketObserver
    func basketDidChange(basket:BasketManager) {
        setRightButtons()
    }

    func setupUI() {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = UIViewContentMode.scaleAspectFit
        logo.frame = CGRect.init(x:0, y:0, width:100, height:25)
        self.navigationItem.titleView = logo
        setRightButtons()
    }
    
    func setRightButtons() {
    
        // update the basket buttons
        let itemCount = String(describing: basketManager.totalItemsCount())
        let wishlistButton = self.makeButton(image: "wishlist", title:nil, action: #selector(wishlistButtonTapped))
        let basketButton = self.makeButton(image: "basket", title:itemCount, action: #selector(basketButtonTapped))
        self.navigationItem.rightBarButtonItems = [basketButton, wishlistButton]
        
    }
    
    func wishlistButtonTapped() {
        showFavourites()
    }
    
    func basketButtonTapped() {
        showBasket()
    }
    
    func makeButton(image:String, title:String?, action: Selector) -> UIBarButtonItem {
        
        let button = UIButton.init(type:.custom)
        button.frame = CGRect.init(origin:CGPoint.init(x:0, y:0) , size:CGSize.init(width:30, height:30) )
        button.setBackgroundImage(UIImage(named: image), for: UIControlState.normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.titleEdgeInsets = UIEdgeInsetsMake(5.0, 0.0, 0.0, 0.0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: action, for:.touchUpInside)
        let barButton = UIBarButtonItem.init(customView:button)
        return barButton
    }
    
    
    //MARK: Show Alerts
    func showFavourites() {
        let faves = self.favouritesManager!.favourites()
        if faves.count > 0 {
            var message = String()
            for product in faves {
                message += "[\(product.productId)] \(product.title)\n"
            }
            showAlert(title:"Favourites".localized, message:message)
        }
    }
    
    func showBasket() {
        let productIds = self.basketManager.productIds()
        if productIds.count > 0 {
            var message = String()
            let messagePrefix = "Product".localized
            for productId in productIds {
                message += "\(messagePrefix) [\(productId)] x \(self.basketManager.itemCount(for: productId))\n"
            }
            showAlert(title:"Bag".localized, message:message)
        }
    }
    
    private func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}
