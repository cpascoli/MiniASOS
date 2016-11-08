//
//  SplashScreenViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activityIndicatorView.stopAnimating()
    }
}
