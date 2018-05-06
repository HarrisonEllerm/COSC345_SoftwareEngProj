//
//  GenderEntryCell.swift
//  MPM-Sft-Eng-Proj
//
//  Created by Harrison Ellerm on 3/05/18.
//  Copyright © 2018 Harrison Ellerm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class GenderEntryCell: UITableViewCell,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    let options = ["Select", "Male", "Female", "Other"]
    var textFieldName: String?
    var textFieldValue: String?
    var delegate: GenderEntryCellDelegate?

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font.fontName, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor.blue
        tf.backgroundColor = UIColor.white
        //gets rid of cursor
        tf.tintColor = UIColor.clear
        return tf
    }()
    
    let gp = UIPickerView()
    
    let inputAccessoryToolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        return toolBar
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        gp.delegate = self
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        inputAccessoryToolbar.setItems([ spaceButton, doneButton], animated: false)
        textField.inputView = gp
        textField.inputAccessoryView = inputAccessoryToolbar
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(DateEntryCell.didSelectCell))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func doneClick() {
        self.endEditing(true)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let inputText = textField.text else { return }
        Database.database().reference().child("users").child(uid).updateChildValues(["gender": inputText])
    }
    
    func setupViews() {
        
        addSubview(nameLabel)
        addSubview(textField)
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let message = textFieldName {
            nameLabel.text = message
        }
        if let value = textFieldValue {
            textField.text = value
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row != 0) {
            textFieldValue = options[row] as String
            layoutSubviews()
        }
    }
    
}

extension GenderEntryCell {
    
    @objc func didSelectCell() {
        textField.becomeFirstResponder()
        delegate?.textFieldInCell(didSelect: self)
    }
    @objc func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text {
            delegate?.textFieldInCell(cell: self, editingChangedInTextField: text)
        }
    }
}
