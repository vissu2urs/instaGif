//
//  ViewController.swift
//  emogiphy
//
//  Created by Naveen on 10/05/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import UIKit

class EmojiCollectionViewController: UIViewController {

    @IBOutlet weak var emojisCollectionView: UICollectionView! {
        didSet {
            emojisCollectionView.dataSource = self
            emojisCollectionView.delegate = self
        }
    }
    let noOfItems = EmojiService.noOfItemsFor(searchType: .emoji)
    override func viewDidLoad() {
        super.viewDidLoad()
       emojisCollectionView.register(UINib.init(nibName: "EmojiCollectionViewCell", bundle: Bundle.main),
                                     forCellWithReuseIdentifier: StrConstants.emojireuseid)
        if let layout = emojisCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 75, height: 75)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listgiphys" {
            if let dvc = segue.destination as? GiphySearchResultViewController {
                dvc.selectedSearchTerms = sender as? [String]
                dvc.giphyType = .normal
            }
        }
    }
}

extension EmojiCollectionViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "emoji"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? EmojiCollectionViewCell {
            cell.emojiLbl.text = EmojiService.displayDataFor(index: indexPath.item, searchType: .emoji)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noOfItems
    }
}

extension EmojiCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("selected item no", indexPath.item)
        if let searchTerms = EmojiService.searchTermsFor(index: indexPath.item, searchType: .emoji) {
            //print("search terms are ", searchTerms)
            performSegue(withIdentifier: "listgiphys", sender: searchTerms)
        }
    }
}
