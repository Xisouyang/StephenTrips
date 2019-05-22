//
//  ViewController.swift
//  StephenTrips
//
//  Created by Stephen Ouyang on 5/16/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UIViewController {
    
    var tripTableView = UITableView(frame: .zero)
    let identifier = "cell"
    static var tripArr: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        setNav()
    }
    
    override func loadView() {
        super.loadView()
        setTableView()
        TripsViewController.tripArr = CoreDataManager.sharedManager.fetchAllTrips() as! [Trip]
    }
    
    // create navigation bar
    func setNav() {
        navigationItem.title = "Planned Trips"
        navigationController?.navigationBar.backgroundColor = .lightGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    // configure table view
    func setTableView() {
        
        view.addSubview(tripTableView)
        tripTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tripTableView.delegate = self
        tripTableView.dataSource = self
        tripTableViewConstraints()
    }
    
    // go to add new trip screen
    @objc func addTapped() {
        let newVC = AddTripVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension TripsViewController: UITableViewDelegate {
    
    // handle when user taps on existing trip
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get specific trip name so able to fetch trip
        let tripName = TripsViewController.tripArr[indexPath.row].name
        guard let unwrappedName = tripName else {
            print("ERROR: no trip name")
            print("LOCATION: PlannedTripVC didSelectRowAt")
            return
        }
        
        // fetch specific trip based on trip name
        let trip = CoreDataManager.sharedManager.fetchTrip(tripName: unwrappedName) as! Trip
        guard let numOfWaypoints = trip.waypoints?.count else {
            print("ERROR: invalid data: \(String(describing: trip.waypoints?.count))")
            print("LOCATION: PlannedTripVC didSelectRowAt")
            return
        }
        
        // check if we have waypoints. If none, go to no waypoints screen
        if numOfWaypoints == 0 {
            let newVC = NoWaypointsViewController()
            newVC.plannedTrip = TripsViewController.tripArr[indexPath.row].name
            navigationController?.pushViewController(newVC, animated: true)
        // if we have waypoints, go to waypoints screen
        } else if numOfWaypoints > 0 {
            let newVC = WaypointsViewController()
            newVC.plannedTrip = TripsViewController.tripArr[indexPath.row].name
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    // handles removing trips
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = TripsViewController.tripArr[indexPath.row]
            TripsViewController.tripArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.sharedManager.removeItem(objectID: object.objectID)
            CoreDataManager.sharedManager.saveContext()
        }
    }
}

extension TripsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripsViewController.tripArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = TripsViewController.tripArr[indexPath.row].name
        return cell
    }
}
