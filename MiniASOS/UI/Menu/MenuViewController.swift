//
//  MenuViewController.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func categorySelected(category:ProductCategory)
}

class MenuViewController: UIViewController {

    var delegate: MenuDelegate?
    var productCategories = [ProductCategotyType:[ProductCategory]]()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sectionChanged(_ sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        showDefaultCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.flashScrollIndicators()
    }
    
    func currentCategories() -> [ProductCategory]? {
    
        var categories:[ProductCategory]?
        
        switch segmentedControl.selectedSegmentIndex {
            
            case ProductCategotyType.woman.rawValue:
                categories = productCategories[.woman]
            case ProductCategotyType.man.rawValue:
                categories = productCategories[.man]
            default:
                break
        }
 
        return categories
    }
    
    // Informs the delagate to display the default product category (women)
    func showDefaultCategory() {
    
        if let delegate = self.delegate,
           let categories = productCategories[.woman] {
            if let defaultCategory =  categories.first {
                delegate.categorySelected(category:defaultCategory)
            }
        }
    }
}


extension MenuViewController : UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let items = self.currentCategories(), let delegate = self.delegate {
            
            let category = items[indexPath.row]
            print("tapped ", category.name)
            delegate.categorySelected(category:category)
        }
    }
}


extension MenuViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
         if let items = self.currentCategories() {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
         }
         return cell;
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = currentCategories() else {
            return 0
        }
        return categories.count
    }

}
