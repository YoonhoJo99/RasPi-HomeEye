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
    // viewModel이 초기화되지 않은 상태에서는 nil일 수 있음
    // 그러나 값을 사용하는 시점에는 반드시 값이 존재한다고 가정
    // 만약, 값을 사용하려고 할 때 실제로 nil이면 런타임 에러가 발생

    // MARK: - UI Components

    private let temperatureLabel = UILabel().then {
        $0.text = "Temperature: --"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let humidityLabel = UILabel().then {
        $0.text = "Humidity: --"
        $0.font = .systemFont(ofSize: 16)
    }
    
    // MARK: - Lifecycle

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
    
    // MARK: - UI Setup

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
실행흐름
1. MQTT에서 새 데이터 수신
2. ViewModel에서 environmentData 업데이트
3. didSet 호출
4. ViewController에서 미리 정의해둔 클로저 실행
5. UI 업데이트
*/

/**
 environmentData에 didSet을 두고, 그 didSet이 변경된 enviromentData를 매개변수로 complteted를 호출하고
 complteted메소드 구현은 View에 하여 Viewew에서 UI코드를 업데이트 하도록 구조화하였음
 */
