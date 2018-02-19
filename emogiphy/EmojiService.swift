//
//  EmojiService.swift
//  emogiphy
//
//  Created by Naveen on 10/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import Foundation
class EmojiService {
    fileprivate class func dataSource(searchType: SearchType) -> [[String:Any]] {
        var data = [[String:Any]] ()
        if searchType == .emoji {
            data = [[StrConstants.searchTerms: ["laugh", "smile", "joy", "ha ha", "rofl"], SearchType.emoji.rawValue: "😂"],
                                        [StrConstants.searchTerms: ["grin", "funny", "lol", "awesome"], SearchType.emoji.rawValue: "😬"],
                                        [StrConstants.searchTerms: ["cool", "hipster", "star eyes", "shades", "peace out"],
                                         SearchType.emoji.rawValue: "😎"],
                                        [StrConstants.searchTerms: ["geeky", "studious", "nerd", "bots", "books"],
                                         SearchType.emoji.rawValue: "🤓"],
                                        [StrConstants.searchTerms: ["thinking", "pondering", "thoughtful", "dreaming", "think"],
                                         SearchType.emoji.rawValue: "🤔"],
                                        [StrConstants.searchTerms: ["mischief", "troublemaker", "devil", "screwed", "evil"],
                                         SearchType.emoji.rawValue: "😝"],
                                        [StrConstants.searchTerms: ["no words", "awestruck", "silence", "speechless", "slow clap"],
                                         SearchType.emoji.rawValue: "😑"],
                                        [StrConstants.searchTerms: ["angry", "furious", "pissed off", "destruction", "irritated"],
                                         SearchType.emoji.rawValue: "😠"],
                                        [StrConstants.searchTerms: ["heart", "affection", "romance", "romantic", "love"],
                                         SearchType.emoji.rawValue: "❤️"],
                                        [StrConstants.searchTerms: ["love", "flying kiss", "awesome", "thumbs up", "wink"],
                                         SearchType.emoji.rawValue: "😘"]]
        } else if searchType == .image {
            data = [[StrConstants.searchTerms:["Sarcasm", "slow clap", "clap", "sarcastic"], SearchType.image.rawValue: "Sarcasm"],
                    [StrConstants.searchTerms: ["Nerdgasm", "geek"], SearchType.image.rawValue: "Nerdgasm"],
                    [StrConstants.searchTerms: ["Hot", "sexy"], SearchType.image.rawValue: "HotStuff"],
                    [StrConstants.searchTerms: ["cat", "funny cat"], SearchType.image.rawValue: "Cat-ostrophic"],
                    [StrConstants.searchTerms: ["drunk", "fully drunk"], SearchType.image.rawValue: "Drunk"],
                    [StrConstants.searchTerms: ["grin", "funny", "lol", "rofl", "smile"], SearchType.image.rawValue: "Funny"],
                    [SearchType.image.rawValue: "Popular"],
                    [StrConstants.searchTerms: ["Bro code", "Bro"], SearchType.image.rawValue: "Bro-Code"]]
        }
        return data
    }
    class func noOfItemsFor(searchType: SearchType) -> Int {
        return dataSource(searchType: searchType).count
    }
    class func displayDataFor(index: Int, searchType: SearchType) -> String? {
        var emoji: String?
        if dataSource(searchType: searchType).indices.contains(index) {
            let emojiData = dataSource(searchType: searchType)[index]
            if let emj = emojiData[searchType.rawValue] as? String {
                emoji = emj
            }
        }
        return emoji
    }
    class func searchTermsFor(index: Int, searchType: SearchType) -> [String]? {
        var emojiSearchTerm: [String]?
        if dataSource(searchType: searchType).indices.contains(index) {
            if let searchTerm = dataSource(searchType: searchType)[index][StrConstants.searchTerms] as? [String] {
                emojiSearchTerm = searchTerm
            }
        }
        return emojiSearchTerm
    }
}
