//
//  ProductPageViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 07/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

class ProductPageViewController: UIPageViewController {

    // Injected Properties
    var imageDownloader:ImageDownloader!
    var imageUrls:[String]!
    
    var contentViewControllerArray = [PageContentViewController]()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]?) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        self.setupViewControllers(with:self.imageUrls)
        
        if let firstController = self.contentViewControllerArray.first {
            setViewControllers([firstController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.dataSource = self
    }
    
    func setupViewControllers(with urls:[String]) {
        
        var viewContollers = [PageContentViewController]()
        for url in urls {
            let viewController = pageContentViewController()
            viewController.imageDownloader = self.imageDownloader
            viewController.url = url
            viewContollers.append(viewController)
           
        }
        self.contentViewControllerArray = viewContollers
    }
    
    func pageContentViewController() -> PageContentViewController {
        let viewContoller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductContentPage") as! PageContentViewController
        return viewContoller
    }
}



// MARK: UIPageViewControllerDataSource

extension ProductPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = contentViewControllerArray.index(of: viewController as! PageContentViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return contentViewControllerArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        guard let viewControllerIndex = contentViewControllerArray.index(of: viewController as! PageContentViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < contentViewControllerArray.count else {
            return nil
        }
        return contentViewControllerArray[nextIndex]
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentViewControllerArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
