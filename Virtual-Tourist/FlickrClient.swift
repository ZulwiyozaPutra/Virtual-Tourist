//
//  FlickrClient.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import MapKit

class FlickrClient: NSObject {
    
    struct Constant {
        static let flickrEndpoint = "https://api.flickr.com/services/rest/"
        static let flickrAPIKey = "2a2ad0534c538cea62c640e0d2520400"
        static let flickrSearch = "flickr.photos.search"
        static let dataFormat = "json"
        static let searchRangeKM = 3
    }
    
    //Get Images
    private static func requestImages(location: CLLocation, completion: @escaping (_ error: Error?, _ flickrImages:[FlickrImage]?) -> Void) {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let url = URL(string: "\(Constant.flickrEndpoint)?method=\(Constant.flickrSearch)&format=\(Constant.dataFormat)&api_key=\(Constant.flickrAPIKey)&lat=\(latitude)&lon=\(longitude)&radius=\(Constant.searchRangeKM)")!
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(error!, nil)
                return
            }
            
            let range = Range(uncheckedBounds: (14, data!.count - 1))
            let newData = data?.subdata(in: range)
            
            if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String: Any],
                let photosMeta = json?["photos"] as? [String: Any],
                let photos = photosMeta["photo"] as? [Any] {
                
                var flickrImages:[FlickrImage] = []
                
                for photo in photos {
                    if let flickrImage = photo as? [String:Any],
                        let id = flickrImage["id"] as? String,
                        let secret = flickrImage["secret"] as? String,
                        let server = flickrImage["server"] as? String,
                        let farm = flickrImage["farm"] as? Int {
                        
                        flickrImages.append(FlickrImage(id: id, secret: secret, server: server, farm: farm))
                        
                    }
                }
                completion(nil, flickrImages)
            }
        }
        task.resume()
    }
    
    static func getFlickrImages(location: CLLocation, completion: @escaping (_ error: Error?, _ flickrImages :[FlickrImage]?) -> Void) {
        
        var result: [FlickrImage] = []
        FlickrClient.requestImages(location: location) { (error: Error?, flickrImages: [FlickrImage]?) in
            guard error == nil else {
                completion(error!, nil)
                return
            }
            
            if flickrImages!.count > 25 {
                var randomArray: [Int] = []
                
                while randomArray.count < 25 {
                    let random = arc4random_uniform(UInt32(flickrImages!.count))
                    if !randomArray.contains(Int(random)) { randomArray.append(Int(random)) }
                }
                
                for random in randomArray {
                    
                    result.append(flickrImages![random])
                }
                completion(nil, result)
                
            } else {
                completion(nil, result)
                
            }
        }
    }
}
