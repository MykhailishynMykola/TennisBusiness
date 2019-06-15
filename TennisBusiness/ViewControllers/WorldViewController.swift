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
        createdAtLabel.text = "Created at: \(world.createdAt)"
        updateCurrentTime()
        timer = Timer.every(1) { [weak self] in
            self?.updateCurrentTime()
        }
    }
    
    
    
    // MARK: - Public
    
    func update(with world: World) {
        self.world = world
    }
    
    private func updateCurrentTime() {
        guard let world = world else { return }
        currentTimeLabel.text = "Time: \(world.currentWorldDate)"
    }
}
