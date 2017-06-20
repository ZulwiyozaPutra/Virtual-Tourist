//
//  MainViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainViewController: ViewController {
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    var annotationDetailView = AnnotationDetailView()
    
    var editingModeDescriptionView = UIView()
    
    var editMode = false
    
    var pins: [NSManagedObject]? = nil
    
    var annotationPoints: [MKPointAnnotation]? = nil
    
    var pin: NSManagedObject? = nil
    
    var annotation: MKPointAnnotation? = nil
    
    var location: CLLocation? = nil
    

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Virtual Tourist"
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.annotationDetailView = annotationDetailViewInstanceFromNib()
        self.editingModeDescriptionView = editingModeDescriptionViewInstanceFromNib()
        
        
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.addTarget(self, action: #selector(saveAnnotation))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        mapView.delegate = self
        
        if pins == nil {
            fetchAnnotationPoints {
                self.annotationPoints = self.convertPinManagedObjectsToPointAnnotations(self.pins!)
                
                self.executeOnMain {
                    self.mapView.addAnnotations(self.annotationPoints!)
                    self.mapView.reloadInputViews()
                }
            }
            self.mapView.addAnnotations(annotationPoints!)
        }
    }
    
    func saveAnnotation() {
        let gestureTouchLocation = longPressGestureRecognizer.location(in: mapView)
        let point = CGPoint(x: gestureTouchLocation.x, y: gestureTouchLocation.y)
        let coordinate = mapView.convert(point, toCoordinateFrom: self.view)
        
        self.annotation = MKPointAnnotation()
        self.annotation!.coordinate.latitude = coordinate.latitude
        self.annotation!.coordinate.longitude = coordinate.longitude
        
        getLocation(completion: { (placemark: CLPlacemark) in
            let annotation = MKPointAnnotation()
            annotation.title = "\(String(describing: placemark.locality!)), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
            annotation.subtitle = placemark.country
            annotation.coordinate = placemark.location!.coordinate
            self.saveAnnotationPoint(annotation)
        })
    }
    
    func annotationDetailViewInstanceFromNib() -> AnnotationDetailView {
        let instance = UINib(nibName: "AnnotationDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnnotationDetailView
        
        let path = UIBezierPath(roundedRect:instance.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        instance.layer.mask = maskLayer
        instance.dismissButton.addTarget(self, action: #selector(dismissAnnotationDetailView), for: .touchUpInside)
        instance.showPhotosButton.addTarget(self, action: #selector(presentPhotosViewController), for: .touchUpInside)
        return instance
    }
    
    func editingModeDescriptionViewInstanceFromNib() -> UIView {
        let instance = UINib(nibName: "EditingModeDescriptionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return instance
    }
    
    func presentPhotosViewController() {
        performSegue(withIdentifier: "Show Photos", sender: nil)
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func getLocation(completion: @escaping (_ placemark: CLPlacemark) -> Void) {
        
        let geoCoder = CLGeocoder()
        
        self.state(state: .loading)
        
        let location = CLLocation(latitude: annotation!.coordinate.latitude, longitude: annotation!.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard error == nil else {
                self.presentErrorAlertController("Couldn't Find Location", alertMessage: "\(error.debugDescription), Please Try Again")
                self.state(state: .normal)
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
        if editing {
            presentEditModeDescriptionView()
            if self.annotationDetailView.frame.origin.y != self.view.frame.height {
                dismissAnnotationDetailView()
            }
        } else {
            dismissEditModeDescriptionView()
        }
        
    }
    
    fileprivate func addAnnotationToMap(point: CGPoint) {
        let annotation = MKPointAnnotation()
        let coordinateToAdd = mapView.convert(point, toCoordinateFrom: mapView)
        annotation.coordinate = coordinateToAdd
        mapView.addAnnotation(annotation)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photosViewController = segue.destination as? PhotosViewController
        photosViewController?.location = self.location
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gestureTouchPoint = gestureRecognizer.location(in: mapView)
        addAnnotationToMap(point: gestureTouchPoint)
        return true
    }
}
