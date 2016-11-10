//
//  ProductCollectionViewCell.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

protocol ProductCellDelegate : class {
    func fave(product:Product)
    func unFave(product:Product)
    func select(product:Product)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    var imageDownloader:ImageDownloader?
    weak var delegate: ProductCellDelegate?

    private var selectedColor = UIColor.goldColor()
    private var downloadTaskId:Int?
    
    var product:Product? {
        didSet {
            self.priceLabel.text = product!.currentPrice
            self.imageUrl = product!.imageUrl
        }
    }
    
    var imageUrl:String? {
        didSet {
            downloadImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerGestureRecognisers()
    }
    
    override func prepareForReuse() {
        if let taskId = self.downloadTaskId {
            self.imageDownloader?.cancel(taskId:taskId)
        }
        self.imageView.image = nil
        self.priceLabel.text = nil
        self.isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.imageView.layer.borderWidth = 5
                self.imageView.layer.borderColor = selectedColor.cgColor
            } else {
                self.imageView.layer.borderWidth = 0
                self.imageView.layer.borderColor = nil
            }
        }
    }

    private func registerGestureRecognisers() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        addGestureRecognizer(singleTap)
        addGestureRecognizer(doubleTap)
    }
    
    func singleTap(_ sender: UITapGestureRecognizer) {
        if let delegate = self.delegate, let product = self.product {
            delegate.select(product: product)
        }
    }
    
    func doubleTap(_ sender: UITapGestureRecognizer) {
        if let delegate = self.delegate, let product = self.product {
            self.isSelected = !self.isSelected
            if (self.isSelected) {
                delegate.fave(product:product)
            } else {
                delegate.unFave(product:product)
            }
        }
    }
    
    private func downloadImage() {
        self.imageView.backgroundColor = UIColor.noImageColor()
        if let downloader = self.imageDownloader {
            let taskId = downloader.fetchImage(for: imageUrl!,  onCompletion: { image, error in
                if (image != nil) {
                    self.imageView.image = image
                    self.imageView.backgroundColor = UIColor.white
                }
            })
            self.downloadTaskId = taskId > -1 ? taskId : nil
        }
    }
}
