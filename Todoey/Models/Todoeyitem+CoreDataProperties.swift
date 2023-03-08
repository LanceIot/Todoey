//
//  Todoeyitem+CoreDataProperties.swift
//  
//
//  Created by Админ on 08.03.2023.
//
//

import Foundation
import CoreData


extension Todoeyitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todoeyitem> {
        return NSFetchRequest<Todoeyitem>(entityName: "Todoeyitem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var sect: Int32
    @NSManaged public var section: TodoeySection?

}
