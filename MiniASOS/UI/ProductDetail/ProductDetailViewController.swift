//
//  ProductDetailViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 07/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

class ProductDetailViewController: BaseViewController {

    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var imageCarouselContainerView: UIView!
    @IBOutlet weak var addToBagButton: UIButton!
    @IBOutlet weak var carouselContainerView: UIView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    // Injected Properties
    var imageDownloader:ImageDownloader!
    var product:ProductDetails! {
        didSet {
           self.updateUI()
        }
    }
    
    //MARK: ViewController LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func setupUI() {
        super.setupUI()
        self.brandNameLabel.layer.borderWidth = 1
        self.brandNameLabel.layer.borderColor = UIColor.black.cgColor
        let backButton = self.makeButton(image: "back", title:nil, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.brandNameLabel.text = nil
        self.productDescriptionLabel.text = nil
        self.addToBagButton.setTitle(nil, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageDownloader.imageCache.resetCache()
    }
    
    //MARK: Actions
    func backButtonTapped() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToBagTapped(_ sender: AnyObject) {
        self.basketManager.add(product:self.product)
    }
    
    //MARK: Private
    private func updateUI() {
        self.brandNameLabel.text = product.brand
        self.productDescriptionLabel.text = product.productDescription
        let addToBag = "Add to Bag".localized
        let buttonTitle = "\(addToBag) \(product.currentPrice)"
        self.addToBagButton.setTitle(buttonTitle, for: .normal)
        addCarousel()
    }
    
    private func addCarousel() {
    
        let pageViewContoller = ProductPageViewController()
        pageViewContoller.imageDownloader = self.imageDownloader
        pageViewContoller.imageUrls = self.product.imageUrls
        pageViewContoller.view.frame = CGRect(x: 0, y: 0, width:
            carouselContainerView.bounds.width, height: carouselContainerView.bounds.height)
        
        self.addChildViewController(pageViewContoller)
        self.carouselContainerView.addSubview(pageViewContoller.view)
        pageViewContoller.didMove(toParentViewController: self)
    
    }

}
