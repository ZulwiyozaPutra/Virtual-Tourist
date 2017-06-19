//
//  MainViewController+MapViewDelegate.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import MapKit
import UIKit

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
            annotationDetailView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            self.annotation = view.annotation! as? MKPointAnnotation
            
            getLocation(completion: { (placemark: CLPlacemark) in
                self.annotationDetailView.firstLineSubtitle.text = "\(String(describing: placemark.locality!)), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
                self.annotationDetailView.secondLineSubtitle.text = placemark.country
                
                self.location = placemark.location
                self.view.addSubview(self.annotationDetailView)
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    self.annotationDetailView.frame.origin.y -= 168
                }, completion: nil)
            })
            
        } else {
            mapView.removeAnnotation(view.annotation!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        
        mapView.deselectAnnotation(annotation, animated: true)
        self.annotation = nil
    }
}
