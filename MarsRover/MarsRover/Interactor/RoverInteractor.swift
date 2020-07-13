//
//  RoverInteractor.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

/*
 Model which holds the rover view and instructions to be executed on the rover
 */
struct RoverInstructionMapper {
    let roverView:CircularRoverView
    let instructions:[Instruction]
}

class RoverInteractor: VIPInteractor {
    var presenter: VIPPresenter?
    
    var roverInstructionMap:[RoverInstructionMapper] = [RoverInstructionMapper]()
    
    init(presenter:VIPPresenter) {
        self.presenter = presenter
    }
    
    /* Create Rovers to be plot on Mars. */
    //Note: Temporary method to create default rovers. Should take input to create rover
    internal func createRovers() -> [Rover] {
        
        let opportunityPosition = Position(location: Location(x_co_ordinate: 1, y_co_ordinate:2), cardinalPosition: CardinalPosition(direction: "N"))
        let Opportunity = MissionLauncher.sharedInstance.createRover(roverName:"Opportunity", initialPosition: opportunityPosition, roverController: RoverController())
        
        let spiritPosition = Position(location: Location(x_co_ordinate: 3, y_co_ordinate:3), cardinalPosition: CardinalPosition(direction: "E"))
        let Spirit = MissionLauncher.sharedInstance.createRover(roverName:"Spirit", initialPosition: spiritPosition, roverController: RoverController())
        
        return [Opportunity, Spirit]
    }
    
    
    /*
     Function to parse valid instruction and associate with relevant views using mapper.
     */
    internal func sanitizeInstructionExecution(instructionString:String, rover:Rover, roverView:CircularRoverView) {
        
        do {
            let roverInstructionParser = RoverInstructionParser(instructable: rover)
            let  instructions = try parseInstructions(using: roverInstructionParser, instructionString: instructionString, rover:rover)
            roverInstructionMap.append(RoverInstructionMapper(roverView: roverView, instructions: instructions))
            self.processInstructions()
        }
        catch RoverInstructionErrors.InvalidInstruction{
            (self.presenter as! RoverPresenter).handleValidationFailure(validationError: RoverInstructionErrors.InvalidInstruction)
        }
        catch {}
    }
    
    
    /*
     Function to parse the instruction string taken from UI as user input, into Instruction objects after validating.
     throws : RoverInstructionErrors :- In case the instruction string has instructions outside SupportedInstructions
     */
    
    internal func parseInstructions(using instructionParser:InstructionParser, instructionString:String, rover:Rover) throws -> [Instruction] {
        
        var instructions:[Instruction] = []
        
        do {
            instructions = try instructionParser.parseInstructions(instructionString: instructionString.uppercased())
        }
        catch RoverInstructionErrors.InvalidInstruction {
            throw RoverInstructionErrors.InvalidInstruction
        }
        catch {}
        
        return instructions
    }
    
    
    /*
     Function to process instructions on associated rover.
     */
    internal func processInstructions() {
        
        defer {
            roverInstructionMap.removeAll()
        }
        
        let roverInstructionProcessor = RoverInstructionProcessor.sharedInstance
        let rovers = (self.presenter as! RoverPresenter).getRovers()
        let platueauBounds = (self.presenter as! RoverPresenter).getPlateauBounds()
        
        for instructionSet in roverInstructionMap {
            self.dispatchInstructions(using: roverInstructionProcessor, instructionSet, rovers: rovers, bounds: platueauBounds)
        }
    }
    
    /*
     Function to dispatch instructions to predict the resultant position which will then be executed after validation
     */
    internal func dispatchInstructions(using roverInstructionProcessor: RoverInstructionProcessor, _ instructionSet: RoverInstructionMapper, rovers:[Rover], bounds:Location) {
        
        defer {
            (self.presenter as! RoverPresenter).InstructionExecutionCompleted()
        }
        
        DispatchQueue.global(qos: .background).async {
            
            guard let rover = instructionSet.roverView.getAssociatedRover() else {
                return
            }
            
            let movementCompletionHandler:instructionCompletionHandler = { resultantPosition in
                /*
                 In case of cardinal movements, no need to validate. Just assign the new direction and return.
                 */
                guard rover.currentPosition.location != resultantPosition.location else {
                    //track directional changes here
                    rover.currentPosition = resultantPosition
                    (self.presenter as! RoverPresenter).handleValidationSuccess(rover: rover, resultantPosition: resultantPosition)
                    return
                }
                self.validateInstructionResult(currentRover: rover, rovers: rovers , nextPosition: resultantPosition, plateauBounds: bounds)
            }
            
            for instruction in instructionSet.instructions {
                roverInstructionProcessor.predictMovementResult(of: instruction, moveable: rover, completion:movementCompletionHandler)
            }
            
        }
    }
    
    
    /*
     Function to validate instruction prediction and validate the resultant position against collision and
     out of bounds exceptions. Redirect to presenter to update the UI.
     */
    internal func validateInstructionResult(currentRover:Rover, rovers:[Rover], nextPosition:Position, plateauBounds:Location) {
        
        let roverAtGivenPosition = rovers.filter({$0.currentPosition.location == nextPosition.location})
        
        guard roverAtGivenPosition.count == 0 else {
            (self.presenter as! RoverPresenter).handleValidationFailure(validationError: RoverInstructionErrors.RiskOfCollision)
            return
        }
        
        guard 0...plateauBounds.x_co_ordinate ~= nextPosition.location.x_co_ordinate &&
            0...plateauBounds.y_co_ordinate ~= nextPosition.location.y_co_ordinate else {
                
                (self.presenter as! RoverPresenter).handleValidationFailure(validationError: RoverInstructionErrors.LocationOutOfBounds)
                return
        }
        
        (self.presenter as! RoverPresenter).handleValidationSuccess(rover: currentRover, resultantPosition: nextPosition)
    }
    
}
