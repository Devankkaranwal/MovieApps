//
//  MovieResponseModel.swift
//  MovieApp
//
//  Created by Devank on 10/02/24.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]
//    let dates: Dates
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
//        case dates
    }
}

//struct Dates: Codable {
//    let maximum: String?
//    let minimum: String?
//}
