//
//  TransactionViewController.swift
//  Wallet
//
//  Created by Артём Шайтер on 11/30/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit
import os.log

class TransactionViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var byn: UITextField!
    @IBOutlet weak var transactionCategory: UITextField!
    @IBOutlet weak var transactionType: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var transaction: Transaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        byn.delegate = self
        transactionCategory.delegate = self
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        //navigationItem.title = textField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transactionCategory.endEditing(true)
        byn.endEditing(true)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        var byn = Float(self.byn.text ?? "0") ?? 0.0
        let transactionCategory = self.transactionCategory.text ?? ""
        let transactionType = self.transactionType.selectedSegmentIndex
        if transactionType == 1 {
            byn = -byn
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: Date())
        transaction = Transaction(byn: byn, date: date, transactionCategory: transactionCategory, transactionType: transactionType)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let byn = self.byn.text ?? ""
        let transactionCategory = self.transactionCategory.text ?? ""
        saveButton.isEnabled = !byn.isEmpty && !transactionCategory.isEmpty
    }
    
}

