//
//  SectionManager.swift
//  Todoey
//
//  Created by Админ on 08.03.2023.
//

import Foundation
import UIKit

protocol SectionManagerDelegate {
    func didUpdateSections(with models: [TodoeySection])
    func didFailWith(with error: Error)
}

struct SectionManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: SectionManagerDelegate?
    
    static var shared = SectionManager()
    
    func fetchSections() {
        do {
            let request = TodoeySection.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func createSection(with name: String) {
        let newSection = TodoeySection(context: context)
        newSection.name = name
        do {
            try context.save()
            let request = TodoeySection.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            print("Following error appeared: ", error)
        }
    }
    
    func deleteSection(section: TodoeySection) {
        context.delete(section)
        do {
            try context.save()
            let request = TodoeySection.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            print(error)
        }
    }
    
    func updateSection(section: TodoeySection, newName: String) {
        section.name = newName
        do {
            try context.save()
            let request = TodoeySection.fetchRequest()
            
            let desc = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [desc]
            
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            print(error)
        }
    }
}

extension SectionManagerDelegate {
    
    func didFailWith(with error: Error) {
        print("Following error appeared: ", error)
    }
}



