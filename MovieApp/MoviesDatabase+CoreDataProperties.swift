//
//  MoviesDatabase+CoreDataProperties.swift
//  MovieApp
//
//  Created by ranjit dhumal on 11/07/23.
//
//

import Foundation
import CoreData


extension MoviesDatabase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesDatabase> {
        return NSFetchRequest<MoviesDatabase>(entityName: "MoviesDatabase")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var imdbid: String?
    @NSManaged public var runtime: String?
    @NSManaged public var cast: String?
    @NSManaged public var movieposter: Data?

}

extension MoviesDatabase : Identifiable {

}
