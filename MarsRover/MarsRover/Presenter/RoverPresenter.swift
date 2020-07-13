//
//  RoverPresenter.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

class RoverPresenter: VIPPresenter {
    var view: VIPView?
    
    init(view:VIPView) {
        self.view = view
    }
    
    func handleValidationFailure(validationError:RoverInstructionErrors)  {
        guard let view = (self.view as? RoverViewController) else {
            return
        }
        
        var errorMessage:String?
        
        switch validationError {
            
        case .InvalidInstruction:
            let listOfSupportedInstructions = SupportedInstructions.supportedInstructionStringRepresentation().dropLast()
            errorMessage = String(format: LocalizedErrorMessage.InvalidInstructionMessage, listOfSupportedInstructions as CVarArg)
            
        case .LocationOutOfBounds:
            errorMessage = LocalizedErrorMessage.LocationOutOfBoundsMessage
            
        case .RiskOfCollision:
            errorMessage = LocalizedErrorMessage.RiskOfCollisionMessage
            
        case .UnknownErrorInstructionMessage:
            errorMessage = LocalizedErrorMessage.UnknownErrorInstructionMessage
            
        }
        
        view.displayError(errorMessage: errorMessage ?? "")
    }
    
    func handleValidationSuccess(rover:Rover, resultantPosition:Position)  {
        guard let view = (self.view as? RoverViewController) else {
            return
        }
        view.updateUIOnValidationSuccess(rover: rover, resultantPosition: resultantPosition)
    }
    
    func InstructionExecutionCompleted()  {
        guard let view = (self.view as? RoverViewController) else {
            return
        }
        view.clearInstructionText()

    }
    
    func getPlateauBounds() -> Location {
        guard let view = (self.view as? RoverViewController) else {
            return Location()
        }
        return view.plateau.traversibleBounds
    }
    
    func getRovers() -> [Rover] {
        guard let view = (self.view as? RoverViewController) else {
            return Array<Rover>()
        }
        return view.roverViews.compactMap({$0.getAssociatedRover()})
    }
}
