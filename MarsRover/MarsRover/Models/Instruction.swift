//
//  Instruction.swift
//  MarsRovers
//
//  Created by Jain, Manish on 02/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

enum SupportedInstructions:String,CaseIterable {
    case left = "L"
    case right = "R"
    case moveForward = "M"
    
    static func supportedInstructionStringRepresentation() -> String {
        return self.allCases.reduce("", {String($0) + String($1.rawValue) + ","})
    }
}

enum SupportedCardinalPositions:String {
    case East = "E"
    case West = "W"
    case North = "N"
    case South = "S"
}

protocol Instruction {
    var instructionId:String {get}
    var command:String {get}
}

struct RoverInstruction : Instruction {
    var instructionId: String
    var command: String
}
