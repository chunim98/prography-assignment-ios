//
//  MovieListVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MovieListVC: UIViewController {
    
    // MARK: Properties
    
    private let movieListVM: MovieListVM
    private let bag = DisposeBag()
    
    // MARK: Interface
    
    fileprivate let currentCellIndexIn = PublishSubject<Int>()
    
    // MARK: Components
    
    fileprivate let listTV = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = 160 + 16
        return tv
    }()
    
    // MARK: Life Cycle
    
    init(_ article: TMDBService.Article) {
        self.movieListVM = MovieListVM(article)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAutoLayout()
        setBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(listTV)
        listTV.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = MovieListVM.Input(currentCellIndex: currentCellIndexIn.asObservable())
        let output = movieListVM.transform(input: input)
        
        // 테이블 뷰 데이터 바인딩
        output.listCellDataArr
            .bind(to: listTV.rx.items(
                cellIdentifier: ListCell.identifier,cellType: ListCell.self
            )) { [weak self] index, data, cell in
                guard let self else { return }
                
                cell.configure(data)
                self.rx.currentCellIndex.onNext(index)
            }
            .disposed(by: bag)
    }
}

#Preview {
    MovieListVC(.nowPlaying)
}

// MARK: - Reactive

extension Reactive where Base: MovieListVC {
    var currentCellIndex: Binder<Int> {
        Binder(base) { base, index in
            base.currentCellIndexIn.onNext(index)
        }
    }
    
    var modelSelected: Observable<MovieId> {
        base.listTV.rx.modelSelected(MovieId.self).asObservable()
    }
}
