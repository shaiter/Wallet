//
//  LoginViewController.swift
//  Wallet
//
//  Created by Артём Шайтер on 12/14/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorFiled: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginField.delegate = self
        passField.delegate = self
        updateButtonsState()
        errorFiled.isHidden = true
        loadLastUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLastUser() {
        let defaults = UserDefaults.standard
        if let lastUser = defaults.string(forKey: Transaction.lastUser) {
            if lastUser != "lastUser" {
                Transaction.userName = lastUser
                let index = lastUser.index(of: "_") ?? lastUser.endIndex
                loginField.text = String(lastUser[..<index])
                passField.text = String(lastUser[lastUser.index(after: index)..<lastUser.endIndex])
                logInButton.isEnabled = true
            }
        }
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        var documentsDirectory = String(describing: FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!)
        documentsDirectory = String(documentsDirectory[documentsDirectory.index(documentsDirectory.startIndex, offsetBy: 7)..<documentsDirectory.endIndex])
        documentsDirectory += "/" + loginField.text! + "_" + passField.text!
        if FileManager.default.fileExists(atPath: documentsDirectory) {
            Transaction.userName = loginField.text! + "_" + passField.text!
            let defaults = UserDefaults.standard
            defaults.set(Transaction.userName, forKey: Transaction.lastUser)
            self.performSegue(withIdentifier: "MainToAllTransactions", sender: self)
        } else {
            errorFiled.isHidden = false
            errorFiled.text = "Неверный логин или пароль"
        }
        
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        var documentsDirectory = String(describing: FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!)
        documentsDirectory = String(documentsDirectory[documentsDirectory.index(documentsDirectory.startIndex, offsetBy: 7)..<documentsDirectory.endIndex])
        var files = [String]()
        do {
            files = try FileManager.default.subpathsOfDirectory(atPath: documentsDirectory)
        } catch  {
            print("Finding files error")
        }
        var fileIsExist = false
        for file in files {
            let index = file.index(of: "_") ?? file.endIndex
            if loginField.text == String(file[..<index]) {
                fileIsExist = true
                errorFiled.isHidden = false
                errorFiled.text = "Такой логин существует"
            }
        }
        if !fileIsExist {
            Transaction.userName = loginField.text! + "_" + passField.text!
            self.performSegue(withIdentifier: "MainToAllTransactions", sender: self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonsState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorFiled.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginField.endEditing(true)
        passField.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func updateButtonsState() {
        // Disable the Save button if the text field is empty.
        let login = self.loginField.text ?? ""
        let pass = self.passField.text ?? ""
        logInButton.isEnabled = !login.isEmpty && !pass.isEmpty
        signInButton.isEnabled = !login.isEmpty && !pass.isEmpty
    }
    
    @IBAction func AllTransactionsToMain(sender: UIStoryboardSegue) {
        loginField.text = ""
        passField.text = ""
        logInButton.isEnabled = false
        signInButton.isEnabled = false
        let defaults = UserDefaults.standard
        defaults.set("lastUser", forKey: Transaction.lastUser)
    }

}
