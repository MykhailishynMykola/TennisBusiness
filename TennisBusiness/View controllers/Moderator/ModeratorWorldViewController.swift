//
//  ModeratorWorldViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/12/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ModeratorWorldViewController: ScreenViewController {
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
        guard let createMatchController = presentViewController(withIdentifier: "ModeratorCreateMatch", fromNavigation: true) as? ModeratorCreateMatchViewController,
            let world = world else {
                return
        }
        createMatchController.update(with: world)
    }
    
    @IBAction private func createPlayerPressed(_ sender: Any) {
        guard let createPlayerController = presentViewController(withIdentifier: "ModeratorCreatePlayer", fromNavigation: true) as? ModeratorCreatePlayerViewController,
            let world = world else {
            return
        }
        createPlayerController.update(with: world)
    }
    
    @IBAction private func viewPlayersPressed(_ sender: Any) {
        guard let playersListViewController = presentViewController(withIdentifier: "ModeratorPlayersList", fromNavigation: true) as? ModeratorPlayersListViewController,
            let players = world?.players,
            let world = world else {
                return
        }
        playersListViewController.update(with: players, world: world)
    }
    
    @IBAction private func viewMatchesPressed(_ sender: Any) {
        guard let matchesListViewController = presentViewController(withIdentifier: "ModeratorMatchesList", fromNavigation: true) as? ModeratorMatchesListViewController,
            let matches = world?.matches else {
                return
        }
        matchesListViewController.update(with: matches)
    }
}
