//
//  EnvironmentMonitorViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit
import SnapKit
import Then

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
        // UI 업데이트는 반드시 메인 쓰레드에서 실행되어야 함
        // MQTT에서 데이터가 백그라운드 쓰레드로 들어오기 때문에, UI 업데이트를 메인 쓰레드로 보내는 역할
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

/**
1. MQTT에서 새 데이터 수신
2. ViewModel에서 environmentData 업데이트
3. didSet 호출
4. ViewController에서 미리 정의해둔 클로저 실행
5. UI 업데이트
*/

/**
 environmentData에 didSet을 두고, 그 didSet이 변경된 enviromentData를 매개변수로 complteted를 호출하고
 complteted메소드 구현은 View에 하여 Viewew에서 UI코드를 업데이트 하도록 구조화한거구나
 */