//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Devank on 09/02/24.
//

import UIKit
import WebKit


class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var viewPg13: UIView!
    @IBOutlet weak var lblPg13: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var topBilledcastCollectionView: UICollectionView!
    @IBOutlet weak var recommendationTrailerCollectionView: UICollectionView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
//    @IBOutlet weak var tabBar: UIToolbar!
//    @IBOutlet weak var bottomView: UIView!
//
    @IBOutlet weak var lblTagline: UILabel!
    @IBOutlet weak var lblAdventure: UILabel!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblScience: UILabel!
    
    @IBOutlet weak var btnSocialReview: UIButton!
    @IBOutlet weak var btnSocialDecision: UIButton!
    @IBOutlet weak var viewSocialRev: UIView!
    @IBOutlet weak var viewSocialDec: UIView!
    
    var selectedMovie: Movie?
    var viewModel = MovieViewModel()
    private var movieArray : [Movie]? = [Movie]()
    private var movieData: [Movie] = []
    private var videoData : [Video]? = [Video]()
    var selectedMovieID: Int?
    var movieDetails: [MovieDetail]?
    var error: Error?
    var onError: ((Error) -> Void)?
    var onDataUpdate: (() -> Void)?
//    var carbonTabSwipeNavigation : CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
//    let SLIDEBAR_ID = "ProfileSlideBar"
    
    enum CellType {
          case socialReview
          case socialDecision
      }
    
    var currentCellType: CellType = .socialReview
//    let MyCollectionViewCellId: String = "SocialReview"
//    let SocialDecisionCellId: String = "Socl"

 
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        print(selectedMovieID,"idddddddd----")
        
        
        viewModel.selectedMovieID = selectedMovieID
        
        topBilledcastCollectionView.dataSource = self
        topBilledcastCollectionView.delegate = self

        recommendationTrailerCollectionView.dataSource = self
        recommendationTrailerCollectionView.delegate = self
        
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        

      
        self.topBilledcastCollectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: "Trailer")
        self.recommendationTrailerCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "Home")
        
