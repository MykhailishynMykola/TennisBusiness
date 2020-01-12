//
//  ChooseWorldLayoutController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

protocol ChooseWorldLayoutController {
    var delegate: ChooseWorldLayoutControllerDelegate? { get set }
    var worlds: [World] { get set }
}


protocol ChooseWorldLayoutControllerDelegate: class {
    
}
