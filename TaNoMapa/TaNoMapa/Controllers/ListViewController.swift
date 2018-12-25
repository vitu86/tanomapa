//
//  ListViewController.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 06/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private properties
    private var locationsList:[StudentInformation] = []
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // When locations are loaded, put them on the map. Until there, the user can use the map without block the UI.
        NotificationCenter.default.addObserver(self, selector: #selector(loadInfoToTableView), name: Notification.Name.locationsLoaded, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // We call this just in case locations are already loaded and no notification is received on start up
        loadInfoToTableView(notification: nil)
    }
    
    // MARK: Private functions
    @objc private func loadInfoToTableView(notification:Notification?) {
        locationsList = NetworkHelper.sharedInstance.studentsInformation
        tableView.reloadData()
    }
    
    // MARK: Table View Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let item = locationsList[indexPath.row]
        
        if let firstName = item.firstName {
            cell.textLabel?.text = firstName
            if let lastName = item.lastName {
                cell.textLabel!.text = cell.textLabel!.text! + " " + lastName
            }
        } else {
            cell.textLabel?.text = ""
        }
        
        cell.detailTextLabel?.text = item.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = locationsList[indexPath.row].mediaURL {
            UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
    
}
