//
//  TextField.swift
//  TennisBusiness
//
//  Created by Valeiia Tarasenko on 1/12/20.
//  Copyright © 2020 nikolay.mihailishin. All rights reserved.
//

import UIKit

class TextField: UIView {
    // MARK: - Inner
    
    struct Constants {
        static let bottomLineInset: CGFloat = 5
    }
    
    
    
    // MARK: - Properties
    
    let textField = UITextField()
    let bottomLine = UIView()
    
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    
    // MARK: - Private
    
    private func setupView() {
        textField.attributedPlaceholder = NSAttributedString(string: "placeholder text",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)])
        textField.font = UIFont(name: "OpenSans", size: 16)
        addSubview(textField)
        addSubview(bottomLine)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLine.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.bottomLineInset).isActive = true
    }
}
