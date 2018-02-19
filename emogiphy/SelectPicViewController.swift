//
//  SelectPicViewController.swift
//  emogiphy
//
//  Created by Naveen on 13/06/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import UIKit

class SelectPicViewController: UIViewController {

    @IBOutlet weak var picCollectionView: UICollectionView! {
        didSet {
            picCollectionView.dataSource = self
            picCollectionView.delegate = self
        }
    }
    fileprivate var giphyType: GiphyType = .normal
    fileprivate var trendingGifIndexPath = 6
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        picCollectionView.register(UINib.init(nibName: "SelectPicCollectionViewCell", bundle: Bundle.main),
                                   forCellWithReuseIdentifier: StrConstants.picreuseid)
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showgifs" {
            if let dvc = segue.destination as? GiphySearchResultViewController {
                dvc.selectedSearchTerms = sender as? [String]
                dvc.giphyType = giphyType
            }
        }
    }
}

extension SelectPicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utility.displayPicCellSizeFor(deviceWidth: UIScreen.main.bounds.width, view: view)
    }
}

extension SelectPicViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmojiService.noOfItemsFor(searchType: .image)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = picCollectionView.dequeueReusableCell(withReuseIdentifier: StrConstants.picreuseid,
                                                            for: indexPath) as? SelectPicCollectionViewCell {
            if let displayImage = EmojiService.displayDataFor(index: indexPath.item, searchType: .image) {
                cell.searchPic.image = UIImage(named: displayImage)
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: StrConstants.picreuseid, for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == trendingGifIndexPath {
            giphyType = .trending
            performSegue(withIdentifier: "showgifs", sender: nil)
        } else {
            if let searchTerms = EmojiService.searchTermsFor(index: indexPath.item, searchType: .image) {
                giphyType = .normal
                performSegue(withIdentifier: "showgifs", sender: searchTerms)
            }
        }
    }
}
