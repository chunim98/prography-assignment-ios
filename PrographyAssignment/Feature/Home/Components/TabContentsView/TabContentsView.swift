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
    
    // MARK: Dependency Output

    let selectedSegmentIndexOutput = PublishSubject<Int>()
    
    // MARK: Components
    
    private let segment = {
        let seg = UISegmentedControl()
        let image = UIImage()
        
        seg.insertSegment(withTitle: "Now Playing", at: 0, animated: true)
        seg.insertSegment(withTitle: "Popular", at: 1, animated: true)
        seg.insertSegment(withTitle: "Top Rated", at: 2, animated: true)
        seg.selectedSegmentIndex = 0
        
        // 텍스트 색상 변경
        seg.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.onSurfaceVariant,
                NSAttributedString.Key.font: UIFont.pretendardBold14!,
            ],
            for: .normal
        )
        seg.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.brandColor,
                NSAttributedString.Key.font: UIFont.pretendardBold14!,
            ],
            for: .selected
        )
        
        // 배경 및 구분선 투명하게 변경
        seg.setBackgroundImage(image, for: .normal, barMetrics: .default)
        seg.setBackgroundImage(image, for: .selected, barMetrics: .default)
        seg.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        seg.setDividerImage(
            image,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        
        return seg
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
        setUnderLinePosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(segment)
        segment.addSubview(underLineView)
        
        segment.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(vertical: 16))
        }
        underLineView.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.width.equalTo(78)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
    
    private func setUnderLinePosition() {
        
        /// setAutoLayout 시점에 아무런 값으로 레이아웃 잡고,
        /// layoutSubviews 시점에 제대로 된 값으로 초기화
        ///
        /// 이렇게 안하면, setBinding 시점에
        /// 없는 제약을 업데이트 하려 한다면서 에러 뱉음ㅡㅡ
        
        let offset = (segment.bounds.width/3) / 2
        let lineOffset = underLineView.bounds.width / 2
        
        underLineView.snp.updateConstraints {
            let inset = UIEdgeInsets(left: offset-lineOffset)
            $0.leading.equalToSuperview().inset(inset)
        }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        
        let selectedSegmentIndex = segment
            .rx.selectedSegmentIndex
            .asObservable()
        
        let input = TabContentsVM.Input(selectedSegmentIndex: selectedSegmentIndex)
        
        let output = tabContentsVM.transform(input: input)
        
        // 언더라인 뷰의 포지션을 맞추기위한 오프셋을 전달
        output.underLinePositionWillUpdate
            .bind(with: self) { owner, index in
                let tabWidth = owner.segment.bounds.width / 3
                let offset = tabWidth / 2
                let lineOffset = owner.underLineView.bounds.width / 2
                
                UIView.animate(withDuration: 0.3) {
                    owner.underLineView.snp.updateConstraints {
                        let inset = UIEdgeInsets(left: tabWidth*index+offset-lineOffset)
                        $0.leading.equalToSuperview().inset(inset)
                    }
                    owner.segment.layoutIfNeeded()
                }
            }
            .disposed(by: bag)
        
        // 현재 선택된 세그먼트 인덱스를 외부로 전달
        output.selectedSegmentIndex
            .bind(to: selectedSegmentIndexOutput)
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 80)) {
    TabContentsView()
}
