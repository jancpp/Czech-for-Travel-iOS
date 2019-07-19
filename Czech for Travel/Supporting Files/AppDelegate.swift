//
//  AppDelegate.swift
//  Czech for Travel
//
//  Created by Jan Polzer on 5/28/19.
//  Copyright © 2019 Apps KC. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkData()
        connectMOCs()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Phrases")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - private
    
    private func checkData() {
        let moc = persistentContainer.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        if let categoryCount = try? moc.count(for: request), categoryCount > 0 {
            return
        }
        
        uploadJsonData()
    }
    
    private func uploadJsonData() {
        let moc = persistentContainer.viewContext
        
        guard
            let url = Bundle.main.url(forResource: "czechfortravel", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary,
            let jsonArray = jsonResult.value(forKey: "categories") as? NSArray
            else {return}
        for json in jsonArray {
            if let categoryData = json as? [String: AnyObject] {
                guard
                    let name = categoryData["name"] as? String,
                    let image = categoryData["image"] as? String
                    else {return}
                
                let category = Category(context: moc)
                
                if let index = categoryData["index"] {
                    category.index = index.int16Value
                }
                category.name = name
                category.imageFileName = image
                
                if let categoryPhrases = categoryData["phrases"] as? NSArray {
                    let categoryPhraseData = category.phrases?.mutableCopy() as! NSMutableSet
                    
                    for categoryPhrase in categoryPhrases {
                        if let phraseData = categoryPhrase as? [String: AnyObject] {
                            
                            let phrase = Phrase(context: moc)
                            if let czech = phraseData["czech"] as? String {
                                phrase.czech = czech
                            }
                            if let audio = phraseData["audio"] as? String {
                                phrase.audioFileName = audio
                            }
                            if let english = phraseData["english"] as? String {
                                phrase.english = english
                            }
                            if let czechDetail = phraseData["czech_detail"] as? String {
                                phrase.czechDetail = czechDetail
                            }
                            if let position = phraseData["position"] {
                                phrase.position = position.int16Value
                            }
                            categoryPhraseData.add(phrase)
                        }
                    }
                    category.addToPhrases(categoryPhraseData.copy() as! NSSet)
                }
            }
        }
        saveContext()
    }
    
    private func connectMOCs() {
        let moc = persistentContainer.viewContext
        let root = window?.rootViewController as? UISplitViewController
        let categoryNavigation = root?.viewControllers[0] as? UINavigationController
        let categoryVC = categoryNavigation?.topViewController as? HomeTableViewController
        categoryVC?.managedObjectContext = moc
    }
}



