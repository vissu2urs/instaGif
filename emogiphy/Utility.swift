//
//  Utility.swift
//  emogiphy
//
//  Created by Naveen on 13/06/17.
//  Copyright © 2017 dietcode. All rights reserved.
//

import Foundation
import UIKit
class Utility {
    class func cellSizeFor(deviceWidth width: CGFloat, view: UIView) -> CGSize {
        var noOfColumns = CGFloat(3.0)
        if view.traitCollection.horizontalSizeClass == .regular &&
            view.traitCollection.verticalSizeClass == .regular {
            noOfColumns = CGFloat(5.0)
        }
        let spacing =  CGFloat(20) //this is also defined in storyboard
        let cellWidth = (width - (spacing * noOfColumns)) / noOfColumns
        return CGSize(width:cellWidth, height:cellWidth)
    }
    class func displayPicCellSizeFor(deviceWidth width: CGFloat, view: UIView) -> CGSize {
        var noOfColumns = CGFloat(2.0)
        if view.traitCollection.horizontalSizeClass == .regular &&
            view.traitCollection.verticalSizeClass == .regular {
            noOfColumns = CGFloat(5.0)
        }
        let spacing =  CGFloat(0) //this is also defined in storyboard
        let cellWidth = (width - (spacing * noOfColumns)) / noOfColumns
        return CGSize(width:cellWidth, height:125)
    }
}
