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

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    var photos: [Photo] = []
    
    var activePoint: Point!
    var activeMapPointAnnotation: MKPointAnnotation!
    var pointAnnotation: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Back"
        
        collectionView.dataSource = self
        
        //Flow Layout
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        collectionFlowLayout.minimumInteritemSpacing = 3.0
        collectionFlowLayout.minimumLineSpacing = 3.0
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Photo's Cell")
        
        //Fetch Photos
        let savedPhotos = preloadSavedPhotos()
        
        if savedPhotos != nil && savedPhotos?.count != 0 {
            photos = savedPhotos!
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
    func showSavedPhotos() {
        executeOnMain {
            self.collectionView.reloadData()
        }
    }
    
    func showNewPhotos() {
        
        removeFromCoreData(photos: photos)
        photos.removeAll()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation
     
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
