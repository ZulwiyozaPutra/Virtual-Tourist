//
//  PhotosViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosViewController: ViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    var photos: [Photo] = []
    
    let noDataLabel: UILabel = UILabel()
    
    var refresherView = RefresherView()
    
    var activePoint: Point!
    
    var activeMapPointAnnotation: MKPointAnnotation!
    
    var mapPointAnnotation: MKPointAnnotation!
    
    var selectedIndexes = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Back"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.setupPointAnnotation()
        
        self.refresherView = refresherViewInstanceFromNib()

        let subregion = activeMapPointAnnotation.title
        let region = activeMapPointAnnotation.subtitle
        
        self.navigationItem.setTitleView(with: region!, subtitle: subregion!)
        
        
        collectionView.dataSource = self
        
        //Flow Layout
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        collectionFlowLayout.minimumInteritemSpacing = 3.0
        collectionFlowLayout.minimumLineSpacing = 3.0
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Photo's Cell")
        
        
        setNoDataLabel()
        //Fetch Photos
        let savedPhotos = preloadSavedPhotos()
        if savedPhotos != nil && savedPhotos?.count != 0 {
            photos = savedPhotos!
            noDataLabel.removeFromSuperview()
            showSavedPhotos()
        } else {
            showNewPhotos()
        }
    }

    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParentViewController){
            try? coreDataStack().saveContext()
            let parent = navigationController?.parent as? MainViewController
            parent?.activeMapPointAnnotation = activeMapPointAnnotation
            parent?.presentPointDetailView()
        }
    }
    
    func setNoDataLabel() {
        noDataLabel.text = "No Photos Yet"
        noDataLabel.frame.size.width = self.view.frame.width
        noDataLabel.frame.size.height = 30
        noDataLabel.textAlignment = .center
        noDataLabel.center.x = self.view.frame.width/2
        noDataLabel.center.y = self.view.frame.height/2 - (self.navigationController?.navigationBar.frame.height)!
        noDataLabel.textColor = UIColor.gray
        self.view.addSubview(noDataLabel)
    }
    
    func deleteSelectedPhotos() {
        removeSelectedPhotosAtCoreData {
            self.executeOnMain {
                self.isEditing = false
                for cell in self.collectionView.visibleCells {
                    cell.alpha = 1.0
                }
                self.collectionView.allowsMultipleSelection = false
                self.dismissRefresherView()
                self.collectionView.reloadData()
            }
        }
    }
    
    //Add Annotation
    func setupPointAnnotation() {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: activePoint.latitude, longitude: activePoint.longitude)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    
    func refresherViewInstanceFromNib() -> RefresherView {
        let instance = UINib(nibName: "RefresherView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RefresherView
        instance.deleteButton.addTarget(self, action: #selector(deleteSelectedPhotos), for: .touchUpInside)
        instance.refresherButton.addTarget(self, action: #selector(showNewPhotos), for: .touchUpInside)
        return instance
    }
    
    func showSavedPhotos() {
        executeOnMain {
            self.collectionView.reloadData()
        }
    }
    
    func showNewPhotos() {
        
        guard isConnectedToNetwork() == true else {
            presentErrorAlertController("Error", alertMessage: "Plese connect to the internet and try again")
            return
        }
        
        removeFromCoreData(photos: photos)
        photos.removeAll()
        setNoDataLabel()
        collectionView.reloadData()
        let location = CLLocation(latitude: (activePoint?.latitude)!, longitude: (activePoint?.longitude)!)
        
        FlickrClient.getFlickrImages(location: location) { (error: Error?, flickrImages: [FlickrImage]?) in
            
            guard error == nil else {
                fatalError(error.debugDescription)
            }
            
            self.executeOnMain {
                if flickrImages?.count != 0 {
                    self.addToCoreData(of: flickrImages!, at: self.activePoint)
                    self.photos = self.preloadSavedPhotos()!
                    self.noDataLabel.removeFromSuperview()
                    self.showSavedPhotos()
                } else {
                    self.showSavedPhotos()
                }
            }
        }
    }
    
    //Load Saved Pin
    func preloadSavedPhotos() -> [Photo]? {
        
        do {
            var photos: [Photo] = []
            let fetchedResultsController = self.fetchedResultsController()
            try fetchedResultsController.performFetch()
            
            let photosCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<photosCount {
                photos.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Photo)
            }
            return photos.sorted(by: {$0.index < $1.index})
            
        } catch {
            return nil
        }
    }
    
    //Fetch Results
    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let stack = coreDataStack()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "point = %@", argumentArray: [activePoint!])
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func addToCoreData(of objects: [FlickrImage], at entity: Point?) {

        for index in 0..<objects.count {
            let photo = Photo(index: index, imageURL: objects[index].imageURL(), imageData: nil, context: coreDataStack().context)
            photo.point = entity!
            photos.append(photo)

        }
    }
    
    func removeFromCoreData(photos: [Photo]) {
        for photo in photos {
            coreDataStack().context.delete(photo)
        }
    }
    
    //Remove Photos
    
    func removeSelectedPhotosAtCoreData(completion: @escaping () -> Void) {
        
        print(photos.count)
        
        for index in 0..<photos.count {
            
            if getIndexesFromSelectedIndexPath().contains(index) {
                let indexPath = IndexPath(row: index, section: 0)
                collectionView.deselectItem(at: indexPath, animated: true)
                print(photos.count)
                photos.remove(at: index)
                coreDataStack().context.delete(photos[index])
            }
        }
        completion()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            collectionView?.allowsMultipleSelection = true
            presentRefresherView()
        } else {
            collectionView?.allowsMultipleSelection = false
            dismissRefresherView()
        }
    }

}

extension UINavigationItem {
    func setTitleView(with title: String, subtitle: String) {
        let titleView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: titleView.frame.width, height: 18))
        titleLabel.center.x = titleView.frame.width/2
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        
        let subTitleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 18, width: titleView.frame.width, height: 12))
        subTitleLabel.center.x = titleView.frame.width/2
        subTitleLabel.backgroundColor = UIColor.clear
        subTitleLabel.textColor = UIColor.gray
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
        subTitleLabel.text = subtitle
        subTitleLabel.textAlignment = .center
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subTitleLabel)
        
        self.titleView = titleView
    }
}
