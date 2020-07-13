//
//  InstructionProcessor.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

protocol InstructionProcessor {
    var instructionQueue:DispatchQueue? {get}
    func processInstructions(instructions: Instruction, on instructable:Instructable, completion:@escaping(Instructable)->()) throws
}

class RoverInstructionProcessor: InstructionProcessor,MovementResultPredictor {
    
    private init() {}
    
    var instructionQueue: DispatchQueue? {
        let queue = DispatchQueue.global(qos: .utility)
        return queue
    }
    
    static let sharedInstance:RoverInstructionProcessor = RoverInstructionProcessor()
    
    func processInstructions(instructions: Instruction, on instructable:Instructable, completion:@escaping(_ instructable:Instructable)->()) {
        self.instructionQueue?.async {
            try? instructable.follow(instruction: instructions)
            completion(instructable)
        }
    }
    
    func predictMovementResult(of instruction: Instruction, moveable:Moveable, completion:@escaping (Position) -> ()) {
        let command = instruction.command
        
        switch command {
            
        case SupportedInstructions.left.rawValue:
            let position = moveable.movementController.turnLeft(fromPosition: moveable.currentPosition)
            completion(position)
            
        case SupportedInstructions.right.rawValue:
            let position = moveable.movementController.turnRight(fromPosition: moveable.currentPosition)
            completion(position)
            
        case SupportedInstructions.moveForward.rawValue:
            let position = moveable.movementController.moveForward(fromPosition: moveable.currentPosition)
            completion(position)
            
        default:
            break
        }
    }
}
