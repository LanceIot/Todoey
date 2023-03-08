//
//  DataManager.swift
//  Todoey
//
//  Created by Админ on 07.03.2023.
//

import Foundation
import UIKit

protocol ItemManagerDelegate {
    func didUpdateItems(with models: [Todoeyitem])
    func didFailWith(with error: Error)
}

struct ItemManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: ItemManagerDelegate?
    
    static var shared = ItemManager()
    
    func fetchItems(with text: String = "", _ section: Int) {
        do {
            let request = Todoeyitem.fetchRequest()
            if text != "" {
                let predicate = NSPredicate(format: "name CONTAINS %@", text)
                request.predicate = predicate
            }
            
            let predicate = NSPredicate(format: "sect = %d", section)
            request.predicate = predicate
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func createItem(with name: String, _ section: Int) {
        let newItem = Todoeyitem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        newItem.sect = Int32(section)
        do {
            try context.save()
            let request = Todoeyitem.fetchRequest()
            
            let predicate = NSPredicate(format: "sect = %d", section)
            request.predicate = predicate
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            print("Following error appeared: ", error)
        }
    }
    
    func deleteItem(item: Todoeyitem, _ section: Int) {
        context.delete(item)
        do {
            try context.save()
            let request = Todoeyitem.fetchRequest()
            
            let predicate = NSPredicate(format: "sect = %d", section)
            request.predicate = predicate
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            print(error)
        }
    }
    
    func updateItem(item: Todoeyitem, newName: String, _ section: Int) {
        item.name = newName
        do {
            try context.save()
            let request = Todoeyitem.fetchRequest()
            
            let predicate = NSPredicate(format: "sect = %d", section)
            request.predicate = predicate
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            print(error)
        }
    }
}
