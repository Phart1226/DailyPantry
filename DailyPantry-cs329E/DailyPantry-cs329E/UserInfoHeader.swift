//
//  UserInfoHeader.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//

import UIKit
import CoreData

class UserInfoHeader: UIView {

    
    // MARK: - Properties
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = currentUser
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profileImageDimension: CGFloat = 60
        
        if currentUser != ""{
        
            let user = setUser()
            
            addSubview(profileImageView)
            profileImageView.image = UIImage(data:(user.value(forKey: "profilePic")! as! Data))
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
            profileImageView.layer.cornerRadius = profileImageDimension / 2
            
            addSubview(usernameLabel)
            usernameLabel.text = user.value(forKey: "name") as! String
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
            usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
            
            addSubview(emailLabel)
            emailLabel.text = currentUser
            emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
            emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
            
        }
        

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}
