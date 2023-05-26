//
//  TodoeyBDItem+CoreDataProperties.swift
//  
//
//  Created by Админ on 15.04.2023.
//
//

import Foundation
import CoreData


extension TodoeyBDItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoeyBDItem> {
        return NSFetchRequest<TodoeyBDItem>(entityName: "TodoeyBDItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var priority: Int16
    @NSManaged public var section: TodoeyBDSection?

}
