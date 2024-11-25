//
//  EnvironmentMonitorViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class EnvironmentMonitorViewController: UIViewController {
    
    private var viewModel: EnvironmentViewModel!
    
    private let temperatureLabel = UILabel().then {
        $0.text = "Temperature: --"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let humidityLabel = UILabel().then {
        $0.text = "Humidity: --"
        $0.font = .systemFont(ofSize: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰모델 생성
        self.viewModel = EnvironmentViewModel()
        
        // 데이터 변경 시 실행될 클로저 설정
        self.viewModel.onCompleted = { [weak self] _ in
            DispatchQueue.main.async {
                self?.temperatureLabel.text = "Temperature: \(self?.viewModel.temperatureString ?? "--")"
                self?.humidityLabel.text = "Humidity: \(self?.viewModel.humidityString ?? "--")"
            }
        }
        
        // MQTT 연결 시작
        viewModel.setupMQTTConnection()
        
        configure()
        addViews()
        setupConstraints()
    }
    
    // UI 설정 메서드들...
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        [temperatureLabel, humidityLabel].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        temperatureLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
