//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Devank on 10/02/24.
//

import Foundation

class MovieViewModel {
    var movies: [Movie] = []
    var movieDetail: MovieDetail?
    var videos: [Video] = []
    var cast: [Cast] = []
    var selectedMovieID: Int?
    
    var creditsResponse: CreditsResponse?
    let service = MovieService()
    let streamingService = StreamingService()
    let onTVService = OnTVService()
    let forRentService = ForRentService()
    var error: Error?
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
  
     
    
    // Popular
    
    func fetchPopularMovies(completion: @escaping (Result<Movie, Error>) -> Void) {
        service.fetchPopularMovies { result in
            switch result {
            case .success(let movies):
                if let firstMovie = movies.first {
                    completion(.success(firstMovie))
                } else {
                    completion(.failure(CustomError.noMoviesAvailable))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchVideosForFirstMovie(movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
        service.fetchVideos(for: movieID) { result in
            switch result {
            case .success(let videos):
                completion(.success(videos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // StreamingService
    
    
    func fetchStreamingMovies(completion: @escaping (Result<Movie, Error>) -> Void) {
        streamingService.fetchStreamingMovies { result in
            switch result {
            case .success(let movies):
                if let firstMovie = movies.first {
                    completion(.success(firstMovie))
                } else {
                    completion(.failure(CustomError.noMoviesAvailable))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchStreamingVideosForFirstMovie(movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
        streamingService.fetchStreamingVideos(for: movieID) { result in
            switch result {
            case .success(let videos):
                completion(.success(videos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    // onTVService
    
    
    func fetchonTVMovies(completion: @escaping (Result<Movie, Error>) -> Void) {
        onTVService.fetchOnTVMovies { result in
            switch result {
            case .success(let movies):
                if let firstMovie = movies.first {
                    completion(.success(firstMovie))
                } else {
                    completion(.failure(CustomError.noMoviesAvailable))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchonTVVideosForFirstMovie(movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
        onTVService.fetchOnTVVideos(for: movieID) { result in
            switch result {
            case .success(let videos):
                completion(.success(videos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // ForRent
    
    
    
    func fetchForRentMovies(completion: @escaping (Result<Movie, Error>) -> Void) {
        forRentService.fetchForRentMovies { result in
            switch result {
            case .success(let movies):
                if let firstMovie = movies.first {
                    completion(.success(firstMovie))
                } else {
                    completion(.failure(CustomError.noMoviesAvailable))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchForRentVideosForFirstMovie(movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
        forRentService.fetchForRentVideos(for: movieID) { result in
            switch result {
            case .success(let videos):
                completion(.success(videos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // movie detail
  
    
    func fetchMovieDetail(for movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        service.fetchMovieDetail(for: movieID) { result in
            switch result {
            case .success(let movieDetail):
                completion(.success(movieDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    
    // credit
   
    
    func fetchMovieCredits(for movieID: Int, completion: @escaping (Result<[Cast], Error>) -> Void) {
        service.fetchMovieCredits(for: movieID) { [weak self] result in
            switch result {
            case .success(let cast):
//                self?.cast = cast
                self?.cast = cast
                self?.error = nil
                self?.onDataUpdate?()
            case .failure(let error):
                self?.error = error
                self?.creditsResponse = nil
                self?.onError?(error)
            }
        }
    }

    
    // videos ----------
    
    func fetchVideos(for movieID: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
            service.fetchVideos(for: movieID) { result in
                switch result {
                case .success(let videos):
                    self.videos = videos
                    completion(.success(videos))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    // fetchMovieGenres
    
    
    func fetchMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        service.fetchMovieGenres { result in
            switch result {
            case .success(let genres):
                print("Fetched genres:", genres)
                completion(.success(genres))
            case .failure(let error):
                print("Error fetching genres:", error)
                completion(.failure(error))
            }
        }
    }

   
    
}


