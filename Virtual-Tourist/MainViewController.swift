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

class MainViewController: ViewController, NSFetchedResultsControllerDelegate {
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    var annotationDetailView = AnnotationDetailView()
    
    var editingModeDescriptionView = UIView()
    
    var editMode = false
    
    var annotationPoints: [AnnotationPoint]? = nil
    
    var activeAnnotation: MKPointAnnotation? = nil
    
    //Core Data
    func coreDataStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack
    }
    
    //Fetch Results
    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let stack = coreDataStack()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AnnotationPoint")
        fetchRequest.sortDescriptors = []
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    //Load Saved Pin
    func preloadSavedAnnotationPoint() -> [AnnotationPoint]? {
        do {
            var annotationPoints: [AnnotationPoint] = []
            let fetchedResultsController = self.fetchedResultsController()
            try fetchedResultsController.performFetch()
            
            let annotationPointsCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            
            print(annotationPointsCount)
            
            for index in 0..<annotationPointsCount {
                annotationPoints.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! AnnotationPoint)
            }
            
            return annotationPoints
            
        } catch {
            
            return nil
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Virtual Tourist"
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.annotationDetailView = annotationDetailViewInstanceFromNib()
        self.editingModeDescriptionView = editingModeDescriptionViewInstanceFromNib()
        longPressGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        mapView.delegate = self
        
        
        let preLoadAnnotationPoints = preloadSavedAnnotationPoint()
        if preLoadAnnotationPoints != nil {
            
            annotationPoints = preLoadAnnotationPoints
            var points = [MKPointAnnotation]()
            
            for annotationPoint in annotationPoints! {
                let point = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2DMake(annotationPoint.latitude, annotationPoint.longitude)
                point.coordinate = coordinate
                point.title = annotationPoint.title
                point.subtitle = annotationPoint.subtitle
                points.append(point)
            }
            
            print(points)
            
            self.executeOnMain {
                self.mapView.addAnnotations(points)
                self.mapView.reloadInputViews()
            }
        }
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
    
    func getLocation(annotation: MKPointAnnotation, completion: @escaping (_ placemark: CLPlacemark) -> Void) {
        
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
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
        var annotation = MKPointAnnotation()
        let point = CGPoint(x: point.x, y: point.y)
        let coordinate = mapView.convert(point, toCoordinateFrom: self.view)
        
        annotation = MKPointAnnotation()
        annotation.coordinate.latitude = coordinate.latitude
        annotation.coordinate.longitude = coordinate.longitude
        
        getLocation(annotation: annotation, completion: { (placemark: CLPlacemark) in
            let annotation = MKPointAnnotation()
            annotation.title = "\(String(describing: placemark.locality!)), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
            annotation.subtitle = placemark.country
            annotation.coordinate = placemark.location!.coordinate
            self.mapView.addAnnotation(annotation)
            
            let annotationPoint = AnnotationPoint(index: 0, annotation: annotation, context: self.coreDataStack().context)
            self.addToCoreData(of: annotation)
            self.annotationPoints?.append(annotationPoint)
            
            self.executeOnMain {
                self.activeAnnotation = annotation
                self.presentAnnotationDetailView(annotation: self.activeAnnotation!)
                self.mapView.reloadInputViews()
            }
        })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photosViewController = segue.destination as? PhotosViewController
        let annotation = self.activeAnnotation!
        photosViewController?.location = CLLocation(latitude: (annotation.coordinate.latitude), longitude: (annotation.coordinate.longitude))
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    //Add Core Data
    
    func addToCoreData(of point: MKPointAnnotation) {
        
        do {
            let annotationPoint = AnnotationPoint(index: 0, annotation: point, context: coreDataStack().context)
            try coreDataStack().saveContext()
            annotationPoints?.append(annotationPoint)
        } catch {
            print("Add Core Data Failed")
        }
    }
    
    //Delete Core Data
    
    func removeFromCoreData(of point: MKPointAnnotation) {
        
        for annotationPoint in annotationPoints! {
            
            if annotationPoint.latitude == point.coordinate.latitude && annotationPoint.longitude == point.coordinate.longitude {
                do {
                    coreDataStack().context.delete(annotationPoint)
                    try coreDataStack().saveContext()
                } catch {
                    
                    print("Remove Core Data Failed")
                }
                break
            }
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
