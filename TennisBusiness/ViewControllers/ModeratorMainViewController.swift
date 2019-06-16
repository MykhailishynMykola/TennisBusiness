//
//  ModeratorMainViewController.swift
//  TennisBusiness
//
//  Created by user on 6/7/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit
import PromiseKit

class ModeratorMainViewController: ScreenViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Inner
    
    private struct Constants {
        static let worldCellReuseIdentifier = "worldCell"
    }
    
    
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var worlds: [World] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getWorlds().then { [weak self] worlds in
            self?.worlds = worlds
        }
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worlds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.worldCellReuseIdentifier) as? WorldTableViewCell,
            worlds.indices.contains(indexPath.row) else {
                return UITableViewCell()
        }
        let world = worlds[indexPath.row]
        cell.update(with: world)
        return cell
    }
    
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard worlds.indices.contains(indexPath.row) else {
            return
        }
        let selectedWorld = worlds[indexPath.row]
        guard let worldController = presentViewController(withIdentifier: "ModeratorWorld", fromNavigation: true) as? WorldViewController else {
            return
        }
        worldController.update(with: selectedWorld)
    }
}
