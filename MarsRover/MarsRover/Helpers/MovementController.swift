//
//  MovementController.swift
//  MarsRovers
//
//  Created by Jain, Manish on 05/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

protocol MovementController {
    func turnLeft(fromPosition:Position) -> Position
    func turnRight(fromPosition:Position) -> Position
    func moveForward(fromPosition:Position) -> Position
}

struct RoverController:MovementController {
    
    func turnLeft(fromPosition:Position) -> Position {
        var currentPosition = fromPosition
        
        switch currentPosition.cardinalPosition.direction {
            
        case SupportedCardinalPositions.East.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.North.rawValue
            break
            
        case SupportedCardinalPositions.West.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.South.rawValue
            break
            
        case SupportedCardinalPositions.North.rawValue:
            //let result = NorthMovementMapper.nextPosition(from: subject.currentPosition)
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.West.rawValue
            break
            
        case SupportedCardinalPositions.South.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.East.rawValue
            break
            
        default:
            break
        }
        
        return currentPosition
    }
    
    func turnRight(fromPosition:Position) -> Position {
        
        var currentPosition = fromPosition
        
        switch currentPosition.cardinalPosition.direction {
            
        case SupportedCardinalPositions.East.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.South.rawValue
            break
            
        case SupportedCardinalPositions.West.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.North.rawValue
            break
            
        case SupportedCardinalPositions.North.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.East.rawValue
            break
            
        case SupportedCardinalPositions.South.rawValue:
            currentPosition.cardinalPosition.direction = SupportedCardinalPositions.West.rawValue
            break
            
        default:
            break
        }
        
        return currentPosition
    }
    
    func moveForward(fromPosition:Position) -> Position {
        
        var currentPosition = fromPosition
        
        switch currentPosition.cardinalPosition.direction {
            
        case SupportedCardinalPositions.East.rawValue:
            currentPosition.location.x_co_ordinate += 1
            break
            
        case SupportedCardinalPositions.West.rawValue:
            currentPosition.location.x_co_ordinate -= 1
            break
            
        case SupportedCardinalPositions.North.rawValue:
            currentPosition.location.y_co_ordinate += 1
            break
            
        case SupportedCardinalPositions.South.rawValue:
            currentPosition.location.y_co_ordinate -= 1
            break
            
        default:
            break
        }
        
        return currentPosition
    }
    
}
