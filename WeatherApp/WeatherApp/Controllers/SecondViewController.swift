//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Евгений Клебан on 6/21/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit

class SeconViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var weatherItems: [WeatherItem] = []
    private let heightOfTableViewCell: CGFloat = 100

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weatherItems = DataManager.getCurrentArray()
        if weatherItems.count == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let time = weatherItems[indexPath.row].time
        let timezone = weatherItems[indexPath.row].timezone
        
        let  date = Date(timeIntervalSince1970: Double(time))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        cell.dateLabel.text = "Date: \(localDate)"
        cell.placeLabel.text = "Place: \(timezone)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController
        vc?.item = weatherItems[indexPath.row]
       
        self.present(vc!, animated: true, completion: nil)
        
        
    }    
}
