//
//  MockRoverInteractor.swift
//  MarsRovers
//
//  Created by Jain, Manish on 05/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

typealias InstructionCompletionBlock = (Rover,Position) -> Void
typealias CompletionBlock = (Rover?) -> Void
typealias FailureBlock = (RoverInstructionErrors) -> Void

class MockRoverPresenter: RoverPresenter {
    
    var validationSuccess = false
    var instructionCompletionBlock:InstructionCompletionBlock?
    var completionBlock:CompletionBlock?
    var failureBlock:FailureBlock?
    var rover:Rover?

    override func handleValidationSuccess(rover:Rover, resultantPosition:Position)  {
        self.rover = rover
        self.rover?.currentPosition = resultantPosition
        validationSuccess = true
        instructionCompletionBlock?(rover, resultantPosition)
    }
    
    override func handleValidationFailure(validationError: RoverInstructionErrors) {
        validationSuccess = true
        failureBlock?(validationError)
    }
    
    override func InstructionExecutionCompleted() {
        validationSuccess = true
        guard let rover = self.rover else {
            return
        }
        completionBlock?(rover)
    }
}
