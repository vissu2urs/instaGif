//
//  emogiphyTests.swift
//  emogiphyTests
//
//  Created by Naveen on 10/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import XCTest
@testable import emogiphy
class EmogiphyTests: XCTestCase {
    var giphyVC: GiphySearchResultViewController!
    var giphyDetail: EmojiDetailViewController!
    var emojiVC: EmojiCollectionViewController!
    var searchVC: SearchViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyBoard = UIStoryboard(name: "GiphySearchResult", bundle: Bundle.main)

        giphyVC = storyBoard.instantiateViewController(withIdentifier: "Giphy") as? GiphySearchResultViewController
        giphyVC.selectedSearchTerms = ["laugh", "smile", "joy", "ha ha", "rofl"]
        giphyVC.giphyType = .trending
        giphyVC.beginAppearanceTransition(true, animated: false)
        let storyBoard2 = UIStoryboard(name: "GiphySearchResult", bundle: Bundle.main)
        giphyDetail = storyBoard2.instantiateViewController(withIdentifier: "GiphyDetail") as? EmojiDetailViewController
        _ = giphyVC.view

        let emojiStoryBoard = UIStoryboard(name: "SelectEmoji", bundle: Bundle.main)
        emojiVC = emojiStoryBoard.instantiateViewController(withIdentifier: "EmojiVC") as? EmojiCollectionViewController
        emojiVC.beginAppearanceTransition(true, animated: false)
        _ = emojiVC.view
        let searchBoard = UIStoryboard(name: "Search", bundle: Bundle.main)
        searchVC = searchBoard.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController
        searchVC.beginAppearanceTransition(true, animated: false)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        emojiVC.endAppearanceTransition()
        searchVC.endAppearanceTransition()
    }
    func testEmojis() {
        let emojisCount = EmojiService.noOfItemsFor(searchType: .emoji)
        XCTAssert(emojisCount == 10)
        let picsCount = EmojiService.noOfItemsFor(searchType: .image)
        XCTAssert(picsCount == 8)
    }
    func testGiphyDetail() {
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "giphy", withExtension: "gif")!) {
            giphyDetail.imageData = imageData
            giphyDetail.imageURL = "https://giphy.com/gifs/mattcutshall-matt-cutshall-l0Iy9g9pvspPyJIju"
            _ = giphyDetail.view
            XCTAssertTrue(giphyDetail.twitterShareGiphy())
            XCTAssertTrue( giphyDetail.messageShareGiphy())
            XCTAssertTrue (giphyDetail.moreShareGiphy())
            XCTAssertTrue(giphyDetail.facebookShareGiphy())
        }
    }
    func testEmojisFor() {
        /*let emoji = EmojiService.emojiFor(index: 2)
        XCTAssert(emoji == "😎")
        let emojinotfound = EmojiService.emojiFor(index: 10001)
        XCTAssert(emojinotfound == nil)*/
        let emoji = EmojiService.displayDataFor(index: 2, searchType: .emoji)
        XCTAssert(emoji == "😎")
    }
    func testEmojiSearchFor() {
        if let searchText = EmojiService.searchTermsFor(index: 3, searchType: .emoji) {
            XCTAssert(searchText == ["geeky", "studious", "nerd", "bots", "books"])
        } else {
            XCTFail("no objects found")
        }
        if let picSearchText = EmojiService.searchTermsFor(index: 3, searchType: .image) {
            XCTAssert(picSearchText == ["cat", "funny cat"])
        } else {
            XCTFail("no objects found")
        }
        let searchNotFound = EmojiService.searchTermsFor(index: 10001, searchType: .emoji)
        XCTAssert(searchNotFound == nil)
    }
    func testgiphysDataForSearch() {
        let expection1 = expectation(description: "waiting for giphy API to return results")
        GiphyService.giphysDataForSearch(text: "smile", type: .normal) { giphyData in
            if giphyData.count > 0 {
                expection1.fulfill()
            } else {
                XCTFail("no objects available")
            }
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expectation failed", error ?? "no error")
        }
        let expection3 = expectation(description: "waiting for giphy API to return results")
        GiphyService.giphysDataForSearch(text: "sdfdsfdf", type: .normal) { giphyData in
            if giphyData.count == 0 {
                expection3.fulfill()
            } else {
                XCTFail("no objects found")
            }
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expectation failed", error ?? "no error")
        }
    }
    func testgiphysDataForSearchWitTypeNil() {
        let expectation1 = expectation(description: "waiting for giphy api to return results")
        GiphyService.giphysDataForSearch(text: "smile", type: nil) { giphyData in
            if giphyData.count > 0 {
                expectation1.fulfill()
            } else {
                XCTFail("no objects found")
            }
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expectation failed", error ?? "no error")
        }
    }
    func testgiphyURLForIndex() {
        let data =  [["url": "https://giphy.com/gifs/mattcutshall-matt-cutshall-l0Iy9g9pvspPyJIju", "images": ["fixed_width_small":
                                ["url": "http://media4.giphy.com/media/3o7aTpFglw46r5BfHi/200w_s.gif"]]
                    ]]
        let (smallURL, directURL) = GiphyService.giphyURLFor(index: 0, inData: data)
        if smallURL != nil && directURL != nil {
            XCTAssertEqual(smallURL, "http://media4.giphy.com/media/3o7aTpFglw46r5BfHi/200w_s.gif")
            XCTAssertEqual(directURL, "https://giphy.com/gifs/mattcutshall-matt-cutshall-l0Iy9g9pvspPyJIju")
            //let localURL = GiphyService.localURLFor(giphyURL: smallURL!)
            //XCTAssertTrue(giphyVC.gipySelectionAction(smallURL: smallURL, directURL: downsizedURL))
            //XCTAssertNotNil(localURL)
        } else {
            XCTFail("no objects found")
        }
    }
    func testgipySelectionAction() {
        let exp = expectation(description: "waiting for share image")
        let directURL = "https://giphy.com/gifs/excited-family-guy-stewie-griffin-7eAvzJ0SBBzHy"
        let downsizedURL = "https://media0.giphy.com/media/7eAvzJ0SBBzHy/giphy.gif"
        /*giphyVC.gipySelectionAction(directURL: directURL,
                                    downsizedURL: downsizedURL) { data in
                                        exp.fulfill()
                                        XCTAssertNotNil(data)
        }*/
        giphyVC.gipySelectionAction(directURL: directURL,
                                    downsizedURL: downsizedURL) { data in
                                        XCTAssertNotNil(data)
                                        exp.fulfill()
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expection failed with ", error ?? "no error")
        }
    }
    func testgipySelectionActionNegCase() {
        let exp = expectation(description: "waiting for nil image")
        let incorrectDirectURL = "https://randomurl.com"
        let incorrectDownsizedURL = "https://randomurl.com"
        giphyVC.gipySelectionAction(directURL: incorrectDirectURL,
                                    downsizedURL: incorrectDownsizedURL) { data in
                                        XCTAssertNil(data)
                                        exp.fulfill()
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expection failed with ", error ?? "no error")
        }

    }
    func testdownsizedURLForIndex() {
        let data =  [["url": "https://giphy.com/gifs/mattcutshall-matt-cutshall-l0Iy9g9pvspPyJIju", "images": ["downsized_medium":
            ["url": "http://media4.giphy.com/media/3o7aTpFglw46r5BfHi/200w_s.gif"]]
            ]]
        let downsizedURL = GiphyService.giphyDownsizedURLFor(index: 0, inData: data)
        if downsizedURL != nil {
            XCTAssertEqual(downsizedURL, "http://media4.giphy.com/media/3o7aTpFglw46r5BfHi/200w_s.gif")
        } else {
            XCTFail("no objects found")
        }
    }
    func testsetLoading() {
        giphyVC.setLoading(value: true)
        XCTAssert(giphyVC.loaderBG.isHidden == false)
        XCTAssert(giphyVC.spinner.isAnimating == true)
        giphyVC.setLoading(value: false)
        XCTAssert(giphyVC.loaderBG.isHidden == true)
        XCTAssert(giphyVC.spinner.isAnimating == false)
    }
    func testgenerateRandomNumber() {
        let number = GiphyService.generateRandomNumberLessThan(number: 5)
        XCTAssert(number >= 0 && number <= 4)
    }
    func testgifImageForGiphyURL() {
        let expectation1 = expectation(description: "waiting for gif to be created from giphy")
        let giphyURL = "https://media4.giphy.com/media/3o7aTpFglw46r5BfHi/200w_s.gif"
        GiphyService.gifImageFor(url: giphyURL) { _ in
            expectation1.fulfill()
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expection failed with ", error ?? "no error")
        }
    }
    func testgifFromDocumentsDirectoryForGiphyURL() {
        let expectation1 = expectation(description: "waiting for gif to be created from documents directory")
        let giphyURL = "https://media4.giphy.com/media/3o7aTpFglw46r5BfHi/200w_s.gif"
        GiphyService.gifImageFor(url: giphyURL) { _ in
            expectation1.fulfill()
        }
        waitForExpectations(timeout: 30.0) { error in
            print("expection failed with ", error ?? "no error")
        }
    }
    func testGiphyResultViewControllerInit() {
        if giphyVC != nil {
           // _ = giphyVC.view
            XCTAssertNotNil(giphyVC.giphys)
        }
    }
    func testEmogifyViewControllerInit() {
        if emojiVC != nil {
            //XCTAssertNotNil(emojiVC.emojis)
            XCTAssert(emojiVC.noOfItems > 0)
            //emojiVC.emojisCollectionView.reloadData()
            XCTAssert(emojiVC.emojisCollectionView.numberOfItems(inSection: 0) == 10)
            let collectionView = emojiVC.emojisCollectionView
            XCTAssertNotNil(collectionView?.dataSource?.collectionView(collectionView!, cellForItemAt: IndexPath(item: 0, section: 0)))
        }
    }
    func testsearchTextForSearchTerms() {
        let searchText = giphyVC.searchTextFor(searchTerms: ["laugh", "smile", "joy", "ha ha", "rofl"])
        XCTAssertNotNil(searchText)
        XCTAssertNil(giphyVC.searchTextFor(searchTerms: nil))
    }
    func testCellSize() {
        if giphyVC != nil {
            let cellSize = Utility.cellSizeFor(deviceWidth: CGFloat(750.0), view: emojiVC.view)
            XCTAssertEqual(CGSize(width: 230, height: 230), cellSize)
            let displayCellSize = Utility.displayPicCellSizeFor(deviceWidth: CGFloat(750.0), view: emojiVC.view)
            XCTAssertEqual(CGSize(width: 375, height: 125), displayCellSize)
        }
    }
    func testTextField() {
        let textObj = UITextField()
        textObj.text = ""
        XCTAssertFalse(searchVC.findTextSetup(textObject: textObj))
        textObj.text = "happy"
        XCTAssertTrue(searchVC.textFieldShouldReturn(textObj))
    }
    func testemojiVCPrepareSegue() {
        let segue = UIStoryboardSegue(identifier: "listgiphys", source: emojiVC, destination: giphyVC)
        emojiVC.prepare(for: segue, sender: ["hot"])
        XCTAssertEqual(giphyVC.selectedSearchTerms!, ["hot"])
    }
}
