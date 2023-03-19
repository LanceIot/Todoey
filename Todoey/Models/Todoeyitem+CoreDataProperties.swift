//
//  Todoeyitem+CoreDataProperties.swift
//  
//
//  Created by Админ on 19.03.2023.
//
//

import Foundation
import CoreData


extension Todoeyitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todoeyitem> {
        return NSFetchRequest<Todoeyitem>(entityName: "Todoeyitem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var desc: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var image: Data?
    @NSManaged public var section: TodoeySection?

}
