//
//  ProductListingsViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

protocol ProductListingsViewControllerDelegate : class {
    func toggleMenuPanel()
    func hideMenuPanel()
}


class ProductListingsViewController: BaseViewController, MenuDelegate {


    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Injected dependencies
    weak var delegate: ProductListingsViewControllerDelegate!
    var api:APIClient!
    var imageDownloader:ImageDownloader!
    var productTapped:((Product) -> Void)!
    
    fileprivate var products:[Product]?
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let cellAspectRatio: CGFloat = 1.6
    fileprivate let cellPadding: CGFloat = 10
    
    private var productCategory:ProductCategory?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.flashScrollIndicators()
    }

    override func setupUI() {
        super.setupUI()
        self.productCategoryLabel.layer.borderWidth = 1
        self.productCategoryLabel.layer.borderColor = UIColor.black.cgColor
        let menuButton = self.makeButton(image: "menu", title:nil, action: #selector(menuButtonTapped))
        self.navigationItem.leftBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageDownloader.imageCache.resetCache()
    }
    
    //MARK: Actions
    func menuButtonTapped() {
        delegate?.toggleMenuPanel()
    }
    
    //MARK: MenuDelegate
    func categorySelected(category:ProductCategory) {
        self.productCategory = category
        self.api!.fetchProducts(for:category, onCompletion: { products, error in
            self.products = products
            self.delegate?.hideMenuPanel()
            self.updateUI()
        })
    }
    
    private func updateUI() {
        self.productCategoryLabel.text = productCategory?.name
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension ProductListingsViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let products = self.products,
            let productTapped = self.productTapped else {
            return
        }
        let product = products[indexPath.row]
        productTapped(product)
    }
   
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


extension ProductListingsViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / itemsPerRow) - cellPadding
        let height = width * cellAspectRatio
        return CGSize.init(width:width, height:height)
    }
}

extension ProductListingsViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int {
        guard let products = self.products else {
            return 0
        }
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProductCollectionViewCell
        guard let products = self.products else {
            return cell
        }
        
        let product = products[indexPath.row]
        
        if let favouritesManager = self.favouritesManager {
            let fave = favouritesManager.isFavourite(product:product)
            cell.isSelected = fave
        }
        cell.imageDownloader = self.imageDownloader
        cell.delegate = self
        cell.product = product
        return cell
    }
}

extension ProductListingsViewController : ProductCellDelegate {

    func fave(product:Product) {
        if let favouritesManager = self.favouritesManager {
            favouritesManager.add(product:product)
        }
    }
    
    func unFave(product:Product) {
        if let favouritesManager = self.favouritesManager {
            favouritesManager.remove(product:product)
        }
    }
    
    func select(product:Product) {
        if let productTapped = self.productTapped {
            productTapped(product)
        }
    }
}
