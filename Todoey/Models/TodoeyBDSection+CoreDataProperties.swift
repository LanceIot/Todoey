//
//  TodoeyBDSection+CoreDataProperties.swift
//  
//
//  Created by Админ on 15.04.2023.
//
//

import Foundation
import CoreData


extension TodoeyBDSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoeyBDSection> {
        return NSFetchRequest<TodoeyBDSection>(entityName: "TodoeyBDSection")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: Int32
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension TodoeyBDSection {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: TodoeyBDItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: TodoeyBDItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
