//
//  ModeratorPlayersListViewController.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 8/18/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ModeratorPlayersListViewController: ScreenViewController {
    // MARK: - Inner
    
    private struct Constants {
        static let playerCellReuseIdentifier = "playerCell"
    }

    
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var players: [Player] = [] {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    private var world: World?
    
    
    
    // MARK: - Public
    
    func update(with players: [Player], world: World) {
        self.players = players
        self.world = world
    }
}

// MARK: - UITableViewDataSource

extension ModeratorPlayersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.playerCellReuseIdentifier) as? ModeratorPlayerTableViewCell,
            players.indices.contains(indexPath.row) else {
                return UITableViewCell()
        }
        let player = players[indexPath.row]
        cell.update(with: player, date: world?.currentWorldDate)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ModeratorPlayersListViewController: UITableViewDelegate {
    
}
