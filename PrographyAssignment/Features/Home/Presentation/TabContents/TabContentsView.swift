//
//  TabContentsView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class TabContentsView: UIView {
    
    // MARK: Properties
    
    private let tabContentsVM = TabContentsVM()
    private let bag = DisposeBag()
    private let once = OnlyOnce()
    
    // MARK: Interface

    fileprivate let tabIndex = PublishSubject<Int>()
    
    // MARK: Components
    
    fileprivate let contentsHStack = UIStackView()
    
    fileprivate let buttons: [UIButton] = {
        ["Now Playing", "Popular", "Top Rated"].map { title in
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(
                title,
                attributes: UIFont.pretendardBold14.attributeContainer
            )
            config.baseForegroundColor = .brandColor
            config.baseBackgroundColor = .white
            return UIButton(configuration: config)
        }
    }()
    
    fileprivate let underLineView = {
        let view = UIView()
        view.backgroundColor = .brandColor
        return view
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAutoLayout()
        setBinding()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        once.excute { setUnderLinePosition() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(contentsHStack)
        self.addSubview(underLineView)
        buttons.forEach { contentsHStack.addArrangedSubview($0) }
        
        contentsHStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(vertical: 16))
            $0.height.equalTo(48)
        }
        underLineView.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.width.equalTo(78)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(contentsHStack.snp.bottom)
        }
    }
    
    private func setUnderLinePosition() {
        
        /// setAutoLayout 시점에 아무런 값으로 레이아웃 잡고,
        /// layoutSubviews 시점에 제대로 된 값으로 초기화
        ///
        /// 이렇게 안하면, setBinding 시점에
        /// 없는 제약을 업데이트 하려 한다면서 에러 뱉음ㅡㅡ
       
        let offset = (contentsHStack.bounds.width/3) / 2
        let lineOffset = underLineView.bounds.width / 2
        
        underLineView.snp.updateConstraints {
            let inset = UIEdgeInsets(left: offset-lineOffset)
            $0.leading.equalToSuperview().inset(inset)
        }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = TabContentsVM.Input(tabIndex: tabIndex.asObservable())
        let output = tabContentsVM.transform(input: input)
        
        // 현재 탭 인덱스에 맞게, 언더라인 위치 업데이트
        output.tabIndexCGFloat
            .bind(to: self.rx.underLinePosition)
            .disposed(by: bag)
        
        // 현재 탭 인덱스에 맞게, 버튼 색상 업데이트
        output.tabIndex
            .bind(to: self.rx.buttonsColor)
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 80)) {
    TabContentsView()
}

// MARK: - Reactive

extension Reactive where Base: TabContentsView {
    
    fileprivate var underLinePosition: Binder<CGFloat> {
        Binder(base) { base, tabIdx in
            let tabWidth = base.contentsHStack.bounds.width / 3
            let offset = tabWidth / 2
            let lineOffset = base.underLineView.bounds.width / 2
            
            UIView.animate(withDuration: 0.2) {
                base.underLineView.snp.updateConstraints {
                    let inset = UIEdgeInsets(left: tabWidth*tabIdx+offset-lineOffset)
                    $0.leading.equalToSuperview().inset(inset)
                }
                base.layoutIfNeeded()
            }
        }
    }
    
    fileprivate var buttonsColor: Binder<Int> {
        Binder(base) { base, tabIdx in
            base.buttons.enumerated().forEach { btnIdx, button in
                let color: UIColor = (tabIdx == btnIdx) ? .brandColor : .onSurfaceVariant
                button.configuration?.baseForegroundColor = color
            }
        }
    }
    
    var tabIndex: Binder<Int> {
        Binder(base) { $0.tabIndex.onNext($1) }
    }
    
    // 3개의 버튼 배열의 탭 이벤트를 하나로 묶고, 인덱스로 변환
    var changedIndex: Observable<Int> {
        Observable.merge(base.buttons.enumerated().map { index, button in
            button.rx.tap.map { _ in index }
        })
    }
}
