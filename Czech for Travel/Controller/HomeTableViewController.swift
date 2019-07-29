//
//  HomeTableViewController.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 5/29/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    private var categoryList = [Category]()
    private var dataService: DataService?
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            if let moc = managedObjectContext {
                dataService = DataService(moc: moc)
            }
        }
    }
    
    static func  getHomeCellHeight() -> CGFloat {
        return 80
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        setupViewController()
        
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        selectDefaultRowAndShowDetail()
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }
    
    func setupViewController() {
        view.backgroundColor = .darkGray
        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        navigationItem.title = "Czech for Travel"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func selectDefaultRowAndShowDetail() {
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        
        tableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition:UITableView.ScrollPosition.none)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.performSegue(withIdentifier: "Show Phrases", sender: indexPath)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as? HomeTableViewCell else {fatalError("Home cell didn't load")}
        
        cell.configureCell(category: categoryList[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeTableViewController.getHomeCellHeight()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {return}
        
        //  With navigation bar in Detail view version
        if identifier == "Show Phrases" {
            
            let navigationController: UINavigationController! = segue.destination as? UINavigationController
            
            let categoryVC: CategoryViewController! = navigationController.topViewController as? CategoryViewController
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let selected = categoryList[selectedIndexPath.row]
                categoryVC.selectedCategory = selected
            }
        }
    }
    
    // MARK: - Private
    
    private func loadCategories() {
        if let unsortedCategories = dataService?.getCategories() {
            
            
            
            for eachCategory in unsortedCategories {
                categoryList.append(eachCategory )
            }
            
            categoryList = categoryList.sorted { (category1, category2) -> Bool in
                return category1.index < category2.index
            }
        }
        
        tableView.reloadData()
        
    }
}

