//
//  InstructionParser.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

enum RoverInstructionErrors:Error {
    case InvalidInstruction
    case RiskOfCollision
    case LocationOutOfBounds
    case UnknownErrorInstructionMessage
}

protocol InstructionParser {
    func parseInstructions(instructionString:String) throws -> [Instruction]
}

struct RoverInstructionParser:InstructionParser {
    
    var instructable:Instructable
    
    init(instructable:Instructable) {
        self.instructable = instructable
    }
    
    func parseInstructions(instructionString: String) throws -> [Instruction] {
        var instructionsToBeProcessed: [Instruction] = Array<Instruction>()
        
        let proposedInstructions = instructionString.compactMap { String($0) }
        
        for command in proposedInstructions {
            
            let instruction = RoverInstruction(instructionId: UUID().uuidString, command: command)
            
            guard self.instructable.canfollow(instruction: instruction) else {
                throw RoverInstructionErrors.InvalidInstruction
            }
            
            instructionsToBeProcessed.append(instruction)

        }
        
        return instructionsToBeProcessed
    }
}
