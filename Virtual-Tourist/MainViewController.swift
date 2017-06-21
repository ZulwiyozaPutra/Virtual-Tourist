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
    
    var points: [Point]? = nil
    
    var activeMapPointAnnotation: MKPointAnnotation? = nil
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        print("unwind!")
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
        
        let savedPoints = preloadSavedPoints()
        
        if savedPoints != nil {
            
            points = savedPoints

            for point in points! {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                annotation.coordinate = coordinate
                annotation.title = point.title
                annotation.subtitle = point.subtitle
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    //Fetch Results
    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let stack = coreDataStack()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Point")
        fetchRequest.sortDescriptors = []
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    //Load Saved Pin
    func preloadSavedPoints() -> [Point]? {
        do {
            var points: [Point] = []
            
            let fetchedResultsController = self.fetchedResultsController()
            try fetchedResultsController.performFetch()
            let countPoints = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<countPoints {
                points.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Point)
            }
            return points
            
        } catch {
            return nil
        }
    }
    
    func annotationDetailViewInstanceFromNib() -> AnnotationDetailView {
        let instance = UINib(nibName: "AnnotationDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnnotationDetailView
        instance.dismissButton.addTarget(self, action: #selector(dismissAnnotationDetailView), for: .touchUpInside)
        instance.showPhotosButton.addTarget(self, action: #selector(presentPhotosViewController), for: .touchUpInside)
        instance.removeLocationButton.addTarget(self, action: #selector(removeMapPointAnnotation
            ), for: .touchUpInside)
        return instance
    }
    
    func removeMapPointAnnotation() {
        removeFromCoreData(of: activeMapPointAnnotation!)
        mapView.removeAnnotation(activeMapPointAnnotation!)
        self.activeMapPointAnnotation = nil
        dismissAnnotationDetailView()
    }
    func editingModeDescriptionViewInstanceFromNib() -> UIView {
        let instance = UINib(nibName: "EditingModeDescriptionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return instance
    }
    
    func getLocation(location: CLLocation, completion: @escaping (_ placemark: CLPlacemark) -> Void) {
        let geoCoder = CLGeocoder()
        
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
    
    
    //Add Core Data
    
    func addToCoreData(of object: MKPointAnnotation) {
        do {
            let point = Point(annotation: object, context: coreDataStack().context)
            points?.append(point)
            try coreDataStack().saveContext()
        } catch {
            print("Add Core Data Failed")
        }
    }
    
    
    
    //Delete Core Data
    
    func removeFromCoreData(of point: MKPointAnnotation) {
        for index in 0..<points!.count {
            if points![index].latitude == point.coordinate.latitude && points![index].longitude == point.coordinate.longitude {
                do {
                    coreDataStack().context.delete(points![index])
                    points?.remove(at: index)
                    try coreDataStack().saveContext()
                } catch {
                    print("Remove Core Data Failed")
                }
                break
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let photosViewController = segue.destination as? PhotosViewController
        var pointToPresent = Point()
        
        for point in points! {
            let isLatitudeMatch = activeMapPointAnnotation!.coordinate.latitude == point.latitude
            let isLongitudeMatch = activeMapPointAnnotation!.coordinate.longitude == point.longitude
            
            if isLatitudeMatch && isLongitudeMatch {
                pointToPresent = point
                break
            }
        }
        
        photosViewController?.activePoint = pointToPresent
        photosViewController?.activeMapPointAnnotation = activeMapPointAnnotation
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard isConnectedToNetwork() == true else {
            presentErrorAlertController("Error", alertMessage: "Plese connect to the internet and try again")
            return false
        }
        
        let gestureTouchPoint = gestureRecognizer.location(in: mapView)
        let point = CGPoint(x: gestureTouchPoint.x, y: gestureTouchPoint.y)
        let coordinate = mapView.convert(point, toCoordinateFrom: self.view)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        getLocation(location: location, completion: { (placemark: CLPlacemark) in
            
            let mapPointAnnotation = MKPointAnnotation()
            let city = placemark.subAdministrativeArea ?? placemark.locality ?? "Unknown City"
            let state = placemark.administrativeArea ?? "Unknown State"
            let postalCode = placemark.postalCode ?? "Unknown Postal Code"
            let country = placemark.country ?? placemark.ocean ?? "Unknown Region"
            mapPointAnnotation.title = "\(city), \(state) \(postalCode)"
            mapPointAnnotation.subtitle = country
            mapPointAnnotation.coordinate = placemark.location!.coordinate
            self.addToCoreData(of: mapPointAnnotation)
            
            for point in self.points! {
                
                let isLatitudeMatch = point.latitude == mapPointAnnotation.coordinate.latitude
                let isLongitudeMatch = point.longitude == mapPointAnnotation.coordinate.longitude
                
                if isLatitudeMatch && isLongitudeMatch  {
                    self.activeMapPointAnnotation = mapPointAnnotation
                    print("point is found, the point is \(point)")
                }
            }
            
            self.executeOnMain {
                self.mapView.addAnnotation(mapPointAnnotation)
                self.presentPointDetailView()
            }
        })
        return true
    }
}
