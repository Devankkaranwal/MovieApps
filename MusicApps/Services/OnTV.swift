//
//  OnTV.swift
//  MovieApp
//
//  Created by Devank on 10/02/24.
//

import Foundation
import MyNetworkSDK

class OnTVService {
//


    
    func fetchOnTVMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=909594533c98883408adef5d56143539&page=2"

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            // Log the raw response data for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(responseString)")
            }

            do {
                // Decode the JSON response
                let decoder = JSONDecoder()
                let moviesResponse = try decoder.decode(MovieResponse.self, from: data)

                // Pass the decoded movies array to the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(.success(moviesResponse.results))
                }
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
    
    
    
    
    func fetchOnTVVideos(for movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=909594533c98883408adef5d56143539&language=en-US"

        print(urlString, "-----urlString--fetchVideos-------")

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            // Log the raw response data for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(responseString)")
            }

            do {
                // Decode the JSON response
                let decoder = JSONDecoder()
                let videosResponse = try decoder.decode(VideoResponse.self, from: data)

                // Pass the decoded videos array to the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(.success(videosResponse.results))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
}
