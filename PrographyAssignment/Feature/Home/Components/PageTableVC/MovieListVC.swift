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
    
    private let movieListVM = MovieListVM()
    private let bag = DisposeBag()
    
    // MARK: Dependency Input
    
    let listCellDataArrInput = PublishSubject<[ListCellData]>()
    
    // MARK: Components
    
    private let listTV = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = 160 + 16
        return tv
    }()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setAutoLayout()
        setBinding()
    }

    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(listTV)
        listTV.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = MovieListVM.Input(
            listCellDataArr: listCellDataArrInput.asObservable()
        )
        
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
    MovieListVC()
}
