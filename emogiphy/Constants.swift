//
//  Constants.swift
//  emogiphy
//
//  Created by Naveen on 10/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import Foundation
enum SearchType: String {
    case emoji
    case image
}
enum GiphyType: String {
    case normal
    case trending
}

struct StrConstants {
    static let searchTerms = "searchTerms"
    static let emojireuseid = "emoji"
    static let giphyreuseid = "giphycell"
    static let picreuseid = "piccell"
}
struct Keys {
    static let giphy = "dc6zaTOxFJmzC"
}
struct APIs {
    static let urls: [GiphyType: String] = [GiphyType.normal: "https://api.giphy.com/v1/gifs/search",
                        GiphyType.trending: "https://api.giphy.com/v1/gifs/trending"]
    //static let giphyURL = "https://api.giphy.com/v1/gifs/search"
    //static let trendingURL = "http://api.giphy.com/v1/gifs/trending"
}

struct JSONFields {
    static let query = "q"
    static let apiKey = "api_key"
    static let giphyImageSmallSize = "fixed_width_small"
    static let downsizedMedium = "downsized_medium"
    static let giphyImageURL = "url"
    static let giphyImages = "images"
}

struct Message {
    static let twitterAlert = "Please login into twitter in settings inorder to continue to send giphy image"
    static let facebookAlert = "Please login into facebook in settings inorder to continue to send giphy image"
    static let iMessageAlert = "iMessage is not available"
}
