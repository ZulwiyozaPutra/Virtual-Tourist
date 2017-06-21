//
//  Point+CoreDataClass.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/20/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Point)
public class Point: NSManagedObject {
    
    convenience init(annotation: MKPointAnnotation, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Point", in: context) {
            self.init(entity: entity, insertInto: context)
            self.latitude = Double(annotation.coordinate.latitude)
            self.longitude = Double(annotation.coordinate.longitude)
            self.title = annotation.title
            self.subtitle = annotation.subtitle
        } else {
            fatalError("Unable to find the entity named Point")
        }
    }

}
