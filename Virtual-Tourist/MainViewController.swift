//
//  MainViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: ViewController {
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: nil)
    var editMode = false
    

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Virtual Tourist"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        longPressGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        mapView.delegate = self
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editMode = editing
    }
    
    fileprivate func addAnnotationToMap(point: CGPoint) {
        let annotation = MKPointAnnotation()
        let coordinateToAdd = mapView.convert(point, toCoordinateFrom: mapView)
        annotation.coordinate = coordinateToAdd
        mapView.addAnnotation(annotation)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        } else {
            let reuseIdentifier = "pin"
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
            
            
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                pinAnnotationView!.canShowCallout = true
                pinAnnotationView!.animatesDrop = true
                pinAnnotationView!.isUserInteractionEnabled = true
                
                let button = UIButton(type: .detailDisclosure)
                button.tintColor = .blue
                pinAnnotationView!.rightCalloutAccessoryView = button
            } else {
                pinAnnotationView!.annotation = annotation
                pinAnnotationView!.isUserInteractionEnabled = true
            }
            
            return pinAnnotationView
        }
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("Loading Map")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("annotation is tapped")
        if !editMode {
            performSegue(withIdentifier: "ShowCollections", sender: view.annotation?.coordinate)
            mapView.deselectAnnotation(view.annotation, animated: false)
        } else {
            mapView.removeAnnotation(view.annotation!)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation else { return }
        
        if control == view.rightCalloutAccessoryView {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegue(withIdentifier: "ShowCollections", sender: annotation.coordinate)
        }
        
        
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gestureTouchPoint = gestureRecognizer.location(in: mapView)
        addAnnotationToMap(point: gestureTouchPoint)
        return true
    }
}
