//
//  EnviromentViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import Foundation
import CocoaMQTT

final class EnvironmentViewModel {
    
    // 핵심 데이터(모델) (데이터를 저장하는 프로피터)
    var environmentData: EnvironmentData? {
        didSet { // 값이 변경될 때 마다 실행
            onCompleted(environmentData)
        }
    }
    
    // View에서 사용할 데이터 (가공된 형태)
    var temperatureString: String? {
        return environmentData?.temperature
    }
    
    var humidityString: String? {
        return environmentData?.humidity
    }
    
    // 클로저 선언
    var onCompleted: (EnvironmentData?) -> Void = { _ in }
    
    private var mqttClient: CocoaMQTT?
    
    //  MQTT 연결 설정 함수
    func setupMQTTConnection() {
        
        // 고유한 클라이언트 ID 생성
        let clientID = "iOS_Client_" + String(ProcessInfo().processIdentifier)
        
        // MQTT 클라이언트 생성 (서버 정보 설정)
        mqttClient = CocoaMQTT(clientID: clientID, host: "172.30.1.18", port: 1883)
        mqttClient?.delegate = self  // delegate 설정
        
        if mqttClient?.connect() == true {
            print("✅ MQTT 연결 시도 시작됨")
        } else {
            print("❌ MQTT 연결 시도 실패")
        }
    }
}

// MQTT Delegate 처리
extension EnvironmentViewModel: CocoaMQTTDelegate {
    
    // 연결 성공했을 때
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("✅ MQTT 브로커 연결됨")
        // 센서 데이터 토픽 구독
        mqtt.subscribe([
            ("sensors/temperature", CocoaMQTTQoS.qos1),
            ("sensors/humidity", CocoaMQTTQoS.qos1)
        ])
    }
    
    // 데이터를 받았을 때
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        switch message.topic { // 토픽에 따라 구분
        case "sensors/temperature": // 온도 데이터 업데이트
            let newTemp = message.string
            let currentHumidity = environmentData?.humidity
            environmentData = EnvironmentData(temperature: newTemp, humidity: currentHumidity)
            
        case "sensors/humidity": // 습도 데이터 업데이트
            let currentTemp = environmentData?.temperature
            let newHumidity = message.string
            environmentData = EnvironmentData(temperature: currentTemp, humidity: newHumidity)
            
        default:
            break
        }
    }
    
    // 필수 delegate 메서드들... (사용하지 않아도 정의는 해야함)
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("구독 성공: \(success)")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: (any Error)?) {
        if let error = err {
            print("❌ MQTT 연결 끊김: \(error)")
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {}
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
}
