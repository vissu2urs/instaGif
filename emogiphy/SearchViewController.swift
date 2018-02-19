//
//  SearchViewController.swift
//  emogiphy
//
//  Created by Vishnu on 14/06/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import UIKit
class SearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchText: UITextField!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let status = findTextSetup(textObject: textField)
        return status
    }
    @IBAction func viewAction(_ sender: UIButton?) {
        searchText.resignFirstResponder()
    }
    @IBAction func gifSearchButtonAction(_ sender: UIButton) {
       _ = findTextSetup(textObject: searchText)
    }
    func findTextSetup(textObject: UITextField) -> Bool {
        if let text = textObject.text, !text.isEmpty == true {
            let searchArray = [textObject.text]
            performSegue(withIdentifier: "SearchResult", sender: searchArray)
            textObject.resignFirstResponder()
            return true
        }
        return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResult"{
            if let dvc = segue.destination as? GiphySearchResultViewController {
                dvc.selectedSearchTerms = sender as? [String]
                dvc.giphyType = .normal
            }
        }
    }
}
