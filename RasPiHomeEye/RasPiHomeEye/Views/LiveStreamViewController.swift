//
//  LiveStreamViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit
import SnapKit
import Then

final class LiveStreamViewController: UIViewController {
    
    // 뷰 선언 구간
    private let nameLabel = UILabel().then {
        $0.text = "LiveStreamView"
        $0.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        addViews()
        setupConstraints()
        setupAddTarget()
    }
    
    // 초기 설정
    private func configure() {
        view.backgroundColor = .white
    }
    
    // 서브뷰 추가
    private func addViews() {
        self.view.addSubview(nameLabel)
    }
    
    // 오토레이아웃 설정
    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupAddTarget() {
        // Add target 설정이 필요한 경우 여기에 구현
    }
}
