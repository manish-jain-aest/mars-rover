//
//  Rover.swift
//  MarsRovers
//
//  Created by Jain, Manish on 02/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

struct Location:Equatable {
    var x_co_ordinate:Double = 0
    var y_co_ordinate:Double = 0
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.x_co_ordinate == rhs.x_co_ordinate && lhs.y_co_ordinate == rhs.y_co_ordinate
    }
}

struct CardinalPosition:Equatable {
    var direction:String
    
    static func == (lhs: CardinalPosition, rhs: CardinalPosition) -> Bool {
        return lhs.direction == rhs.direction
    }
}

struct Position:Equatable {
    
    var location:Location
    var cardinalPosition:CardinalPosition
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.location == rhs.location && lhs.cardinalPosition == rhs.cardinalPosition
    }
}

class Rover: Positionalble {
    
    fileprivate var roverIdentifier:String = UUID().uuidString
    
    var identifier: String {
        get {
            return roverIdentifier
        }
    }
    
    var name:String
    var currentPosition:Position
    var movementController: MovementController
    
    init(name:String,with initialPosition:Position, roverController:MovementController) {
        self.name = name
        self.currentPosition = initialPosition
        self.movementController = roverController
    }
}

extension Rover : CustomStringConvertible {
    var description: String {
        let roverCoordinates = (Int(self.currentPosition.location.x_co_ordinate),Int(self.currentPosition.location.y_co_ordinate))
        let roverOrientation = self.currentPosition.cardinalPosition.direction
        let roverPosition = "\(roverCoordinates),\(roverOrientation)"
        let roverDescription = "\(self.name)-\(roverPosition)"
        return roverDescription
    }
}

extension Rover:Equatable {
    static func == (lhs: Rover, rhs: Rover) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Rover:Moveable {
    internal func canfollow(instruction: Instruction) -> Bool {
        
        guard SupportedInstructions(rawValue:instruction.command) != nil else{
            return false
        }
        
        return true
    }
    
    internal func follow(instruction: Instruction) throws {
        let command = instruction.command
        
        switch command {
        case SupportedInstructions.left.rawValue:
            self.currentPosition = movementController.turnLeft(fromPosition: self.currentPosition)
            break
            
        case SupportedInstructions.right.rawValue:
            self.currentPosition = movementController.turnRight(fromPosition: self.currentPosition)
            break
            
        case SupportedInstructions.moveForward.rawValue:
            self.currentPosition = movementController.moveForward(fromPosition: self.currentPosition)
            break
            
        default:
            throw RoverInstructionErrors.InvalidInstruction
        }
        
    }
}
