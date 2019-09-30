//
//  CreatePlayerScreenViewController.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/16/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

class CreatePlayerScreenViewController: ScreenViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Properties
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var skillField: UITextField!
    @IBOutlet private weak var serveField: UITextField!
    @IBOutlet private weak var returnField: UITextField!
    @IBOutlet private weak var surnameField: UITextField!
    @IBOutlet private weak var countryField: UITextField!
    
    private var world: World?
    private var countriesDataManager: CountriesDataManager!
    private let countryPickerView = UIPickerView()
    private var selectedCountry: Country?
    
    private var pickerToolbar: UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(countryPickerCancelled))
        toolbar.setItems([spaceButton, cancelButton], animated: false)
        return toolbar
    }
    
    
    
    // MARK: - Public
    
    func update(with world: World) {
        self.world = world
    }
    
    
    
     // MARK: - Overrides
       
    override func viewDidLoad() {
        super.viewDidLoad()
        configuteTextField(countryField, with: countryPickerView)
    }
    
    override func setupDependencies() {
        super.setupDependencies()
        countriesDataManager = resolver.resolve(CountriesDataManager.self)
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesDataManager.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard countriesDataManager.countries.indices.contains(row) else  { return "" }
        return countriesDataManager.countries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard countriesDataManager.countries.indices.contains(row) else { return }
        let country = countriesDataManager.countries[row]
        countryField.text = country.name
        selectedCountry = country
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func createPlayerPressed(_ sender: Any) {
        guard let name = nameField.text,
            let surname = surnameField.text,
            let skill = Double(skillField.text ?? ""),
            let serve = Double(serveField.text ?? ""),
            let returnOfServe = Double(returnField.text ?? ""),
            let country = selectedCountry,
            let worldIdentifier = world?.identifier else {
                return
        }
        let ability = Ability(skill: skill,
                              serve: serve,
                              returnOfServe: returnOfServe)
        dataManager.createPlayer(with: name, surname: surname, country: country, ability: ability, worldIdentifier: worldIdentifier)
            .then { [weak self] player -> Void in
                self?.world?.players.append(player)
                self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Private
    private func configuteTextField(_ textField: UITextField, with pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        textField.inputAccessoryView = pickerToolbar
    }
    
    @objc private func countryPickerCancelled() {
        view.endEditing(true)
    }
}
