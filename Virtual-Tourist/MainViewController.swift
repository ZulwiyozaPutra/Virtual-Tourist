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
    
    var location: CLLocation? = nil
    
    

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
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.annotationDetailView.frame.origin.y += 168
            self.executeOnMain(withDelay: 0.2, {
                self.annotationDetailView.removeFromSuperview()
            })
        }, completion: nil)
        
        self.location = nil
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
