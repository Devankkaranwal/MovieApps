//
//  MovieViewController.swift
//  MovieApp
//
//  Created by Devank on 08/02/24.
//

import UIKit
//import Kingfisher
import MyNetworkSDK

class MovieViewController: UIViewController {
    
    @IBOutlet weak var LastestCollectionView: UICollectionView!
    @IBOutlet weak var PopularCollectionView: UICollectionView!
    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var popularSegment: UISegmentedControl!
    

    var viewModel = MovieViewModel()
    let movieService = MovieService()
    let streamingService = StreamingService()
    let onTVService = OnTVService()
    
    private var videoData: [Video]? = [Video]()
    private var movieData: [Movie] = []
    private var movieDetail: [MovieDetail]? = [MovieDetail]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LastestCollectionView.dataSource = self
        LastestCollectionView.delegate = self
        
        PopularCollectionView.dataSource = self
        PopularCollectionView.delegate = self

        self.PopularCollectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: "Trailer")
        self.LastestCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "Home")
        
        fetchMovies()
        Segment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        fetchMovies(forSegmentIndex: Segment.selectedSegmentIndex)
        Segment.tintColor = .white
                
        let customGreenColor = UIColor(red: 134/255.0, green: 225/255.0, blue: 185/255.0, alpha: 1.0)
        Segment.selectedSegmentTintColor = customGreenColor
        
        popularSegment.tintColor = .white
                
        let customGreenColors = UIColor(red: 134/255.0, green: 225/255.0, blue: 185/255.0, alpha: 1.0)
        popularSegment.selectedSegmentTintColor = customGreenColors
        
        
        Segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        popularSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        
        popularSegment.addTarget(self, action: #selector(popularSegmentValueChanged(_:)), for: .valueChanged)
        fetchPopularMovies(forSegmentIndex: Segment.selectedSegmentIndex)
        
        
        
    }
    

    // Popular Segment
    
    
    func popularSegStream(){
        movieService.fetchPopularMovies { [weak self] result in
              guard let self = self else { return }
              switch result {
              case .success(let movies):
                  
                  self.movieData = movies

                  DispatchQueue.main.async {
                      self.PopularCollectionView.reloadData()
                  }
              case .failure(let error):
                  
                  print("Error fetching popular movies: \(error)")
              }
          }
    }
    
    
    func popularSegOnTV(){
        streamingService.fetchStreamingMovies { [weak self] result in
              guard let self = self else { return }
              switch result {
              case .success(let movies):
                
                  self.movieData = movies
                  
                  DispatchQueue.main.async {
                      self.PopularCollectionView.reloadData()
                  }
              case .failure(let error):
                  
                  print("Error fetching popular movies: \(error)")
              }
          }
    }
    
    
    func popularSegForRent(){
        onTVService.fetchOnTVMovies { [weak self] result in
              guard let self = self else { return }
              switch result {
              case .success(let movies):
                  
                  self.movieData = movies
                 
                  DispatchQueue.main.async {
                      self.PopularCollectionView.reloadData()
                  }
              case .failure(let error):
                  
                  print("Error fetching popular movies: \(error)")
              }
          }
    }
    
    
    
    @objc func popularSegmentValueChanged(_ sender: UISegmentedControl) {
        fetchPopularMovies(forSegmentIndex: sender.selectedSegmentIndex)
    }
    
    
    func fetchPopularMovies(forSegmentIndex index: Int) {
        switch index {
        case 0:
            popularSegStream()
        case 1:
            popularSegOnTV()
        case 2:
            popularSegForRent()
        
        default:
            break
        }
    }

    
    //----------- Latest Trailer fetchMovies segment
    
    
    // Method to fetch movies based on the selected segment
        func fetchMovies(forSegmentIndex index: Int) {
            switch index {
            case 0:
                fetchMovies()
            case 1:
                fetchStreamingMovies()
            case 2:
                fetchOnTVMovies()
            case 3:
                fetchForRentMovies()
            default:
                break
            }
        }
        
       
        @objc func segmentValueChanged(_ sender: UISegmentedControl) {
            fetchMovies(forSegmentIndex: sender.selectedSegmentIndex)
        }

    
   //------------------- LastestCollectionView Segment
    
    // Popular
    
    func fetchMovies() {
        viewModel.fetchPopularMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let firstMovie):
               
                print("First movie fetched successfully: \(firstMovie)")

               
                if let movieID = firstMovie.id {
                    self.fetchVideos(for: movieID)
                    
                    DispatchQueue.main.async {
                        self.PopularCollectionView.reloadData()

                    }
                } else {
                    
                    print("Error: Movie ID is nil")
                }

            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }


    func fetchVideos(for movieID: Int) {
        viewModel.fetchVideosForFirstMovie(movieID: movieID) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let videos):
               
                print("Videos fetched successfully: \(videos)")
                self.videoData = videos
                DispatchQueue.main.async {
                    self.LastestCollectionView.reloadData()
                }

            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }
    
        
    
    // Streaming Service
    
    func fetchStreamingMovies() {
      
            viewModel.fetchStreamingMovies{ [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let firstMovie):
                
                print("First movie fetched successfully: \(firstMovie)")

                
                if let movieID = firstMovie.id {
                    self.fetchStreamingVideos(for: movieID)
                    
                    DispatchQueue.main.async {
                        self.PopularCollectionView.reloadData()
                    }
                    
                } else {
                   
                    print("Error: Movie ID is nil")
                }

            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }


    func fetchStreamingVideos(for movieID: Int) {
        viewModel.fetchStreamingVideosForFirstMovie(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videos):
                
                print("Videos fetched successfully: \(videos)")
                self.videoData = videos // Populate videoData array
                DispatchQueue.main.async {
                    self.LastestCollectionView.reloadData()
                }

            case .failure(let error):
               
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }

    
    // OnTV Service
    
    
    func fetchOnTVMovies() {
            viewModel.fetchonTVMovies{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let firstMovie):
               
                print("First movie fetched successfully: \(firstMovie)")
                
                if let movieID = firstMovie.id {
                    self.fetchOnTVVideos(for: movieID)
                } else {
                    
                    print("Error: Movie ID is nil")
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }

    func fetchOnTVVideos(for movieID: Int) {
            viewModel.fetchonTVVideosForFirstMovie(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videos):
                
                print("Videos fetched successfully: \(videos)")
                self.videoData = videos
                DispatchQueue.main.async {
                    self.LastestCollectionView.reloadData()
                }

            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }

    
   // ForRent Service
    
    func fetchForRentMovies() {
            viewModel.fetchForRentMovies{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let firstMovie):
                
                print("First movie fetched successfully: \(firstMovie)")

               
                if let movieID = firstMovie.id {
                    self.fetchOnTVVideos(for: movieID)
                } else {
                   
                    print("Error: Movie ID is nil")
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }

    
    func fetchForRentVideos(for movieID: Int) {
            viewModel.fetchForRentVideosForFirstMovie(movieID: movieID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videos):
                
                print("Videos fetched successfully: \(videos)")
                self.videoData = videos
                DispatchQueue.main.async {
                    self.LastestCollectionView.reloadData()
                }

            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.handleError(error)
                }
            }
        }
    }

        func handleError(_ error: Error) {
            switch error {
            case NetworkError.invalidResponse:
                print("Invalid URL")
               
            case NetworkError.invalidResponse:
                print("Invalid Response")
               
            case NetworkError.noData:
                print("No Data")
                
            default:
                print("Unknown error: \(error.localizedDescription)")
                
            }
        }
}


