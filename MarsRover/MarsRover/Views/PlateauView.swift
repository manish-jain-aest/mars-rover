//
//  PlateauView.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation
import UIKit

class PlateauView:UIView {
    
    private var plateauBounds:Location = Location()
    
    var traversibleBounds:Location {
        get {
            return plateauBounds
        }
        set {
            self.plateauBounds = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    fileprivate func getLatitudeMovementUnit() -> Double  {
        let plateauWidth = Double(self.bounds.maxX)
        return Double(plateauWidth/plateauBounds.x_co_ordinate)
    }
    
    fileprivate func getLongitudeMovementUnit() -> Double {
        let plateauHeight = Double(self.bounds.maxY)
        return Double(plateauHeight/plateauBounds.y_co_ordinate)
    }
    

    internal func getLocationInPlateau(newLocation:Location) -> CGPoint {
        let x_co_ordinate = (Double(newLocation.x_co_ordinate) * self.getLatitudeMovementUnit())
        let y_co_ordinate = Double(self.bounds.maxY) - (Double(newLocation.y_co_ordinate) * self.getLongitudeMovementUnit())
        let actualPosition = CGPoint(x: x_co_ordinate, y: y_co_ordinate)
        return actualPosition
    }
    
}

