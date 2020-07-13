//
//  RoverView.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation
import UIKit

class CircularRoverView: UIView {
    
    private var rover:Rover?
    
    var roverColor:UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }
    
    var position:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue.x
            frame.origin.y = newValue.y
            self.frame = frame
        }
    }
    
    func getAssociatedRover() -> Rover? {
        return self.rover
    }
    
    convenience init(rover:Rover, radius:Double) {
        let origin = CGPoint(x: 0, y: 0)
        let frame = CGRect(origin: origin, size: CGSize(width: radius, height: radius))
        self.init(frame: frame)
        self.rover = rover
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularView()
    }
    
    func createCircularView() {
        self.backgroundColor = UIColor.green
        self.layer.cornerRadius = self.frame.size.width/2
    }
}
