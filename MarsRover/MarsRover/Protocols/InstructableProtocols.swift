//
//  InstructableProtocols.swift
//  MarsRovers
//
//  Created by Jain, Manish on 06/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

protocol Instructable {
    var identifier:String {get}
    func canfollow(instruction:Instruction) -> Bool
    func follow(instruction:Instruction) throws
}

protocol Positionalble {
    var currentPosition:Position {get set}
}

protocol Moveable:Instructable,Positionalble {
    var movementController:MovementController {get set}
}

protocol MovementResultPredictor where Self:InstructionProcessor {
    func predictMovementResult(of instruction: Instruction, moveable:Moveable, completion:@escaping (Position) -> ())
}

