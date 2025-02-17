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

    fileprivate let selectedIndexIn = PublishSubject<Int>()
    
    // MARK: Components
    
    private let contentsHStack = UIStackView()
    
    fileprivate let buttons: [UIButton] = {
        ["Now Playing", "Popular", "Top Rated"].map { title in
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(
                title,
                attributes: UIFont.pretendardBold14.attributeContainer
            )
            config.baseForegroundColor = .brandColor // temp
            config.baseBackgroundColor = .white
            return UIButton(configuration: config)
        }
    }()
    
    private let underLineView = {
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
        let input = TabContentsVM.Input(selectedIndex: selectedIndexIn.asObservable())
        let output = tabContentsVM.transform(input: input)
        
        // 언더라인 뷰의 포지션을 맞추기위한 오프셋을 전달
        output.underLinePositionWillUpdate
            .map { CGFloat($0) }
            .bind(with: self) { owner, index in
                let tabWidth = owner.contentsHStack.bounds.width / 3
                let offset = tabWidth / 2
                let lineOffset = owner.underLineView.bounds.width / 2
                
                UIView.animate(withDuration: 0.2) {
                    owner.underLineView.snp.updateConstraints {
                        let inset = UIEdgeInsets(left: tabWidth*index+offset-lineOffset)
                        $0.leading.equalToSuperview().inset(inset)
                    }
                    owner.layoutIfNeeded()
                }
            }
            .disposed(by: bag)
        
        // 선택 결과에 따라 세그먼트의 색을 재설정
        output.colorWillChange
            .bind(with: self) { owner, target in
                owner.buttons.enumerated().forEach { index, button in
                    if target == index {
                        button.configuration?.baseForegroundColor = .brandColor
                    } else {
                        button.configuration?.baseForegroundColor = .onSurfaceVariant
                    }
                }
            }
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 80)) {
    TabContentsView()
}

// MARK: - Reactive

extension Reactive where Base: TabContentsView {
    var selectedIndex: Binder<Int> {
        Binder(base) { base, index in
            base.selectedIndexIn.onNext(index)
        }
    }
    
    // 3개의 버튼 배열의 탭 이벤트를 하나로 묶고, 인덱스로 변환
    var changeIndex: Observable<Int> {
        Observable.merge(base.buttons.enumerated().map { index, button in
            button.rx.tap.map { _ in index }
        })
    }
}
