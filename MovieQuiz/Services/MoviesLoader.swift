//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Александр  Сухинин on 09.12.2023.
//

import Foundation

protocol MoviesLoadingProtocol{
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) -> Void)
}

struct MoviesLoader: MoviesLoadingProtocol {
    
    private let networkClient = NetworkClient()

    private var mostPopularMoviesUrl: URL{
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        let mostPopularMovies =  networkClient.fetch(url: mostPopularMoviesUrl){ result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                }
                catch{
                    handler(.failure(error ))
                }
            
            case .failure(let error):
                handler(.failure(error))
            
            
            
    
            }
        }
    }
        
        
        
    
}
