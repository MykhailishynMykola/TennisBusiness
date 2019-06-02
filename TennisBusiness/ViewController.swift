//
//  ViewController.swift
//  TennisBusiness
//
//  Created by user on 6/1/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var worlds: [World] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testPlayer1 = Player(identifier: "1",
                                 name: "R. Nadal",
                                 ability: Ability(skill: AbilityValue(value: 4),
                                                  serve: AbilityValue(value: 1),
                                                  returnOfServe: AbilityValue(value: 2)))
        let testPlayer2 = Player(identifier: "2",
                                 name: "R. Federer",
                                 ability: Ability(skill: AbilityValue(value: 4),
                                                  serve: AbilityValue(value: 1),
                                                  returnOfServe: AbilityValue(value: 2)))
        let testMatch = Match(identifier: 1, firstPlayer: testPlayer1, secondPlayer: testPlayer2, setsToWin: 3)
        let testWorld = World()
        testWorld.add(matches: [testMatch])
        worlds.append(testWorld)
    }
}

