//
//  Trip+CoreDataProperties.swift
//  StephenTrips
//
//  Created by Stephen Ouyang on 5/19/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String?
    @NSManaged public var waypoints: NSSet?

}

// MARK: Generated accessors for waypoints
extension Trip {

    @objc(addWaypointsObject:)
    @NSManaged public func addToWaypoints(_ value: Waypoint)

    @objc(removeWaypointsObject:)
    @NSManaged public func removeFromWaypoints(_ value: Waypoint)

    @objc(addWaypoints:)
    @NSManaged public func addToWaypoints(_ values: NSSet)

    @objc(removeWaypoints:)
    @NSManaged public func removeFromWaypoints(_ values: NSSet)

}
