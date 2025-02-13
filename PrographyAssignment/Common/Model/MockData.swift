//
//  MockData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import Foundation

final class MockData {
    
    let nameSpace = "https://image.tmdb.org/t/p/w500"
    
    static let backdropCarousel: [CarouselCellData] = [
        .init(
            title: "수퍼 소닉 3",
            overview: "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자, 세계 수호 통합 부대(약칭 세.수.통)에 의해 극비 소집된다. 소중한 것을 잃은 분노와 복수심에 불타는 섀도우는 소닉의 초고속 스피드와 너클즈의 최강 펀치를 단 단숨에 제압해버린다. 세상을 지배하려는 닥터 로보트닉과 그의 할아버지 제럴드 박사는 섀도우의 엄청난 힘 카오스 에너지를 이용해 인류를 정복하려고 하는데…",
            backDropPath: "https://image.tmdb.org/t/p/w500/zOpe0eHsq0A2NvNyBbtT6sj53qV.jpg"
        ),
        .init(
            title: "판다 플랜",
            overview: "액션 스타 재키가 우연히 전 세계적인 인기를 한 몸에 받고 있는 ‘후후’라는 아기 판다 구출 작전에 합류하게 되면서 벌어지는 이야기",
            backDropPath: "https://image.tmdb.org/t/p/w500/u7AZ5CdT2af8buRjmYCPXNyJssd.jpg"
        ),
        .init(
            title: "크레이븐 더 헌터",
            overview: "죽음의 문턱에서 맹수의 초인적인 힘을 얻고 살아 돌아온 크레이븐이 무자비한 복수의 길을 택하며 거침없는 사냥을 펼치는 액션 블록버스터",
            backDropPath: "https://image.tmdb.org/t/p/w500/v9Du2HC3hlknAvGlWhquRbeifwW.jpg"
        ),
    ]
}
