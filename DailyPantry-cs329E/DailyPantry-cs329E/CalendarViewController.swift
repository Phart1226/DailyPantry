//
//  CalenderViewController.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 10/21/22.
//

import UIKit
import FSCalendar
import CoreData

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource{
    
    var calendar:FSCalendar!
    var formatter = DateFormatter()
    var recipes = ["03-Nov-2022":"Chicken Parm", "04-Nov-2022":"Chicken Alfredo", "05-Nov-2022":"Pizza", "06-Nov-2022":"Soup"]
    var dateSelected = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up calendar
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 100.0, width: self.view.frame.size.width, height: 500.0))
        calendar.scrollDirection = .vertical
        calendar.scope = .week
        self.view.addSubview(calendar)
        
        calendar.delegate = self
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Calendar style
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 25)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 20)
        
        calendar.appearance.headerTitleColor = UIColor.systemOrange
        calendar.appearance.weekdayTextColor = UIColor.systemOrange
        
        // setting selected date to current day
        formatter.dateFormat = "dd-MMM-YYYY"
        dateSelected = formatter.string(from: Date())
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-YYYY"
        
        // grab date selected by user
        dateSelected = formatter.string(from: date)
        tableView.reloadData()
    }
    
    // showing dots undernieth date for events
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
          formatter.dateFormat = "dd-MM-yyyy"
            guard let eventDate = formatter.date(from:"04-11-2022") else{return 0}
        if date.compare(eventDate) == .orderedSame{
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // placeholder for table view data
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        cell.textLabel?.text = recipes[dateSelected]
        return cell
    }

}
