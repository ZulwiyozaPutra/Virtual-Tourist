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
    
    var annotationDetailView = AnnotationDetailView()
    
    var editMode = false
    
    var annotations: [MKPointAnnotation]? = nil
    
    var annotation: MKPointAnnotation? = nil

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
    
    func instanceFromNib() -> AnnotationDetailView {
        let instance = UINib(nibName: "AnnotationDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnnotationDetailView
        
        let path = UIBezierPath(roundedRect:instance.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        
        instance.layer.mask = maskLayer
        instance.dismissButton.addTarget(self, action: #selector(dismissAnnotationDetailView), for: .touchUpInside)
        instance.showPhotosButton.addTarget(self, action: #selector(presentPhotosViewController), for: .touchUpInside)
        return instance
    }
    
    func presentPhotosViewController() {
        performSegue(withIdentifier: "Show Photos", sender: nil)
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func dismissAnnotationDetailView() {
        annotationDetailView.removeFromSuperview()
    }
    
    func getLocation(completion: @escaping (_ placemark: CLPlacemark) -> Void) {
        
        let geoCoder = CLGeocoder()
        
        self.state(state: .loading)
        
        let location = CLLocation(latitude: annotation!.coordinate.latitude, longitude: annotation!.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard error == nil else {
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: "\(error.debugDescription), Please Try Again")
                return
            }
            
            guard placemarks != nil else {
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: "Please Try Again")
                return
            }
            
            self.state(state: .normal)
            
            completion(placemarks![0])
            
        }
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
        
        if !editMode {
            annotationDetailView.frame = CGRect(x: 0, y: self.view.frame.height - 168, width: self.view.frame.width, height: self.view.frame.height)
            self.annotation = view.annotation! as? MKPointAnnotation
            
            getLocation(completion: { (placemark: CLPlacemark) in
                self.annotationDetailView.firstLineSubtitle.text = "\(String(describing: placemark.locality!)), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
                self.annotationDetailView.secondLineSubtitle.text = placemark.country
                self.view.addSubview(self.annotationDetailView)
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

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gestureTouchPoint = gestureRecognizer.location(in: mapView)
        addAnnotationToMap(point: gestureTouchPoint)
        return true
    }
}
