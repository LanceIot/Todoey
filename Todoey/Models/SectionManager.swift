//
//  SectionManager.swift
//  Todoey
//
//  Created by Админ on 08.03.2023.
//

import Foundation
import UIKit
import CoreData

protocol SectionManagerDelegate {
    func didUpdateSections(with models: [TodoeyBDSection])
    func didFailWith(with error: Error)
}

struct SectionManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: SectionManagerDelegate?
    
    static var shared = SectionManager()
    
    func fetchSections() {
        do {
            let request = TodoeyBDSection.fetchRequest()
            let models = try context.fetch(request)
            delegate?.didUpdateSections(with: models)
        } catch {
            delegate?.didFailWith(with: error)
        }
    }
    
    func createSection(with name: String) {
        let newSection = TodoeyBDSection(context: context)
        newSection.name = name
        let colorInt = Constants.Colors.sections.randomElement()
        newSection.color = colorInt ?? 0xa3a3a3
        do {
            try context.save()
            fetchSections()
        } catch {
            print("Following error appeared: ", error)
        }
    }
    
    func deleteSection(section: TodoeyBDSection) {
        for item in section.items! {
            context.delete(item as! NSManagedObject)
        }
        context.delete(section)
        do {
            try context.save()
            fetchSections()
        } catch {
            print(error)
        }
    }
    
    func updateSection(section: TodoeyBDSection, newName: String) {
        section.name = newName
        do {
            try context.save()
            fetchSections()
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



