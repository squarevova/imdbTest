//
//  MovieCell.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    
    @IBOutlet weak var movieTitleTextView: UITextView!
    @IBOutlet weak var movieRankLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private var imageRequest: Cancellable?
    
    //MARK: - Class methods
    
    class var identifier: String { return String(describing: self) }
    
    //MARK: - Internal methods
    
    var cellViewModel: MovieTableViewCellViewModel? {
        didSet {
            movieTitleTextView.text = cellViewModel?.title
            
            let rankStr = NSLocalizedString("movie_rank_caption", comment: "")
            let undefinedStr = NSLocalizedString("undefined", comment: "")
            
            movieRankLabel.text = rankStr + ": " + (cellViewModel?.rank ?? undefinedStr)
            
            if let image = cellViewModel?.image {
                self.movieImageView.image = image
            } else if let cellViewModel = self.cellViewModel {
                activityIndicatorView.startAnimating()
                
                imageRequest = cellViewModel.loadImage() { [weak self] in
                    DispatchQueue.main.async {
                        self?.movieImageView.image = cellViewModel.image
                        self?.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    //MARK: - UITableViewCell override

    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicatorView.stopAnimating()

        movieImageView.image = nil
        
        imageRequest?.cancel()
    }
}