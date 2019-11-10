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
    @IBOutlet private weak var countryBonusField: UITextField!
    @IBOutlet private weak var ageField: UITextField!
    
    private var world: World?
    private var countriesDataManager: CountriesDataManager!
    private var namesDataManager: NamesDataManager!
    private let countryPickerView = UIPickerView()
    private var selectedCountry: Country?
    private let agePickerView = UIDatePicker()
    private var selectedDate: Date?
    
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
        configuteDateField(ageField, with: agePickerView)
    }
    
    override func setupDependencies() {
        super.setupDependencies()
        countriesDataManager = resolver.resolve(CountriesDataManager.self)
        namesDataManager = resolver.resolve(NamesDataManager.self)
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
            let countryBonus = Double(countryBonusField.text ?? ""),
            let country = selectedCountry,
            let worldIdentifier = world?.identifier,
            let birthday = selectedDate else {
                return
        }
        let ability = Ability(skill: skill,
                              serve: serve,
                              returnOfServe: returnOfServe,
                              countryBonus: countryBonus)
        dataManager.createPlayer(with: name, surname: surname, country: country, birthday: birthday, ability: ability, worldIdentifier: worldIdentifier)
            .then { [weak self] player -> Void in
                self?.world?.players.append(player)
                self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func createRandomNamePressed(_ sender: Any) {
        let playerName = namesDataManager.getRandomName()
        nameField.text = playerName.name
        surnameField.text = playerName.surname
    }
    

    
    // MARK: - Private
    
    private func configuteTextField(_ textField: UITextField, with pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        textField.inputAccessoryView = pickerToolbar
    }
    
    private func configuteDateField(_ textField: UITextField, with pickerView: UIDatePicker) {
        guard let world = world else { return }
        textField.inputAccessoryView = pickerToolbar
        pickerView.datePickerMode = .date
        pickerView.date = world.currentWorldDate
        pickerView.addTarget(self, action: #selector(datePickerChangedValue), for: .valueChanged)
        textField.inputView = pickerView
    }
    
    @objc private func countryPickerCancelled() {
        view.endEditing(true)
    }
    
    @objc private func datePickerChangedValue() {
        selectedDate = agePickerView.date
        guard let world = world else { return }
        ageField.text = "\(agePickerView.date.age(from: world.currentWorldDate))"
    }
}
