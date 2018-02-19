//
//  GiphyService.swift
//  emogiphy
//
//  Created by Naveen on 12/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import Foundation
import Alamofire
import SwiftGifOrigin
class GiphyService {
    class func giphysDataForSearch(text: String?, type: GiphyType?, completionHandler: @escaping ([[String:Any]]) -> Void) {
        var parameters: Parameters = [JSONFields.apiKey: Keys.giphy]
        if type == .normal || type == nil {
            parameters[JSONFields.query] = text!
        }
        let fetchURL = APIs.urls[type ?? .normal]
        Alamofire.request(fetchURL!, parameters: parameters).responseJSON { response in
            if let result = response.result.value as? [String: Any] {
                if let data = result["data"] as? [[String:Any]] {
                    completionHandler(data)
                }
            } else {
                print("network request failure")
                completionHandler([[String: Any]]())
            }
        }
    }
    class func generateRandomNumberLessThan(number: Int) -> Int {
        let randomIndex = arc4random_uniform(UInt32(number))
        return Int(randomIndex)
    }
    class func giphyURLFor(index: Int, inData data: [[String: Any]]) -> (smallURL: String?, directURL: String?) {
        var smallgifURL: String?
        var directURL: String?
        if data.indices.contains(index) {
            let giphyData = data[index]
            if let images = giphyData[JSONFields.giphyImages] as? [String:Any] {
                if let fixed_height_small = images[JSONFields.giphyImageSmallSize] as? [String:Any] {
                    smallgifURL = fixed_height_small[JSONFields.giphyImageURL] as? String
                }
            }
            if let url = giphyData[JSONFields.giphyImageURL] as? String {
                directURL = url
            }
        }
        return (smallgifURL, directURL)
    }
    class func giphyDownsizedURLFor(index: Int, inData data: [[String:Any]]) -> String? {
        var downsizedURL: String?
        if data.indices.contains(index) {
            let giphyData = data[index]
            if let images = giphyData[JSONFields.giphyImages] as? [String:Any] {
                if let downsized = images[JSONFields.downsizedMedium] as? [String:Any] {
                    downsizedURL = downsized[JSONFields.giphyImageURL] as? String
                }
            }
        }
        return downsizedURL
    }
    class func gifImageFor(url giphyURL: String, completionHandler: @escaping(UIImage) -> Void) {
        if let url = URL(string: giphyURL) {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileName = url.deletingLastPathComponent().lastPathComponent
            if let filePath = documentsURL?.appendingPathComponent(fileName) {
                if FileManager.default.fileExists(atPath: filePath.path) {
                    let serialQueue = DispatchQueue(label: "imageload")
                    serialQueue.async {
                        if let data = try? Data(contentsOf: filePath) {
                            if let gifImage = UIImage.gif(data: data) {
                                DispatchQueue.main.async {
                                    completionHandler(gifImage)
                                }
                            }
                        }
                    }
                } else {
                    let serialQueue = DispatchQueue(label: "imagequeue")
                    serialQueue.async {
                        if let data = try? Data(contentsOf: url) {
                                try? data.write(to: filePath, options: .atomic)
                                DispatchQueue.main.async {
                                    if let gifImage = UIImage.gif(data: data) {
                                        completionHandler(gifImage)
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}
