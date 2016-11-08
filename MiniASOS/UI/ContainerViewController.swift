//
//  ContainerViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

enum MenuState {
    case collapsed
    case expanded
}

/**
 * The Container ViewController than includes the Menu palen and Main screen.
 * It manage the slide out menu.
 */

class ContainerViewController: UIViewController {

    // Injected Properties
    var menuViewController: MenuViewController!
    var productListingNavigationController: UINavigationController!
    var imageDownloader:ImageDownloader!
    
    fileprivate let expandedOffset: CGFloat = 60
    
    var currentState: MenuState = .collapsed {
        didSet {
            let showShadow = currentState == .expanded
            addShadowToProductListingsView(showShadow)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildMenuController(menuViewController)
        view.addSubview(productListingNavigationController.view)
        addChildViewController(productListingNavigationController)
        productListingNavigationController.didMove(toParentViewController: self)
    }

    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.imageDownloader.imageCache.resetCache()
    }
}

extension ContainerViewController: ProductListingsViewControllerDelegate {
    
    func toggleMenuPanel() {
        let notAlreadyExpanded = (currentState != .expanded)
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func hideMenuPanel() {
        animateLeftPanel(shouldExpand: false)
    }

    func addChildMenuController(_ menuViewController: MenuViewController) {
        view.insertSubview(menuViewController.view, at: 0)
        addChildViewController(menuViewController)
        menuViewController.didMove(toParentViewController: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        
        if (shouldExpand) {
            currentState = .expanded
            
            animateCenterPanelXPosition(targetPosition: productListingNavigationController.view.frame.width - expandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .collapsed
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.productListingNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func addShadowToProductListingsView(_ shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            productListingNavigationController.view.layer.shadowOpacity = 0.5
        } else {
            productListingNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
}
