//
//  EnvironmentMonitorView.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit
import SnapKit
import Then

final class EnvironmentMonitorView: UIView {
    
    // 제목 라벨
    private let nameLabel = UILabel().then {
        $0.text = "EnviromentMonitorView" //
        $0.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) // 색깔 변경 예정
        $0.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.backgroundColor = .white
    }
    
    private func addViews() {
        addSubview(nameLabel)
    }
    
    private func setConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(0)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
}
