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
    
    var annotationDetailView = UIView()
    
    var editMode = false
    
    var annotations: [MKPointAnnotation]? = nil

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Virtual Tourist"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.annotationDetailView = instanceFromNib()
        
        longPressGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        mapView.delegate = self
    }
    
    func instanceFromNib() -> UIView {
        let instance = UINib(nibName: "AnnotationDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnnotationDetailView
        
        let path = UIBezierPath(roundedRect:instance.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        
        instance.layer.mask = maskLayer
        instance.dismissButton.addTarget(self, action: #selector(dismissAnnotationDetailView), for: .touchUpInside)
        return instance
    }
    
    func dismissAnnotationDetailView() {
        annotationDetailView.removeFromSuperview()
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
        print("annotation is tapped")
        if !editMode {
            annotationDetailView.frame = CGRect(x: 0, y: self.view.frame.height - 178, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview(annotationDetailView)
        } else {
            mapView.removeAnnotation(view.annotation!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        
        mapView.deselectAnnotation(annotation, animated: true)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gestureTouchPoint = gestureRecognizer.location(in: mapView)
        addAnnotationToMap(point: gestureTouchPoint)
        return true
    }
}
