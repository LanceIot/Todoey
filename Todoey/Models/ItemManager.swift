import Foundation
import UIKit

protocol ItemManagerDelegate {
    func didUpdateItems(with models: [TodoeyBDItem])
    func didFailWith(with error: Error)
}

struct ItemManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: ItemManagerDelegate?
    
    static var shared = ItemManager()
    
    func fetchItems(with text: String = "", section: TodoeyBDSection? = nil) {
        do {
            let request = TodoeyBDItem.fetchRequest()
            var predicateList: [NSPredicate] = []
            if text != "" {
                let namePredicate = NSPredicate(format: "name CONTAINS[c] %@", text)
                predicateList.append(namePredicate)
                if let section {
                    let sectionPredicate = NSPredicate(format: "section == %@", section)
                    predicateList.append(sectionPredicate)
                } else {
                    let isCompletedPredicate = NSPredicate(format: "isCompleted == %d", false)
                    predicateList.append(isCompletedPredicate)
                }
                
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateList)
                request.predicate = compoundPredicate
            } else {
                if let section {
                    let sectionPredicate = NSPredicate(format: "section == %@", section)
                    predicateList.append(sectionPredicate)
                } else {
                    let isCompletedPredicate = NSPredicate(format: "isCompleted == %d", false)
                    predicateList.append(isCompletedPredicate)
                }
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateList)
                request.predicate = compoundPredicate
                
            }
            
            let sortDescPriority = NSSortDescriptor(key: "priority", ascending: true)
            let sortDescName = NSSortDescriptor(key: "name", ascending: true)
            let sortDescCompletion = NSSortDescriptor(key: "isCompleted", ascending: true)
            request.sortDescriptors = [sortDescCompletion, sortDescPriority, sortDescName]
            
            let models = try context.fetch(request)
            delegate?.didUpdateItems(with: models)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func createItem(name: String, desc: String, priority: Int16, section: TodoeyBDSection) {
        let newItem = TodoeyBDItem(context: context)
        newItem.name = name
        newItem.desc = desc
        newItem.priority = priority
        newItem.createdAt = Date()
        newItem.isCompleted = false
        section.addToItems(newItem)
        do {
            try context.save()
            fetchItems(section: section)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func completeItem(item: TodoeyBDItem, selectedCell: Int) {
        do {
            item.isCompleted = true
            try context.save()
            switch selectedCell {
            case 0:
                fetchItems()
            default:
                fetchItems(section: item.section)
            }
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func deleteItem(item: TodoeyBDItem, section: TodoeyBDSection) {
        context.delete(item)
        do {
            try context.save()
            fetchItems(section: section)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func updateItem(item: TodoeyBDItem, newName: String, desc: String, priority: Int16) {
        do {
            item.name = newName
            item.desc = desc
            item.priority = priority
            try context.save()
            fetchItems(section: item.section!)
        } catch {
            print(error)
        }
    }
}
