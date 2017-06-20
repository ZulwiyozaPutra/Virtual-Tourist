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
    
    var activeAnnotationPoint: AnnotationPoint!
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
    
    func showSavedPhotos() {
        executeOnMain {
            self.collectionView.reloadData()
        }
    }
    
    func showNewPhotos() {
        
        removeFromCoreData(photos: photos)
        photos.removeAll()
        collectionView.reloadData()
        
        let location = CLLocation(latitude: (activeAnnotationPoint?.latitude)!, longitude: (activeAnnotationPoint?.longitude)!)
        
        FlickrClient.getFlickrImages(location: location) { (error: Error?, flickrImages: [FlickrImage]?) in
            guard error == nil else {
                fatalError(error.debugDescription)
            }
            
            self.executeOnMain {
                self.addToCoreData(of: flickrImages!, at: self.activeAnnotationPoint)t
                self.photos = self.preloadSavedPhotos()!
                self.showSavedPhotos()
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
            
            print(photosCount)
            
            for index in 0..<photosCount {
                photos.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) as! Photo)
            }
            
            return photos
            
        } catch {
            
            return nil
        }
    }
    
    //Fetch Results
    func fetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let stack = coreDataStack()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSPredicate(format: "annotationPoint = %@", argumentArray: [activeAnnotationPoint!])
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func addToCoreData(of objects: [FlickrImage], at entity: AnnotationPoint?) {
        
        let amountOfObjects = objects.count
        print(amountOfObjects)
        for i in 0..<amountOfObjects {
            do {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let stack = delegate.stack
                let photo = Photo(index: i, imageURL: objects[i].imageURL(), imageData: nil, context: stack.context)
                photo.annotationPoint = entity!
                try coreDataStack().saveContext()
            } catch {
                print("Add Core Data Failed")
            }
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
