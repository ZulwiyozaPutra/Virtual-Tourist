//
//  Photo+CoreDataProperties.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/20/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var index: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var point: Point?

}
