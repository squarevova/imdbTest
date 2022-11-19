//
//  ViewController.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import UIKit

class MoviesViewController: UITableViewController {
    private let moviesService = MoviesService()
    
    lazy var viewModel: MoviesViewModel = {
        return MoviesViewModel(moviesService: moviesService)
//        return MoviesViewModel(moviesService: MoviesTestDataService())
    }()
    
    //MARK: - UITableViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMovies()
        
        viewModel.viewModelCompletion = { [weak self] error in
            if let err = error {
                DispatchQueue.main.async {
                    self?.showAlertWithError(err)
                }
            } else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CharactersCountViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let title = viewModel.getMovieeCellViewModel(at: indexPath).title
            destinationVC.viewModel = CharactersCountViewModel(title: title)
        }
    }
    
    //MARK: - UITableViewDataSource override
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieCellViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("MovieTableViewCell does not exist")
        }
                       
        let cellViewModel = viewModel.getMovieeCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        
        return cell
    }
}

