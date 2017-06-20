//
//  Photo+CoreDataClass.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/20/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    convenience init(index: Int, imageURL: String, imageData: NSData?, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: entity, insertInto: context)
            self.index = Int16(index)
            self.imageURL = imageURL
            self.imageData = imageData ?? nil
        } else {
            fatalError("Unable to find the entity named AnnotationPoint")
        }
    }
}
