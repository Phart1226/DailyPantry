//
//  SettingsViewController.swift
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//
import UIKit
import Foundation
import FirebaseAuth
import CoreData
import AVFoundation

private let reuseIdentifier = "SettingsCell"

class SettingsViewController: UIViewController {

    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    let imagePicker = UIImagePickerController()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        UILabel.appearance().substituteFontName = fontStyle
        configureUI()
        startObserving(&UIStyleManager.shared)
    }

    override func viewWillAppear(_ animated: Bool) {
        UILabel.appearance().substituteFontName = fontStyle
        configureUI()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60

        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame

        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }

    func configureUI() {
        configureTableView()

//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange

        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)

        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        return view
    }
    func numberOfSections (in tableView: UITableView) -> Int{
        return SettingsSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0}

        switch section{
        case .Social: return SocialOption.allCases.count
        case .AppOptions: return AppOption.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell()}

        switch section{
        case .Social:
            let social = SocialOption(rawValue: indexPath.row)
            cell.sectionType = social
        case .AppOptions:
            let app = AppOption(rawValue: indexPath.row)
            cell.sectionType = app
            // allows switch to be interacted with
            cell.contentView.isUserInteractionEnabled = false
        }
        //THIS IS MINE
        cell.switchLabel = cell.sectionType!.description
        // set stylistic font to off for defualt setting
        if cell.sectionType!.description == "Stylistic Font"{
            cell.switchControl.isOn = isFancyFont
        }

        if cell.sectionType!.description == "Dark Mode"{
            cell.switchControl.isOn = UIStyleManager.shared.currentStyle == .dark
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }

        switch section{
        case .Social:
            let social = SocialOption(rawValue: indexPath.row)
            // add functionality to edit profile and logout
            switch indexPath.row {
            case 0:
                let controller = UIAlertController(
                    title: "Change Profile Picture",
                    message: "Select from Photo Library or take photo",
                    preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(
                    title: "Photo Library",
                    style: .default,
                    handler: { (paramAction:UIAlertAction!) in
                        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                            self.imagePicker.delegate = self
                            self.imagePicker.sourceType = .photoLibrary
                            self.imagePicker.allowsEditing = false
                            self.present(self.imagePicker, animated: true)
                            }
                    }))
                controller.addAction(UIAlertAction(
                    title: "Camera",
                    style: .default,
                    handler: { (paramAction:UIAlertAction!) in
                        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                            switch AVCaptureDevice.authorizationStatus(for: .video){
                            case .notDetermined:
                                AVCaptureDevice.requestAccess(for: .video){
                                    accessGranted in
                                    guard accessGranted == true else { return }
                                }
                            case .authorized:
                                break
                            default:
                                print("Access Denied")
                                return
                            }
                            self.imagePicker.delegate = self
                            self.imagePicker.sourceType = .camera
                            self.imagePicker.allowsEditing = false
                            self.imagePicker.cameraCaptureMode = .photo
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                        else{
                            let alertVC = UIAlertController(
                                title: "No Camera",
                                message: "Sorry, this device has no rear camera",
                                preferredStyle: .alert)
                            let okAction = UIAlertAction(
                                title: "OK",
                                style: .default)
                            alertVC.addAction(okAction)
                            self.present(alertVC, animated: true)
                        }
                    }))
                    present(controller, animated: true)
                    
            case 1:
                let controller = UIAlertController(
                    title: "Change Display Name",
                    message: "enter your new display name",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel))
                controller.addTextField(configurationHandler: {
                    (textField:UITextField!) in
                    textField.placeholder = "new name here"
                })
                controller.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { (paramAction:UIAlertAction!) in
                    if let textFieldArray = controller.textFields {
                        let textFields = textFieldArray as [UITextField]
                        let enteredText = textFields[0].text

                        dispName = enteredText!
                        
                        let user = self.setUser()
                        
                        user.setValue(dispName, forKey: "name")
                        
                        self.saveContext()

                        self.viewWillAppear(false)
                        
                        self.tableView.reloadData()
                    }
                }))
                present(controller, animated: true)
            case 2:
                let alert = UIAlertController(title: "Update Password",
                                              message: "enter your new password",
                                              preferredStyle: .alert)

                alert.addTextField() {
                    tfPassword in
                    tfPassword.isSecureTextEntry = true
                    tfPassword.placeholder = "Enter your password"
                }
                alert.addTextField() {
                    tfConfPassword in
                    tfConfPassword.isSecureTextEntry = true
                    tfConfPassword.placeholder = "Confirm password"
                }

                let saveAction = UIAlertAction(title: "Change", style: .default) {
                    _ in
                    let passwordField = alert.textFields![0]
                    let conPassField = alert.textFields![1]

                    if (passwordField.text!) == (conPassField.text!) {

                        Auth.auth().currentUser?.updatePassword(to: passwordField.text!)
                    }else{
                        let innerAlert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
                        innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                        self.present(innerAlert, animated: true, completion: nil)
                    }
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

                alert.addAction(saveAction)
                alert.addAction(cancelAction)

                present(alert, animated: true)

            case 3:
                let controller = UIAlertController(
                    title: "Log Out",
                    message: "are you sure you want to log out?",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel))
                controller.addAction(UIAlertAction(
                    title: "Log Out",
                    style: .default,
                    handler: { (paramAction:UIAlertAction!) in
                        do {
                            try Auth.auth().signOut()
                            currentUser = ""
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let secondViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(secondViewController, animated: true)

                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }))

                present(controller, animated: true)

            default:  // if none of the above apply
                let controller = UIAlertController(
                    title: "Unidentified Alert Type",
                    message: ":(",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "This should never happen?!",
                    style: .default))
                present(controller, animated: true)
            }

        case .AppOptions:
            let app = AppOption(rawValue: indexPath.row)

            if indexPath.row == 2 {
                let controller = UIAlertController(
                    title: "Clear Existing Data",
                    message: "are you sure you want to erase existing data?",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel))
                controller.addAction(UIAlertAction(
                    title: "Delete",
                    style: .destructive,
                    handler: { (paramAction:UIAlertAction!) in
                        self.cleanoutData(sheet: "SavedRecipe")
                        self.cleanoutData(sheet: "RecipeDate")
                    }))

                present(controller, animated: true)
            }
        }
    }

    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        let user = setUser()
        user.setValue(image.jpegData(compressionQuality: 1.0), forKey: "profilePic")
        saveContext()
        dismiss(animated: true)
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func cleanoutData(sheet: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // clear recipes
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredRecipe")
        var fetchedResults:[NSManagedObject]

        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]

            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
            }
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }

        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        saveContext()
        
        // clear RecipeDates
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeDate")
        fetchedResults = []

        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]

            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                }
            }
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }

        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        saveContext()
        
        // clear Ingredients
        request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredIngredient")
        fetchedResults = []
        do {
            try fetchedResults = (context.fetch(request) as? [NSManagedObject])!
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        for item in fetchedResults{
            item.setValue(0, forKey: "amountAvailable")
        }
        
        saveContext()
    }
    
    func setUser() -> NSManagedObject {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
        var fetchedResults:[NSManagedObject]? = nil

        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        // find user in core data by email
        for user in fetchedResults! {
            if (user.value(forKey: "email") as! String) == currentUser.lowercased() {
                return user
            }
        }
        return NSManagedObject()
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
