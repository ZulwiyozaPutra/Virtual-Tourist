//
//  MainViewController+MapViewDelegate.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import MapKit
import UIKit
import CoreData

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        
        if pinAnnotationView == nil {
            pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinAnnotationView!.animatesDrop = true
        } else {
            pinAnnotationView!.annotation = annotation
            pinAnnotationView!.animatesDrop = true
        }
        return pinAnnotationView
        
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("Loading Map")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if !editMode {
            let pointAnnotation = view.annotation! as? MKPointAnnotation
            for annotationPoint in annotationPoints! {
                if pointAnnotation?.coordinate.latitude == annotationPoint.latitude && pointAnnotation?.coordinate.longitude == annotationPoint.longitude {
                    
                    self.activeAnnotationPoint = annotationPoint
                    print(self.activeAnnotationPoint)
                }
            }

            self.presentAnnotationPointDetailView()
        } else {
            self.activeAnnotationPoint = nil
            let annotation = view.annotation! as? MKPointAnnotation
            removeFromCoreData(of: annotation!)
            mapView.removeAnnotation(annotation!)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        mapView.deselectAnnotation(annotation, animated: true)
    }
}
