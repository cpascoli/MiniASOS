//
//  ImageDownloader.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

typealias ImageResponse = (UIImage?, Error?) -> Void

/**
 * Structure used to hold the client callback and other data while the image request is in-flight.
 */
struct TaskData {
    let callback:ImageResponse
    let task:URLSessionDataTask
    let url:String
    init(url:String, task:URLSessionDataTask, callback:@escaping ImageResponse) {
        self.url = url
        self.task = task
        self.callback = callback
    }
}

/**
 *  This class is used to download and cache images.
 *
 *  Internally it's using ImageCache to reduce the app memory usage and speedup the rendering.
 *  'large' images get resized before being stored into the cache and passed to the client callback.
 *   An image is considered 'large', and gets resized, if its width is greather than 400px.
 */

class ImageDownloader: NSObject, URLSessionDataDelegate {

    // constant
    private let maxImageWidth = CGFloat(400.0)
    
    // To be injected
    var session:URLSession!
    let imageCache = ImageCache()

    private var inflightRequests = [Int:TaskData]()

    /**
        Download the Image at the given url.
     
        @param url the image URL
        @param onCompletion the completion handler which includes a UIImage
     
        @return the Task Id that can be used to cancel the download 
                or -1 if the image was returned from the local cache.
    */
    public func fetchImage(for url:String, onCompletion:@escaping ImageResponse) -> Int {
        
        let image = self.imageCache.get(key: url)
        if image == nil {
            // request for image
            print("download image: ", url)
            let request = imageRequest(url: URL(string:url)!)
            let task = self.session.dataTask(with: request)
            inflightRequests[task.taskIdentifier] = TaskData(url:url, task: task, callback: onCompletion)
            task.resume()
            return task.taskIdentifier
        }
        
        // return cached image
        onCompletion(image, nil)
        return -1
    }
    
    /**
        Cancel an inflight download task.
        @param taskId the task to be cancelled
     */
    public func cancel(taskId:Int) {
        let taskData = inflightRequests[taskId]
        if let task = taskData?.task {
            task.cancel()
            inflightRequests.removeValue(forKey: taskId)
        }
    }
    
   
    //MARK: URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        let taskData = inflightRequests[dataTask.taskIdentifier]
        if let taskData = taskData {
            // resize images if needed and store them in the memory cache
            let resizedImage = resizeImage(image:UIImage(data: data), width:maxImageWidth)
            if let image = resizedImage {
                self.imageCache.set(image: image, key: taskData.url)
            }
            taskData.callback(resizedImage, nil)
        }
    }
 
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        // task completed: remove it from inflight tasks
        let taskData = inflightRequests.removeValue(forKey: task.taskIdentifier)
        if let error = error {
            taskData?.callback(nil, error)
        }
        print("urlSession:task:didComplete - inflight : \(inflightRequests.count)")
    }

    //MARK: Private
    
    private func imageRequest(url:URL) -> URLRequest {
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("Content-type: image/png", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func resizeImage(image: UIImage?, width: CGFloat) -> UIImage? {
        
        guard let image = image else {
            return nil
        }
        
        // If the image is smaller than 'maxImageWidth' return it unchanged
        if (image.size.width < maxImageWidth) {
            return image;
        }
        
        // scale and return a smaller image.
        let scale = width / image.size.width
        let height = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        image.draw(in: CGRect(x:0, y:0, width:width, height:height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

/**
 * A simple implementation of an in-memory cache for Images.
 * The cache is cleared when the app receives didReceiveMemoryWarning
 * or the user shakes the device (for testing purpose)
 */

class ImageCache {
    
    private var imageCache = [String:UIImage]()
    
    public func get(key url:String) -> UIImage? {
        return imageCache[url]
    }
    
    public func set(image: UIImage, key url:String) {
        return imageCache[url] = image
    }
    
    public func hasImage(for url:String) -> Bool {
        let image = imageCache[url]
        return (image != nil)
    }
    
    public func resetCache() {
        self.imageCache.removeAll()
        print("Image cache cleared!")
    }
    
}
