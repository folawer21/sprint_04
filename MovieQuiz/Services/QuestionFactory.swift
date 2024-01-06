import Foundation

enum LoadErrors : Error {
    case failedDownloadingMovies
}
final class QuestionFactory: QuestionFactoryProtocol{
    
    private weak var delegate: QuestionFactoryDelegate?
    private let movieLoader: MoviesLoadingProtocol
    
    private var movies: [MostPopularMovie] = []
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?){
        self.delegate = delegate
        self.movieLoader = moviesLoader
    }
    
    func loadData(){
        movieLoader.loadMovies{ [weak self ] result in
            DispatchQueue.main.async {
                guard let self = self else {return }
                switch result {
                    case .success(let mostPopularMovies):
                        if mostPopularMovies.items.isEmpty {
                            self.delegate?.didFailToLoadData(with:LoadErrors.failedDownloadingMovies )
                        }
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    case .failure(let error):
                        self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion(){
        
        DispatchQueue.global().async { [weak self ] in
            guard let self = self else {return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else {return }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            }
            catch (let error ){
                DispatchQueue.main.async { [weak self ] in
                    guard let self = self else {return }
                    self.delegate?.didFailToLoadData(with: error)
                }
                print("Failed to load image from URL")
                return
            }
            let rating = Float(movie.rating) ?? 0
            let randNumb = 7
            let correctAnswer = rating > Float(randNumb)
            
            let text = "Рейтинг фильма больше чем \(randNumb)?"
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
