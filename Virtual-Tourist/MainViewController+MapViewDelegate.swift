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
            let annotation = view.annotation! as? MKPointAnnotation
            self.annotationDetailView.firstLineSubtitle.text = annotation!.title!
            self.annotationDetailView.secondLineSubtitle.text = annotation!.subtitle!
            self.activeAnnotation = annotation
            self.presentAnnotationDetailView(annotation: activeAnnotation!)
        } else {
            self.activeAnnotation = nil
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
