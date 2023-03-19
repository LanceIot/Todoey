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
    
    func fetchItems(with text: String = "", section: TodoeySection) {
        do {
            let request = Todoeyitem.fetchRequest()
            if text != "" {
                let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
                let sectionPredicate = NSPredicate(format: "section == %@", section)
                let isCompletedPredicate = NSPredicate(format: "isCompleted == %@", "False")
                
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, sectionPredicate, isCompletedPredicate])
                request.predicate = compoundPredicate
            } else {
                let sectionPredicate = NSPredicate(format: "section == %@", section)
                let isCompletedPredicate = NSPredicate(format: "isCompleted == %@", "False")

                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [sectionPredicate, isCompletedPredicate])
                request.predicate = compoundPredicate
                
            }
            
            let sortDescPriority = NSSortDescriptor(key: "priority", ascending: true)
            let sortDescName = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescPriority, sortDescName]
            
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func createItem(name: String, desc: String, priority: Int16, imageData: Data, section: TodoeySection) {
        let newItem = Todoeyitem(context: context)
        newItem.name = name
        newItem.desc = desc
        newItem.priority = priority
        newItem.createdAt = Date()
        newItem.image = imageData
        newItem.isCompleted = false
        section.addToItems(newItem)
        do {
            try context.save()
            fetchItems(section: section)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func completeItem(item: Todoeyitem) {
        do {
            item.isCompleted = true
            try context.save()
            fetchItems(section: item.section!)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func deleteItem(item: Todoeyitem, section: TodoeySection) {
        context.delete(item)
        do {
            try context.save()
            fetchItems(section: section)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func updateItem(item: Todoeyitem, newName: String, desc: String, imageData: Data, priority: Int16) {
        do {
            item.name = newName
            item.desc = desc
            item.priority = priority
            item.image = imageData
            try context.save()
            fetchItems(section: item.section!)
        } catch {
            print(error)
        }
    }
}
