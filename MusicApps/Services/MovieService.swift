//
//  MovieService.swift
//  MovieApp
//
//  Created by Devank on 10/02/24.
//

import Foundation
import MyNetworkSDK

class MovieService {
    
        var creditsResponse: CreditsResponse?
        var error: Error?
        let networkManager = NetworkManager.shared

    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=909594533c98883408adef5d56143539&page=1"

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

    
    
    func fetchMovieDetail(for movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=909594533c98883408adef5d56143539&language=en-US"
        
        print(urlString, "-----urlString--fetchMovieDetail-------")
        
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
                let decoder = JSONDecoder()
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                
                // Pass the decoded movie detail to the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(.success(movieDetail))
                }
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }




    

    
    func fetchMovieCredits(for movieID: Int, completion: @escaping (Result<[Cast], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=909594533c98883408adef5d56143539&language=en-US"
        
        print(urlString, "-----urlString--fetchMovieCredits-------")
        
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
                let decoder = JSONDecoder()
                let castResponse = try decoder.decode(CreditsResponse.self, from: data)
                
                // Pass the decoded cast array to the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(.success(castResponse.cast))
                }
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }


    

    
    func fetchVideos(for movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
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

    
    
    func fetchMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let apiKey = "909594533c98883408adef5d56143539"
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US"

        print(urlString, "-----urlString--fetchMovieGenres-------")
        
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
                let decoder = JSONDecoder()
                let response = try decoder.decode(GenreListResponse.self, from: data)
                
                // Pass the decoded genres array to the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(.success(response.genres))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    
}




enum CustomError: Error {
    case noMoviesAvailable
}


