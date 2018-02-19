//
//  GiphySearchResultViewController.swift
//  emogiphy
//
//  Created by Naveen on 12/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import UIKit
//import SwiftGifOrigin
class GiphySearchResultViewController: UIViewController {

    @IBOutlet weak var loaderBG: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var giphySearchResultsCollectionView: UICollectionView! {
        didSet {
            giphySearchResultsCollectionView.dataSource = self
            giphySearchResultsCollectionView.delegate = self
        }
    }
    var selectedSearchTerms: [String]?
    var giphyType: GiphyType?
    var giphys = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoading(value: true)
        self.automaticallyAdjustsScrollViewInsets = false
        giphySearchResultsCollectionView.register(UINib.init(nibName: "GipySearchResultCollectionViewCell", bundle: Bundle.main),
                                      forCellWithReuseIdentifier: StrConstants.giphyreuseid)
        if giphyType == .trending {
            GiphyService.giphysDataForSearch(text: nil, type: giphyType) { giphys in
                self.reloadTableViewWith(giphys: giphys)
            }
        } else if giphyType == .normal {
            if let searchText = searchTextFor(searchTerms: selectedSearchTerms) {
                GiphyService.giphysDataForSearch(text: searchText, type: giphyType) { giphys in
                     self.reloadTableViewWith(giphys: giphys)
                }
            }
        }
    }
    func reloadTableViewWith(giphys: [[String: Any]]) {
        self.giphys = giphys
        self.giphySearchResultsCollectionView.reloadData()
        self.setLoading(value: false)
    }
    func searchTextFor(searchTerms: [String]?) -> String? {
        var searchText: String? = nil
        if searchTerms != nil {
            let randomIndex = GiphyService.generateRandomNumberLessThan(number: searchTerms!.count)
            if searchTerms!.indices.contains(randomIndex) {
                searchText = searchTerms![randomIndex]
            }
        }
        return searchText
    }
    func setLoading(value: Bool) {
        if value == true {
            loaderBG.isHidden = false
            spinner.startAnimating()
        } else {
            loaderBG.isHidden = true
            spinner.stopAnimating()
        }
    }
}
extension GiphySearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utility.cellSizeFor(deviceWidth:UIScreen.main.bounds.width, view: view)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let downsizedURL = GiphyService.giphyDownsizedURLFor(index: indexPath.item, inData: giphys)
        let (_, directURL) = GiphyService.giphyURLFor(index: indexPath.item,
                                                             inData: giphys)
        _ = gipySelectionAction(directURL: directURL, downsizedURL: downsizedURL) { data in
            self.setLoading(value: false)
            if data != nil {
                self.performSegue (withIdentifier: "DetailView", sender: data)
            }
        }
    }
    func gipySelectionAction(directURL: String?, downsizedURL: String?, completionHandler: @escaping([String:Any]?) -> Void) {
        var dictObject: [String: Any] = [String: Any]()
        if directURL != nil {
            dictObject["imageURL"] = directURL
            let serialQueue = DispatchQueue(label: "downsizedimageload")
            setLoading(value: true)
            serialQueue.async {
                do {
                    let data = try Data(contentsOf: URL(string: downsizedURL!)!)
                    dictObject["imageData"] = data
                    DispatchQueue.main.async {
                        completionHandler(dictObject)
                    }
                } catch {
                    completionHandler(nil)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailView"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            let nextScene =  segue.destination as? EmojiDetailViewController
            let dictObject  = sender as? [String: Any]
            nextScene?.imageData  = dictObject?["imageData"] as? Data
            nextScene?.imageURL = dictObject?["imageURL"] as? String
        }
    }

}
extension GiphySearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StrConstants.giphyreuseid,
                                                         for: indexPath) as? GipySearchResultCollectionViewCell {
            cell.swiftGifView.image = nil
            let (giphyURL, _) = GiphyService.giphyURLFor(index: indexPath.item, inData: giphys)
            cell.spinner.startAnimating()
            if giphys[indexPath.item]["downloaded_gif"] == nil && giphyURL != nil {
                GiphyService.gifImageFor(url: giphyURL!) { gifImage in
                    self.giphys[indexPath.item]["downloaded_gif"] = gifImage
                    if let cell = collectionView.cellForItem(at: indexPath) as? GipySearchResultCollectionViewCell {
                        cell.swiftGifView.image = gifImage
                        cell.spinner.stopAnimating()
                        cell.setNeedsDisplay()
                    }
                }
            } else {
                if let existingImage = giphys[indexPath.item]["downloaded_gif"] as? UIImage {
                    cell.swiftGifView.image = existingImage
                    cell.spinner.stopAnimating()
                    cell.setNeedsDisplay()
                }
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: StrConstants.giphyreuseid, for: indexPath)
    }
}
