//
//  CreateMatchScreenViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 7/6/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class CreateMatchScreenViewController: ScreenViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var firstPlayerTextField: UITextField!
    @IBOutlet private weak var secondPlayerTextField: UITextField!
    @IBOutlet private weak var setsToWinTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    
    private let firstPlayerPickerView = UIPickerView()
    private let secondPlayerPickerView = UIPickerView()
    private let setsToWinPickerView = UIPickerView()
    private let datePickerView = UIDatePicker()
    
    private var world: World?
    private var timer: Timer?
    private var selected: (firstPlayer: Player?, secondPlayer: Player?, setsToWin: Int?, date: Date?) = (nil, nil, nil, nil)
    
    private var datePickerToolbar: UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(datePickerCancelled))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        return toolbar
    }
    
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        configuteTextField(firstPlayerTextField, with: firstPlayerPickerView)
        configuteTextField(secondPlayerTextField, with: secondPlayerPickerView)
        configuteTextField(setsToWinTextField, with: setsToWinPickerView)
        configuteDateField(dateTextField, with: datePickerView)
    
        timer = Timer.every(1) { [weak self] in
            self?.updateCurrentTime()
        }
    }
    
    
    
    // MARK: - Public
    
    func update(with world: World) {
        self.world = world
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    private func getSource(by pickerView: UIPickerView) -> [Any] {
        guard let players = world?.players else { return [] }
        if [firstPlayerTextField.inputView, secondPlayerTextField.inputView].contains(pickerView) {
            return players
        }
        else if setsToWinTextField.inputView == pickerView {
            return GlobalConstants.setsToWinTypes
        }
        return []
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getSource(by: pickerView).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let source = getSource(by: pickerView)
        guard source.indices.contains(row) else { return nil }
        if let players = source as? [Player] {
            return players[row].name
        }
        else if let strings = source as? [Int] {
            return "\(strings[row])"
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if firstPlayerTextField.inputView == pickerView {
            firstPlayerTextField.text = world?.players[row].name
            selected = (world?.players[row], selected.secondPlayer, selected.setsToWin, selected.date)
        }
        else if secondPlayerTextField.inputView == pickerView {
            secondPlayerTextField.text = world?.players[row].name
            selected = (selected.firstPlayer, world?.players[row], selected.setsToWin, selected.date)
        }
        else if setsToWinTextField.inputView == pickerView {
            let setsToWin = GlobalConstants.setsToWinTypes[row]
            setsToWinTextField.text = "\(setsToWin)"
            selected = (selected.firstPlayer, selected.secondPlayer, setsToWin, selected.date)
        }
    }
    
    
    
    // MARK: - Private
    
    private func updateCurrentTime() {
        guard let world = world else { return }
        currentTimeLabel.text = "Time: \(world.currentWorldDate.stringWithSeconds())"
        if selected.date == nil {
            datePickerView.minimumDate = world.currentWorldDate
            datePickerView.date = world.currentWorldDate
        }
    }
    
    private func configuteTextField(_ textField: UITextField, with pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
    }
    
    private func configuteDateField(_ textField: UITextField, with pickerView: UIDatePicker) {
        textField.inputAccessoryView = datePickerToolbar
        pickerView.datePickerMode = .dateAndTime
        pickerView.addTarget(self, action: #selector(datePickerChangedValue), for: .valueChanged)
        textField.inputView = pickerView
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func createMatchPressed(_ sender: Any) {
        guard let firstPlayer = selected.firstPlayer,
            let secondPlayer = selected.secondPlayer,
            let setsToWin = selected.setsToWin,
            let date = selected.date,
            let worldIdentifier = world?.identifier else {
                return
        }
        dataManager.createMatch(firstPlayer: firstPlayer, secondPlayer: secondPlayer, setsToWin: setsToWin, date: date, worldIdentifier: worldIdentifier)
            .then { [weak self] match -> Void in
                self?.world?.matches.append(match)
                self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func datePickerDone() {
        guard let datePicker = dateTextField.inputView as? UIDatePicker else {
            return
        }
        dateTextField.text = datePicker.date.stringWithSeconds()
        view.endEditing(true)
    }
    
    @objc private func datePickerCancelled() {
        view.endEditing(true)
    }
    
    @objc private func datePickerChangedValue() {
        selected = (selected.firstPlayer, selected.secondPlayer, selected.setsToWin, datePickerView.date)
    }
}
