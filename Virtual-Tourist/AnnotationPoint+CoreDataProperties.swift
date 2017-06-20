//
//  AnnotationPoint+CoreDataProperties.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/20/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension AnnotationPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnnotationPoint> {
        return NSFetchRequest<AnnotationPoint>(entityName: "AnnotationPoint")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var index: Int16
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension AnnotationPoint {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