// MARK: - Collection View DataSource

extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK: - Number of Items in Section
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == LastestCollectionView {
           
            return self.videoData?.count ?? 0
        } else {
            
            return self.movieData.count ?? 0
        }
    }
    
    
    //MARK: - Cell For Item at

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == LastestCollectionView {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trailer", for: indexPath) as? TrailerCollectionViewCell
               cell?.backgroundColor = UIColor.green
               
               guard let videoKey = self.videoData?[indexPath.row].key else {return UICollectionViewCell()}
               
               guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else {return UICollectionViewCell()}
                         print(url,"-------------------urlsss vidosss + key adds ---------------------------")
               
               cell?.trailerWebView.load(URLRequest(url: url))
               
               
               cell?.lblType.text! = (self.videoData?[indexPath.row].type)!
               cell?.blbName.text! = (self.videoData?[indexPath.row].name)!
               
               return cell!
           }

        else {
                          
//            if collectionView == PopularCollectionView {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home", for: indexPath) as? HomeCollectionViewCell
//                if let unwrappedCell = cell {
//
//                    if let posterPath = self.movieData[indexPath.row].posterPath {
//                               let downloadPosterImage = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
//                               unwrappedCell.posterImage.kf.setImage(with: downloadPosterImage)
//                           }
//                    unwrappedCell.posterLabel.text! = (self.movieData[indexPath.row].originalTitle)!
//
//
//
//
//                    if let releaseDate = self.movieData[indexPath.row].release_date {
//                        // If release_date is not nil, set the text
//                        unwrappedCell.lblPoster.text = releaseDate
//                    } else {
//                        // If release_date is nil, provide a default value or handle the case accordingly
//                        unwrappedCell.lblPoster.text = "Unknown"
//                    }
//
//
//                    return unwrappedCell
//                } else {
//                    fatalError("Unable to dequeue HomeCollectionViewCell")
//                }
//            }
            
            
            if collectionView == PopularCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home", for: indexPath) as? HomeCollectionViewCell
                if let unwrappedCell = cell {
                    
                    if let posterPath = self.movieData[indexPath.row].posterPath {
                        let posterImageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                        
                        let task = URLSession.shared.dataTask(with: posterImageUrl!) { (data, response, error) in
                            if let imageData = data {
                                DispatchQueue.main.async {
                                    unwrappedCell.posterImage.image = UIImage(data: imageData)
                                }
                            }
                        }
                        task.resume()
                    }
                    unwrappedCell.posterLabel.text! = (self.movieData[indexPath.row].originalTitle)!
                    
                    if let releaseDate = self.movieData[indexPath.row].release_date {
                        // If release_date is not nil, set the text
                        unwrappedCell.lblPoster.text = releaseDate
                    } else {
                        // If release_date is nil, provide a default value or handle the case accordingly
                        unwrappedCell.lblPoster.text = "Unknown"
                    }
                    
                    return unwrappedCell
                } else {
                    fatalError("Unable to dequeue HomeCollectionViewCell")
                }
            }

            
            
           }
        return UICollectionViewCell()
       }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == LastestCollectionView {
          
            print("Selected item in LastestCollectionView")
        } else if collectionView == PopularCollectionView {
            print("Selected item in PopularCollectionView")
             
           
            guard !movieData.isEmpty else {
                print("Error: movieData is empty")
                return
            }
            
            if indexPath.item < movieData.count {
                let selectedMovie = movieData[indexPath.item]
                print("Selected Movie: \(selectedMovie)")
                
                
                let destinationVC = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
                destinationVC?.selectedMovieID = selectedMovie.id
                destinationVC?.selectedMovie = selectedMovie
               
                if let destinationVC = destinationVC {
                    self.navigationController?.pushViewController(destinationVC, animated: true)
                }
      
            } else {
                print("Error: Index out of bounds")
            }
        }
    }


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Calculate and return the size of your collection view item
//        return CGSize(width: collectionView.bounds.width, height: 100) // Adjust the height as needed
//    }


}


