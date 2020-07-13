//
//  MarsRoverTests.swift
//  MarsRoverTests
//
//  Created by Jain, Manish on 06/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import XCTest
@testable import MarsRovers

class MarsRoverTests: XCTestCase {

    var mockPresenter:MockRoverPresenter?
    var roverInteractor:RoverInteractor?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockPresenter = MockRoverPresenter(view: AbstractVIPView())
        roverInteractor = RoverInteractor(presenter: mockPresenter!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSingleStepInstructionExecution() {
        
        let expectReponse = self.expectation(description: "Test rover movement")
        
        let roverInstructionProcessor = RoverInstructionProcessor.sharedInstance
        
        /* createRovers returns the test input for rovers. i.e rover (Opportunity) with position (1,2),N and rover (Spirit) with position (3,3),E */
        let rovers = roverInteractor?.createRovers()
        let Opportunity = rovers![0]
        let roverView = CircularRoverView(rover: Opportunity, radius: 20)
        let plateauBounds = Location(x_co_ordinate: 5, y_co_ordinate: 5)
        
        let instructionsString = "M"
        let instructionParser = RoverInstructionParser(instructable: Opportunity)
        let instructions = try! roverInteractor?.parseInstructions(using: instructionParser, instructionString: instructionsString, rover: Opportunity)
        let instructionRoverMapper = RoverInstructionMapper(roverView: roverView, instructions: instructions!)
        
        mockPresenter?.instructionCompletionBlock = {(rover, resultantPosition)->Void in
            XCTAssertTrue((self.mockPresenter?.validationSuccess)!)
            XCTAssertEqual(resultantPosition.location, Location(x_co_ordinate: 1, y_co_ordinate: 3))
            expectReponse.fulfill()
        }
        
        mockPresenter?.completionBlock = {(rover) -> Void in
            XCTAssertTrue((self.mockPresenter?.validationSuccess)!)
        }
        
        roverInteractor?.dispatchInstructions(using: roverInstructionProcessor, instructionRoverMapper, rovers: rovers!, bounds:plateauBounds)
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCompleteMovementSampleInput1()  {
        let expectReponse = self.expectation(description: "Test Opportunity(1,2),N movement")
        
        let roverInstructionProcessor = RoverInstructionProcessor.sharedInstance
        
        /* createRovers returns the test input for rovers. i.e rover (Opportunity) with position (1,2),N and rover (Spirit) with position (3,3),E */
        let rovers = roverInteractor?.createRovers()
        let Opportunity = rovers![0]
        let roverView = CircularRoverView(rover: Opportunity, radius: 20)
        let plateauBounds = Location(x_co_ordinate: 5, y_co_ordinate: 5)
        
        /* Test input to be applied to rover1 (Opportunity) */
        let instructionsString = "LMLMLMLMM"
        let instructionParser = RoverInstructionParser(instructable: Opportunity)
        let instructions = try! roverInteractor?.parseInstructions(using: instructionParser, instructionString: instructionsString, rover: Opportunity)
        let instructionRoverMapper = RoverInstructionMapper(roverView: roverView, instructions: instructions!)
        
        mockPresenter?.instructionCompletionBlock = {(rover, resultantPosition)->Void in
            XCTAssertTrue((self.mockPresenter?.validationSuccess)!)
        }
        
        mockPresenter?.completionBlock = {(rover) -> Void in
            XCTAssertEqual(rover?.currentPosition, Position(location: Location(x_co_ordinate: 1, y_co_ordinate: 3), cardinalPosition:CardinalPosition(direction: "N")))
            expectReponse.fulfill()
        }
        roverInteractor?.dispatchInstructions(using: roverInstructionProcessor, instructionRoverMapper, rovers: rovers!, bounds:plateauBounds)
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCompleteMovementSampleInput2()  {
        let expectReponse = self.expectation(description: "Test Spirit (3,3),E movement")
        
        let roverInstructionProcessor = RoverInstructionProcessor.sharedInstance
        
        /* createRovers returns the test input for rovers. i.e rover (Opportunity) with position (1,2),N and rover (Spirit) with position (3,3),E */
        let rovers = roverInteractor?.createRovers()
        let Spirit = rovers![1]
        let roverView = CircularRoverView(rover: Spirit, radius: 20)
        let plateauBounds = Location(x_co_ordinate: 5, y_co_ordinate: 5)
        
        /* Test input to be applied to rover2 (Spirit) */
        let instructionsString = "MMRMMRMRRM"
        let instructionParser = RoverInstructionParser(instructable: Spirit)
        let instructions = try! roverInteractor?.parseInstructions(using: instructionParser, instructionString: instructionsString, rover: Spirit)
        let instructionRoverMapper = RoverInstructionMapper(roverView: roverView, instructions: instructions!)
        
        mockPresenter?.instructionCompletionBlock = {(rover, resultantPosition)->Void in
            XCTAssertTrue((self.mockPresenter?.validationSuccess)!)
        }
        
        mockPresenter?.completionBlock = {(rover) -> Void in
            XCTAssertEqual(rover?.currentPosition, Position(location: Location(x_co_ordinate: 5, y_co_ordinate: 1), cardinalPosition:CardinalPosition(direction: "E")))
            expectReponse.fulfill()
        }
        roverInteractor?.dispatchInstructions(using: roverInstructionProcessor, instructionRoverMapper, rovers: rovers!, bounds:plateauBounds)
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidInstructionException() {
        
        let expectReponse = self.expectation(description: "Test Instruction validity")
        let rovers = roverInteractor?.createRovers()
        let Spirit = rovers![1]
        let instructionsString = "LMLMXRMM"
        let instructionParser = RoverInstructionParser(instructable: Spirit)
        
        
        XCTAssertThrowsError(try roverInteractor?.parseInstructions(using: instructionParser, instructionString: instructionsString, rover: Spirit)) { error in
            XCTAssertEqual(error as! RoverInstructionErrors, RoverInstructionErrors.InvalidInstruction)
            expectReponse.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAvoidRoverCollision() {
        let expectReponse = self.expectation(description: "Test Rover collision")

        let roverController = RoverController()
        
        /* Rover with current positon (1,1) with plateau bounds (5,5) */
        let Opportunity = MissionLauncher.sharedInstance.createRover(roverName: "Opportunity", initialPosition: Position(location: Location(x_co_ordinate: 1, y_co_ordinate: 1), cardinalPosition: CardinalPosition.init(direction: "N")), roverController: roverController)
        
        /* Rover with current positon (1,2) with plateau bounds (5,5) */
        let Spirit = MissionLauncher.sharedInstance.createRover(roverName: "Opportunity", initialPosition: Position(location: Location(x_co_ordinate: 1, y_co_ordinate: 2), cardinalPosition: CardinalPosition.init(direction: "N")), roverController: roverController)
        
        let instructionsString = "M"
        let instructionParser = RoverInstructionParser(instructable: Opportunity)
        let instructions = try! roverInteractor?.parseInstructions(using: instructionParser, instructionString: instructionsString, rover: Spirit)
        let roverInstructionProcessor = RoverInstructionProcessor.sharedInstance
        
        let roverView =  CircularRoverView(rover: Opportunity, radius: 20)
        let roverInstructionMapper = RoverInstructionMapper(roverView: roverView, instructions: instructions!)
        
        mockPresenter?.completionBlock = {(rover) -> Void in
            XCTAssertEqual(rover?.currentPosition.location, Location(x_co_ordinate: 1, y_co_ordinate: 1))
        }
        
        mockPresenter?.failureBlock = {(error)->Void in
            XCTAssertEqual(error, RoverInstructionErrors.RiskOfCollision)
            expectReponse.fulfill()
        }
        
        roverInteractor?.dispatchInstructions(using: roverInstructionProcessor, roverInstructionMapper, rovers: [Opportunity,Spirit], bounds: Location(x_co_ordinate: 5, y_co_ordinate: 5))
        
        self.waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testAvoidRoverMovementOutOfPlateau() {
        let expectReponse = self.expectation(description: "Test Rover going out of plateau bounds")
        
        let roverController = RoverController()
        
        /* Rover with current positon (1,4) with plateau bounds (5,5) */
        let Opportunity = MissionLauncher.sharedInstance.createRover(roverName: "Opportunity", initialPosition: Position(location: Location(x_co_ordinate: 1, y_co_ordinate: 5), cardinalPosition: CardinalPosition.init(direction: "N")), roverController: roverController)
        let Spirit = MissionLauncher.sharedInstance.createRover(roverName: "Opportunity", initialPosition: Position(location: Location(x_co_ordinate: 1, y_co_ordinate: 2), cardinalPosition: CardinalPosition.init(direction: "N")), roverController: roverController)
        
        let instructionsString = "M"
        let instructionParser = RoverInstructionParser(instructable: Opportunity)
        let instructions = try! roverInteractor?.parseInstructions(using: instructionParser, instructionString: instructionsString, rover: Spirit)
        let roverInstructionProcessor = RoverInstructionProcessor.sharedInstance
        
        let roverView =  CircularRoverView(rover: Opportunity, radius: 20)
        let roverInstructionMapper = RoverInstructionMapper(roverView: roverView, instructions: instructions!)
        
        mockPresenter?.completionBlock = {(rover) -> Void in
            XCTAssertEqual(rover?.currentPosition.location, Location(x_co_ordinate: 1, y_co_ordinate: 5))
        }
        
        mockPresenter?.failureBlock = {(error)->Void in
            XCTAssertEqual(error, RoverInstructionErrors.LocationOutOfBounds)
            expectReponse.fulfill()
        }
        
        roverInteractor?.dispatchInstructions(using: roverInstructionProcessor, roverInstructionMapper, rovers: [Opportunity,Spirit], bounds: Location(x_co_ordinate: 5, y_co_ordinate: 5))
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
}
