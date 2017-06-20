//
//  AnnotationPoint+CoreDataClass.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/20/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(AnnotationPoint)
public class AnnotationPoint: NSManagedObject {
    
    convenience init(index: Int, annotation: MKPointAnnotation, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "AnnotationPoint", in: context) {
            self.init(entity: entity, insertInto: context)
            self.index = Int16(index)
            self.latitude = Double(annotation.coordinate.latitude)
            self.longitude = Double(annotation.coordinate.longitude)
            self.title = annotation.title
            self.subtitle = annotation.subtitle
        } else {
            fatalError("Unable to find the entity named AnnotationPoint")
        }
    }

}
