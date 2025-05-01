//
//  DIContainer.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 5/1/25.
//

final class DIContainer {
    
    // MARK: Singletone
    
    static let shared = DIContainer()
    private init() {}
    
    // MARK: Home
    
    func makeCarouselVM() -> CarouselVM {
        let repository = DefaultCarouselCellDataRepository()
        let useCase = FetchCarouselCellDataArrUseCase(repository)
        return CarouselVM(fetchCarouselCellDataArr: useCase)
    }
    
    func makeMovieListVM(article: TMDBService.Article) -> MovieListVM {
        let repository = DefaultListCellDataArrRepository()
        let useCase = FetchListCellDataArrUseCase(repository, article)
        return MovieListVM(fetchListCellDataArr: useCase)
    }
    
    // MARK: MovieReview
    
    func makeMovieReviewVM(movieId: Int) -> MovieReviewVM {
        // Repositories
        let movieDetailRepository = DefaultMovieDetailRepository()
        let reviewDataRepository = DefaultReviewDataRepository()
        
        // Use Cases
        let fetchMovieDetail = FetchMovieDetailUseCase(movieDetailRepository)
        let reviewDataUseCase = ReviewDataUseCase(reviewDataRepository)
        
        return MovieReviewVM(
            movieId: movieId,
            fetchMovieDetail: fetchMovieDetail,
            reviewDataUseCase: reviewDataUseCase
        )
    }
    
    // MARK: My
    
    func makeMyVM() -> MyVM {
        let repository = DefaultMyMovieCellDataArrRepository()
        let useCase = FetchMyMovieCellDataArrUseCase(repository)
        return MyVM(fetchMyMovieCellDataArr: useCase)
    }
}