//        
        sliderCollectionView.register(UINib(nibName: "SocialDecisionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialDecision")
        sliderCollectionView.register(UINib(nibName: "SocialReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialReview")

        
        
        
        
        
                viewModel.onDataUpdate = { [weak self] in
                    DispatchQueue.main.async {
                        self?.recommendationTrailerCollectionView.reloadData()
                        self?.topBilledcastCollectionView.reloadData()
                       // self?.sliderCollectionView.reloadData()
                    }
                }

        
        
        self.fetchCastAndVideos()
        self.loadDetails()
        self.updateButtonColors()
        
    }
    
    
    // Method to update button colors based on selection state
     private func updateButtonColors() {
         // Set non-selected button color to gray and selected button color to white
         btnSocialReview.setTitleColor(currentCellType == .socialReview ? .white : .gray, for: .normal)
        btnSocialDecision.setTitleColor(currentCellType == .socialDecision ? .white : .gray, for: .normal)
         
         viewSocialRev.backgroundColor = currentCellType == .socialReview ? .white : .gray
        viewSocialDec.backgroundColor = currentCellType == .socialDecision ? .white : .gray
     }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    


    
    func fetchMovieDetail() {
        guard let movieID = selectedMovieID else {
            return
        }

        viewModel.fetchMovieDetail(for: movieID) { [weak self] result in
            switch result {
            case .success(let movieDetail):
                
                DispatchQueue.main.async {
                    self?.updateUI(with: movieDetail)
                }
            case .failure(let error):
                print("Failed to fetch movie details:", error)
                
            }
        }
    }

    func updateUI(with movieDetail: MovieDetail) {
        
        guard !movieDetail.genres.isEmpty else {
            return
        }
        
        lblAdventure.text = movieDetail.genres[0].name
        lblAction.text = movieDetail.genres.count > 1 ? movieDetail.genres[1].name : ""
        lblScience.text = movieDetail.genres.count > 2 ? movieDetail.genres[2].name : ""
    }

    

    
    
    
    private func loadDetails() {
        movieTitle.text! = (selectedMovie?.title)!
        movieOverview.text! = (selectedMovie?.overview)!
        

        if let movie = selectedMovie {
            if let posterPath = movie.posterPath,
               let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: posterURL) {
                        DispatchQueue.main.async {
                            self.posterImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }

    
    
    func fetchCastAndVideos() {
        
        print(viewModel.selectedMovieID,"movieID---")
        
        guard let movieID = viewModel.selectedMovieID else {
            return
        }

        
        viewModel.fetchMovieCredits(for: movieID) { [weak self] result in
            switch result {
            case .success(let creditsResponse):
                print("Fetched credits:", creditsResponse)
                // Reload collectionView data if needed
                DispatchQueue.main.async {
                    self?.topBilledcastCollectionView.reloadData()
                    self?.sliderCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching credits:", error)
            }
        }

        // Fetch videos
        viewModel.fetchVideos(for: movieID) { [weak self] result in
            switch result {
            case .success(let videos):
                print("Fetched videos:", videos)
                // Reload collectionView data if needed
                DispatchQueue.main.async {
                    self?.recommendationTrailerCollectionView.reloadData()
                   
                }
            case .failure(let error):
                print("Error fetching videos:", error)
            }
        }
        
        

        
        viewModel.fetchMovieDetail(for: movieID) { [weak self] result in
                    switch result {
                    case .success(let movieDetail):
                        print("Movie detail fetched:", movieDetail)
                       
                        self?.movieDetails = [movieDetail]
                        self?.error = nil
                        self?.onDataUpdate?()
                        self?.loadDetails()
                        DispatchQueue.main.async {
                                       self?.lblDate.text = movieDetail.release_date
                            self?.lblTagline.text = movieDetail.tagline
                                   }
                    case .failure(let error):
                        print("Failed to fetch movie details:", error)
                        self?.error = error
                        self?.onError?(error)
                        
                    }
                }
        
        
        
        viewModel.fetchMovieGenres() { result in
            switch result {
            case .success(let genres):
                print("Genres fetched successfully:", genres)
                
            case .failure(let error):
                print("Failed to fetch genres:", error)
                
            }
        }




        fetchMovieDetail()
        
        
    }
    

    
    @IBAction func btnPlayed(_ sender: Any) {
        guard let videoKey = viewModel.videos[(sender as AnyObject).tag].key else {
               print("Video key not found")
               return
           }
           
           // Create an instance of VideoViewController from the storyboard
           guard let videoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else {
               return
           }
           
           
           videoViewController.videoURL = URL(string: "https://www.youtube.com/embed/\(videoKey)")
           
          
           present(videoViewController, animated: true, completion: nil)
    

    }

    
    
    
    @IBAction func addButtonTappedAddtoList(_ sender: UIButton) {
         
          let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          
          
          let addToFavoritesAction = UIAlertAction(title: "Add to Favorites", style: .default) { _ in
              
              print("Add to Favorites tapped")
          }
          alertController.addAction(addToFavoritesAction)
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          present(alertController, animated: true, completion: nil)
      }
    
    @IBAction func btnSaved(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
       
        let addToListAction = UIAlertAction(title: "Mark as Saved", style: .default) { _ in
           
            print("Mark as Saved")
        }
        alertController.addAction(addToListAction)
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    

    @IBAction func addButtonTappedHeart(_ sender: UIButton) {
          
          let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          
         
          let addToListAction = UIAlertAction(title: "Mark as Favourite", style: .default) { _ in
             
              print("Mark as Favourite")
          }
          alertController.addAction(addToListAction)
          
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          alertController.addAction(cancelAction)
          
          
          present(alertController, animated: true, completion: nil)
      }
    
    
    
    
    
    @IBAction func btnSocialReview(_ sender: Any) {
        currentCellType = .socialReview
        sliderCollectionView.reloadData()
        updateButtonColors()
        
//        DispatchQueue.main.async {
//            self.currentCellType = .socialReview
//            self.sliderCollectionView.reloadData()
//        }
        
    }
    
    
    @IBAction func SocialDecision(_ sender: Any) {
        currentCellType = .socialDecision
        sliderCollectionView.reloadData()
        updateButtonColors()
        
//        DispatchQueue.main.async {
//           self.currentCellType = .socialDecision
//            self.sliderCollectionView.reloadData()
//        }
        
    }
    
    
}



// MARK: - Collection View DataSource


extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: - Number of Items in Section


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == recommendationTrailerCollectionView {
                return viewModel.videos.count
            } else if collectionView == topBilledcastCollectionView {
                return viewModel.cast.count
            }else if collectionView == sliderCollectionView {
            return 1
        }
        
            return 0
        }
        
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if collectionView == recommendationTrailerCollectionView {
               
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trailer", for: indexPath) as! TrailerCollectionViewCell
            
                let video = viewModel.videos[indexPath.item]
                
                guard let videoKey = viewModel.videos[indexPath.item].key else {return UICollectionViewCell()}
                
                guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else {return UICollectionViewCell()}
                          print(url,"-----youtube vidosss -------------------")
                
                cell.trailerWebView.load(URLRequest(url: url))
                cell.blbName.text! = viewModel.videos[indexPath.item].name!
               
                
                return cell
            }
            
            
            else if collectionView == topBilledcastCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Home", for: indexPath) as! HomeCollectionViewCell
                let cast = viewModel.cast[indexPath.item]
                
                if let posterPath = viewModel.cast[indexPath.item].profile_path {
                    let posterImageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                    
                    let task = URLSession.shared.dataTask(with: posterImageUrl!) { (data, response, error) in
                        if let imageData = data {
                            DispatchQueue.main.async {
                                cell.posterImage.image = UIImage(data: imageData)
                            }
                        }
                    }
                    task.resume()
                }
                
                cell.posterLabel.text! = viewModel.cast[indexPath.item].name
                cell.lblPoster.text! = viewModel.cast[indexPath.item].character
                
                return cell
            }
            
            else if collectionView == sliderCollectionView {

                
                switch currentCellType {
                    case .socialReview:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialReview", for: indexPath) as! SocialReviewCollectionViewCell
                        // Configure the cell
                        return cell
                    case .socialDecision:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialDecision", for: indexPath) as! SocialDecisionCollectionViewCell
                        // Configure the cell
                        return cell
                    }
                
                
            }
        
            return UICollectionViewCell()
            
            //fatalError("Unknown collection view")
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          // Return the size you want for each cell
        if collectionView == recommendationTrailerCollectionView {
            
            return CGSize(width: collectionView.bounds.width, height: 173)
            
        }
        else if collectionView == topBilledcastCollectionView {
            
            return CGSize(width: 130, height: 263)
        }
        
        else if collectionView == sliderCollectionView {
            if  currentCellType == .socialReview{
                
            return CGSize(width: collectionView.bounds.width, height: 272)
                
            }else{
                return CGSize(width: collectionView.bounds.width, height: 200) // For example, set a fixed height of 100
            }
            
        }
        
        return CGSize(width: collectionView.bounds.width, height: 100)
         
      }
    

   

}

extension MovieDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load web content: \(error)")
       
    }
}






