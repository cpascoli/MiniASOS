//
//  PageContentViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 07/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    // Injected Properties
    var imageDownloader:ImageDownloader!
    var url:String!
    var taskId:Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.imageView.image == nil {
            downloadImage(from:url)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let taskId = self.taskId {
            imageDownloader.cancel(taskId:taskId)
        }
    }
    
    func downloadImage(from url:String) {
    
        self.taskId = imageDownloader.fetchImage(for: url, onCompletion: { image, error in           
            self.taskId = nil
            if let image = image {
                self.imageView.image = image
            }
        })
    }

}
