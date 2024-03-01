//
//  CreditsModel.swift
//  MovieApp
//
//  Created by Devank on 11/02/24.
//

import Foundation

struct CreditsResponse: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]

}

struct Cast: Codable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
    let adult: Bool?
    let gender: Int?
    let known_for_department, original_name: String?
    let popularity: Double?
    let cast_id: Int?
    let order: Int?
    let department, job: String?
    
}

struct Crew: Codable {
    let id: Int?
    let name: String?
    let job: String?
    let profilePath: String?
    let known_for_department, original_name: String?
    let credit_id: String?
    let department: String?
    let popularity: Double?
    
}
