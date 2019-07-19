//
//  CategoryTableViewController.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 5/29/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var czechLabel: UILabel!
    @IBOutlet weak var czechDetailLabel: UILabel!
    @IBOutlet weak var phraseTableView: UITableView!
    
    var selectedPhraseIndex: Int = 0
    var selectedCategory: Category? {
        didSet {
            loadPhrases()
            setLabels(selectedIndex: selectedPhraseIndex)
        }
    }

    var phraseList = [Phrase]()
    private var dataService: DataService?
    
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            if let moc = managedObjectContext {
                dataService = DataService(moc: moc)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phraseTableView.dataSource = self
        phraseTableView.delegate = self
        phraseTableView.backgroundColor = UIColor.darkGray
        
        
        if selectedCategory != nil {
            // set lables when category VC first opens
            englishLabel.text = phraseList[selectedPhraseIndex].english
            czechLabel.text = phraseList[selectedPhraseIndex].czech
            czechDetailLabel.text = phraseList[selectedPhraseIndex].czechDetail
        }
        
        self.title = selectedCategory?.name
        view.backgroundColor = .darkGray
        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        self.navigationController!.navigationBar.barTintColor = UIColor.darkGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = NSIndexPath(row: 0, section: 0)
        
        //        phraseTableView.dataSource = self
        phraseTableView.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition:.none)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return phraseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "phraseCell", for: indexPath) as? CategoryTableViewCell else {fatalError("Category cell didn't load")}
        
        cell.configureCell(phrase: phraseList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setLabels(selectedIndex: indexPath.row)
    }
    
    // MARK: - private
    
    private func loadPhrases() {
        guard
            let selected = selectedCategory
            else {
                print("Category was not selected")
                return
        }
        if let phrases = selected.phrases {
            
            for eachPhrase in phrases {
                phraseList.append(eachPhrase as! Phrase)
            }
            
            phraseList = phraseList.sorted { (phrase1, phrase2) -> Bool in
                return phrase1.position < phrase2.position
            }
        }
    }
    
    private func setLabels(selectedIndex: Int?) {
        guard
            let englishLabel = englishLabel,
            let czechLabel = czechLabel,
            let czechDetailLabel = czechDetailLabel
            else { return }
        englishLabel.text = phraseList[selectedIndex ?? 0].english
        czechLabel.text = phraseList[selectedIndex ?? 0].czech
        czechDetailLabel.text = phraseList[selectedIndex ?? 0].czechDetail
    }
    
}
