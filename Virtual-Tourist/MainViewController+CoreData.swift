//
//  MainViewController+CoreData.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import CoreData
import MapKit

//extension MainViewController {
//    func saveAnnotationPoint(_ annotationPoint: MKPointAnnotation) {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        let entity = NSEntityDescription.entity(forEntityName: "AnnotationPoint", in: managedContext)!
//        
//        let annotationPointObject = NSManagedObject(entity: entity, insertInto: managedContext)
//        
//        annotationPointObject.setValue(annotationPoint.coordinate.latitude, forKeyPath: "latitude")
//        annotationPointObject.setValue(annotationPoint.coordinate.longitude, forKeyPath: "longitude")
//        annotationPointObject.setValue(annotationPoint.title, forKeyPath: "title")
//        annotationPointObject.setValue(annotationPoint.subtitle, forKeyPath: "subtitle")
//        
//        do {
//            try managedContext.save()
//            annotationPoints!.append(annotationPoint)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//    
//    func fetchAnnotationPoints(_ completion: @escaping () -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AnnotationPoint")
//        
//        do {
//            pins = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
//            completion()
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//            completion()
//        }
//    }
//    
//    func deleteAnnotationPoint(annotationPoint: MKPointAnnotation, _ completion: @escaping () -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        let entity = NSEntityDescription.entity(forEntityName: "AnnotationPoint", in: managedContext)!
//        
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AnnotationPoint")
//        
//        let annotationPointObject = NSManagedObject(entity: entity, insertInto: managedContext)
//        
//        annotationPointObject.setValue(annotationPoint.coordinate.latitude, forKeyPath: "latitude")
//        annotationPointObject.setValue(annotationPoint.coordinate.longitude, forKeyPath: "longitude")
//        annotationPointObject.setValue(annotationPoint.title, forKeyPath: "title")
//        annotationPointObject.setValue(annotationPoint.subtitle, forKeyPath: "subtitle")
//        
//        do {
//            let objects = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as? [NSManagedObject]
//            for object in objects! {
//                if object == annotationPointObject {
//                    print(try managedContext.count(for: fetchRequest))
//                    managedContext.delete(annotationPointObject)
//                    print(try managedContext.count(for: fetchRequest))
//                    try managedContext.save()
//                    print(try managedContext.count(for: fetchRequest))
//                    appDelegate.saveContext()
//                    completion()
//                }
//            }
//            
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//            completion()
//        }
//    }
//    
//    @discardableResult func convertPinManagedObjectsToPointAnnotations(_ pins: [NSManagedObject]) -> [MKPointAnnotation] {
//        var annotationPoints = [MKPointAnnotation]()
//        for pin in pins {
//            let latitude = pin.value(forKey: "latitude") as! Double
//            let longitude = pin.value(forKey: "longitude") as! Double
//            let title = pin.value(forKey: "title") as! String
//            let subtitle = pin.value(forKey: "subtitle") as! String
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            annotation.title = title
//            annotation.subtitle = subtitle
//            annotationPoints.append(annotation)
//        }
//        return annotationPoints
//    }
//}
