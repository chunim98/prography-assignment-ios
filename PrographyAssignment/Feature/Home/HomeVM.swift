//
//  HomeVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeVM {
    
    struct Input {

    }
    
    struct Output {
        let nowPlaying: Observable<MovieInfo>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let nowPlaying = ReplaySubject<MovieInfo>.create(bufferSize: 1)
        
        // nowPlaying의 초기 값 설정
        fetchNowPlaying()
            .bind(to: nowPlaying)
            .disposed(by: bag)

        
        return Output(nowPlaying: nowPlaying.asObservable())
    }
    
    // MARK: Methods
    
    private func fetchNowPlaying() -> Observable<MovieInfo> {
        Observable.create { obsever in
            Task {
                let result = try await NetworkManager.shered.fetchNowPlaying()
                obsever.onNext(result)
            }
            
            return Disposables.create()
        }
    }
}
