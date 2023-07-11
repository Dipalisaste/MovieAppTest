//
//  Movies2.swift
//  MovieApp
//
//  Created by ranjit dhumal on 10/07/23.
//

import Foundation

struct Movies2:Decodable {
    
    let movieList2: [MovieList2]

    enum CodingKeys: String, CodingKey {
        case movieList2 = "Movie List"
    }
}

// MARK: - MovieList
struct MovieList2: Decodable {
    let title, year, summary, shortSummary: String
    let genres, imdbid, runtime: String
    let youTubeTrailer: String?
    let rating: String
    let moviePoster: String
    let director, writers, cast: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case summary = "Summary"
        case shortSummary = "Short Summary"
        case genres = "Genres"
        case imdbid = "IMDBID"
        case runtime = "Runtime"
        case youTubeTrailer = "YouTube Trailer"
        case rating = "Rating"
        case moviePoster = "Movie Poster"
        case director = "Director"
        case writers = "Writers"
        case cast = "Cast"
    }
}
