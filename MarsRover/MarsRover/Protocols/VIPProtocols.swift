//
//  VIPProtocols.swift
//  MarsRovers
//
//  Created by Jain, Manish on 04/07/19.
//  Copyright © 2019 Jain, Manish. All rights reserved.
//

import Foundation

protocol VIPView: AnyObject {
    
    var interactor:VIPInteractor? { get set }
}

protocol VIPInteractor: AnyObject {
    
    var presenter:VIPPresenter? { get set }
}


protocol VIPPresenter: AnyObject {
    
    var view:VIPView? { get set }
}
