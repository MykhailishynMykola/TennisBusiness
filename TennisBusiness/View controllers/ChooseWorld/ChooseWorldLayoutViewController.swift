//
//  ChooseWorldLayoutViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

class ChooseWorldLayoutViewController: UIViewController, ChooseWorldLayoutController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Inner types
    
    private struct Constants {
        static var chooseWorldCellReuseIdentifier = "chooseWorldCell"
    }
    
    
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableHeaderView: UIView!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var tableHeaderNameLabel: UILabel!
    @IBOutlet private weak var tableHeaderSpeedLabel: UILabel!
    @IBOutlet private weak var tableHeaderCreatedAtLabel: UILabel!
    
    private var tableHeaderViewBottomMask: CAShapeLayer?
    private var labels: [UILabel] {
        return [tableHeaderNameLabel,
                tableHeaderSpeedLabel,
                tableHeaderCreatedAtLabel]
    }
    
    
    // MARK: - ChooseWorldLayoutController
    
    var delegate: ChooseWorldLayoutControllerDelegate?
    var worlds: [World] = [] {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.borderWidth = 3
        tableView.layer.borderColor = UIColor.primary.cgColor
        tableView.layer.cornerRadius = 20
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: tableHeaderView.frame.height, left: 0, bottom: 0, right: 0)
        tableHeaderView.backgroundColor = .primary
        tableHeaderViewBottomMask = tableHeaderView.round(corners: [.topLeft, .topRight], radius: 20)
        labels.forEach {
            $0.font = UIFont(name: "OpenSans-Bold", size: 18)
            $0.textColor = .white
        }
        tableHeaderNameLabel.text = localized("KEY_TABLE_HEADER_WORLD_NAME")
        tableHeaderSpeedLabel.text = localized("KEY_TABLE_HEADER_WORLD_SPEED")
        tableHeaderCreatedAtLabel.text = localized("KEY_TABLE_HEADER_WORLD_CREATED_AT")
        continueButton.configureButton(backgroundColor: .primary, titleColor: .title, title: localized("KEY_START"), cornerRadius: 20)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard DeviceInfo.isTablet else { return }
        tableHeaderViewBottomMask?.removeFromSuperlayer()
        tableHeaderViewBottomMask = tableHeaderView.round(corners: [.topLeft, .topRight], radius: 20)
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worlds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.chooseWorldCellReuseIdentifier) as? ChooseWorldTableViewCell,
            worlds.indices.contains(indexPath.row) else {
                return UITableViewCell()
        }
        let world = worlds[indexPath.row]
        cell.update(with: world)
        return cell
    }
}
