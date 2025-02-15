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
    
    // MARK: Components
    
    private let listTV = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = 160 + 16
        return tv
    }()
    
    // MARK: Life Cycle
    
    init(_ article: TMDBNetworkManager.Article) {
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
        let input = MovieListVM.Input()
        
        let output = movieListVM.transform(input: input)
        
        output.listCellDataArr
            .bind(to: listTV.rx.items(
                cellIdentifier: ListCell.identifier,cellType: ListCell.self
            )) { index, item, cell in
                cell.configure(item)
            }
            .disposed(by: bag)
    }
    
}

#Preview {
    MovieListVC(.nowPlaying)
}
