//
//  WorldViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/12/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class WorldViewController: ScreenViewController {
    // MARK: - Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    
    private var world: World?
    private var timer: Timer?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let world = world else { return }
        nameLabel.text = "Name: \(world.name)"
        speedLabel.text = "Speed: \(world.speed)"
        createdAtLabel.text = "Created at: \(world.createdAt.stringWithSeconds())"
        updateCurrentTime()
        timer = Timer.every(1) { [weak self] in
            self?.updateCurrentTime()
        }
    }
    
    
    
    // MARK: - Public
    
    func update(with world: World) {
        self.world = world
    }
    
    
    
    // MARK: - Private
    
    private func updateCurrentTime() {
        guard let world = world else { return }
        currentTimeLabel.text = "Time: \(world.currentWorldDate.stringWithSeconds())"
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func createMatchPressed(_ sender: Any) {
        guard let createMatchController = presentViewController(withIdentifier: "CreateMatch", fromNavigation: true) as? CreateMatchScreenViewController,
            let world = world else {
                return
        }
        createMatchController.update(with: world)
    }
    
    @IBAction private func createPlayerPressed(_ sender: Any) {
        guard let createPlayerController = presentViewController(withIdentifier: "CreatePlayer", fromNavigation: true) as? CreatePlayerScreenViewController,
            let world = world else {
            return
        }
        createPlayerController.update(with: world)
    }
    
    @IBAction private func viewPlayersPressed(_ sender: Any) {
        guard let playersListViewController = presentViewController(withIdentifier: "PlayersList", fromNavigation: true) as? PlayersListViewController,
            let players = world?.players else {
                return
        }
        playersListViewController.update(with: players)
    }
    
    @IBAction func viewMatchesPressed(_ sender: Any) {
        guard let matchesListViewController = presentViewController(withIdentifier: "MatchesList", fromNavigation: true) as? MatchesListViewController,
            let matches = world?.matches else {
                return
        }
        matchesListViewController.update(with: matches)
    }
}
