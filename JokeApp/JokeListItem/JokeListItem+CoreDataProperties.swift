//
//  JokeListItem+CoreDataProperties.swift
//  JokeApp
//
//  Created by eleazar.martinez on 11/28/22.
//
//

import Foundation
import CoreData


extension JokeListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JokeListItem> {
        return NSFetchRequest<JokeListItem>(entityName: "JokeListItem")
    }

    @NSManaged public var setup: String?
    @NSManaged public var punchline: String?

}

extension JokeListItem : Identifiable {

}
