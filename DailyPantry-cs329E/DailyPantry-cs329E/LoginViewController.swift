//
//  ViewController.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 10/14/22.
//

import UIKit
import FirebaseAuth

var currentUser = ""

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordText.isSecureTextEntry = true
        
        startObserving(&UIStyleManager.shared)

//        Auth.auth().addStateDidChangeListener() {
//            auth, user in
//            if user != nil {
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
//                self.emailText.text = nil
//                self.passwordText.text = nil
//            }
//        }
    }
    
    // stop screen from rotating into landscape mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    

    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) {
            authResult, error in
            if let error = error as NSError? {
                self.errorLabel.text = "\(error.localizedDescription)"
            } else {
                self.errorLabel.text = ""
                currentUser = self.emailText.text!
                self.performSegue(withIdentifier: "login", sender: Any?.self)
                
            }
        }
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let alert = UIAlertController(title: "Create an Account",
                                      message: "Register",
                                      preferredStyle: .alert)
        alert.addTextField() {
            tfEmail in
            tfEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField() {
            tfPassword in
            tfPassword.isSecureTextEntry = true
            tfPassword.placeholder = "Enter your password"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            _ in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                authResult, error in
                if let error = error as NSError? {
                    self.errorLabel.text = "\(error.localizedDescription)"
                } else {
                    self.errorLabel.text = ""
                    currentUser = emailField.text!
                    self.performSegue(withIdentifier: "login", sender: Any?.self)
                }
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
}

