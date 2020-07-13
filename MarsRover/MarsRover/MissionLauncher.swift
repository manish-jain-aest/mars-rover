//
//  MissionLauncher.swift
//  MarsRovers
//
//  Created by Jain, Manish on 02/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

struct MissionLauncher {

    static let sharedInstance = MissionLauncher()
    
    func createRover(roverName:String, initialPosition:Position,roverController:MovementController) -> Rover {
        let rover:Rover = Rover(name: roverName, with: initialPosition, roverController:roverController)
        return rover
    }
}
