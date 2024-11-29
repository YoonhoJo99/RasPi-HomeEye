//
//  LiveStreamViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

// LiveStreamViewController.swift

import UIKit
import SnapKit
import Then

final class LiveStreamViewController: UIViewController {
    
    private var viewModel: LiveStreamViewModel! // ViewModel 인스턴스
    
    // MARK: - UI Components
//    private let nameLabel = UILabel().then {
//        $0.text = "LiveStreamView"
//        $0.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//        $0.font = .systemFont(ofSize: 20, weight: .heavy)
//        $0.textAlignment = .center
//    }
    
    // 스트리밍 이미지를 표시하는 이미지 뷰
    private let streamImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
    }
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel() // ViewModel 설정
        configure() // 기본 UI 설정
        addViews() // 서브뷰 추가
        setupConstraints() // AutoLayout 제약 조건 설정
    }
    
    // 화면이 나타날 때 WebSocket 연결 시작
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startStream()  // startStreaming -> startStream
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        viewModel.stopStream()   // stopStreaming -> stopStream
//    }
//    
    
    // MARK: - UI Setup
    
    // ViewModel 초기화 및 이미지 업데이트 클로저 설정
    // EnviromentViewModel 설정과는 다르게 해보았음 함수로 따로 뻄
    private func setupViewModel() {
        viewModel = LiveStreamViewModel()
        viewModel.onImageUpdated = { [weak self] image in
            self?.streamImageView.image = image // 이미지 뷰 업데이트
        }
    }
    
    // 기본 UI 설정 (배경색 설정)
    private func configure() {
        view.backgroundColor = .white
    }
    
    // 레이블 및 이미지 뷰를 뷰에 추가
    private func addViews() {
        [streamImageView].forEach { view.addSubview($0) }
    }
    
    // SnapKit을 사용한 AutoLayout 제약 조건 설정
    private func setupConstraints() {
//        nameLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0) // 상단 안전 영역에 정렬
//            $0.centerX.equalTo(view.safeAreaLayoutGuide) // 가로 중앙 정렬
//        }
        
        streamImageView.snp.makeConstraints {
            $0.center.equalToSuperview() // center는 centerX와 centerY 모두 설정
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(streamImageView.snp.width).multipliedBy(0.75)
        }
    }
}
