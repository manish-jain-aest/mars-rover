//
//  ViewController.swift
//  MarsRover
//
//  Created by Jain, Manish on 03/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import UIKit

class RoverViewController: UIViewController, VIPView {
    
    var interactor: VIPInteractor?
    
    var roverViews:[CircularRoverView] = [CircularRoverView]()
    
    @IBOutlet weak var label_displayResults:UILabel!
    @IBOutlet weak var txt_instruction:UITextField!
    @IBOutlet weak var picker_rovers:UIPickerView!
    @IBOutlet weak var plateau:PlateauView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor = initInteractor()
    }
    
    func initInteractor () -> VIPInteractor {
        return RoverInteractor(presenter: RoverPresenter(view: self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPlateauBounds()
        roverViews = plotRovers()
    }
    
    /*
     Function to set the bounds of the plateau.
     */
    //Note: Hardcoded bounds based on test input. Should be taken as user input.
    internal func setPlateauBounds() {
        plateau.traversibleBounds = Location(x_co_ordinate:5, y_co_ordinate:5)
        plateau.setNeedsLayout()
        plateau.layoutIfNeeded()
    }
    
    /*
     Function to plot the rover views on the plateau
     */
    internal func plotRovers() -> [CircularRoverView] {
        
        let rovers =  (self.interactor as! RoverInteractor).createRovers()
        var roverViews = [CircularRoverView]()
        
        for opportunity in rovers {
            let opportunityView = CircularRoverView(rover:opportunity ,radius: 20)
            opportunityView.center = self.plateau.getLocationInPlateau(newLocation: opportunity.currentPosition.location)
            
            /* Temporary patch to distinguish rovers by color. Can be taken as input */
            if opportunity.name == "Opportunity" {opportunityView.roverColor = UIColor.red}
            
            self.plateau.addSubview(opportunityView)
            roverViews.append(opportunityView)
        }
        return roverViews
    }
    
    
    /*
     Function to execute the instructions.
     */
    
    @IBAction func executeInstructions(_ sender: Any) {
        
        self.dismisskeyboard()
        
        guard picker_rovers.selectedRow(inComponent: 0) > -1, let instruction = txt_instruction.text else {
            return
        }
        
        let selectedRoverView = roverViews[picker_rovers.selectedRow(inComponent: 0)]
        
        guard let selectedRover = selectedRoverView.getAssociatedRover() else {
            return
        }
        
        let interactor = (self.interactor as! RoverInteractor)
        interactor.sanitizeInstructionExecution(instructionString: instruction, rover: selectedRover, roverView: selectedRoverView)
        
    }
    
    
    internal func dismisskeyboard() {
        self.txt_instruction.endEditing(true)
    }

    
    func updateUIOnValidationSuccess(rover:Rover, resultantPosition:Position) {
        
        rover.currentPosition = resultantPosition
        let roverView = roverViews.filter({$0.getAssociatedRover() == rover})[0]
        
        DispatchQueue.main.async {
            roverView.center = self.plateau.getLocationInPlateau(newLocation: resultantPosition.location)
            self.postInstructionExecution()
            self.clearErrorMessage()
        }
        sleep(1)
    }
    
    internal func postInstructionExecution() {
        DispatchQueue.main.async {
            self.picker_rovers.reloadAllComponents()
        }
    }
    
    internal func clearInstructionText() {
        DispatchQueue.main.async {
            self.txt_instruction.text = nil
        }
    }
    
    internal func clearErrorMessage() {
        DispatchQueue.main.async {
            self.label_displayResults.text = nil
        }
    }
    
    internal func displayError(errorMessage:String) {
        
        DispatchQueue.main.async {
            self.label_displayResults.text = errorMessage
        }
    }
}

extension RoverViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismisskeyboard()
        return true
    }
}

extension RoverViewController:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.roverViews.count
    }
}

extension RoverViewController:UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row < roverViews.count else {
            return nil
        }
        return roverViews[row].getAssociatedRover()?.description
    }
}
