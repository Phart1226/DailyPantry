//
//  SettingsCell.swift
//  SettingsTemplate
//
//  Created by Stephen Dowless on 2/10/19.
//  Copyright © 2019 Stephan Dowless. All rights reserved.
//
import UIKit

var isFancyFont = false

class SettingsCell: UITableViewCell {

    var switchLabel = ""
    // MARK: - Properties
    var sectionType: SectionType? {
        didSet{
            guard let sectionType = sectionType else {return}
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
        }
    }

    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = .systemOrange
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        return switchControl

    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleSwitchAction(sender: UISwitch){

        // add functionality to switch to dark mode, change font style, ect
        if sender.isOn{
            if self.switchLabel == "Dark Mode" {
                let darkModeOn = true

                UserDefaults.standard.set(darkModeOn, forKey: UIStyleManager.uiStyleDarkModeOn)

                        // Update interface style
                UIStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
            }
            if self.switchLabel == "Stylistic Font" {
                self.textLabel?.font  = UIFont(name: "Papyrus", size: 18)
                fontStyle = "Papyrus"
                isFancyFont = true
            }
            print("turned on")
        }else{
            if self.switchLabel == "Dark Mode" {
                let darkModeOn = false

                UserDefaults.standard.set(darkModeOn, forKey: UIStyleManager.uiStyleDarkModeOn)

                        // Update interface style
                UIStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
            }
            if self.switchLabel == "Stylistic Font" {
                fontStyle = "Verdana-Bold"
                self.textLabel?.font  = UIFont(name: fontStyle, size: 18)
                isFancyFont = false
            }
            print("turned off")
        }
    }
}
