//
//  Constants.swift
//  MarsRovers
//
//  Created by Jain, Manish on 05/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

typealias instructionCompletionHandler = (_ resultantPosition: Position) -> Void


internal func LocalizedString(_ keyName:String, moduleName:String,comment:String) -> String {
    return NSLocalizedString(keyName, tableName: moduleName, bundle: Bundle.main, value: "", comment: comment)
}

struct LocalizedErrorMessage {
    static let InvalidInstructionMessage = LocalizedString("InvalidInstruction", moduleName: "ErrorMessages", comment: "")
    static let RiskOfCollisionMessage = LocalizedString("RiskOfCollision", moduleName: "ErrorMessages", comment: "")
    static let LocationOutOfBoundsMessage = LocalizedString("LocationOutOfBounds", moduleName: "ErrorMessages", comment: "")
    static let UnknownErrorInstructionMessage = LocalizedString("UnknownErrorInstructionMessage", moduleName: "ErrorMessages", comment: "")
}
