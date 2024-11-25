//
//  EnviromentViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import Foundation
import CocoaMQTT

final class EnvironmentViewModel {
    
    // 핵심 데이터(모델)
    var environmentData: EnvironmentData? {
        didSet {
            onCompleted(environmentData)
        }
    }
    
    // 뷰를 위한 데이터 (Output)
    var temperatureString: String? {
        return environmentData?.temperature
    }
    
    var humidityString: String? {
        return environmentData?.humidity
    }
    
    // 클로저 선언
    var onCompleted: (EnvironmentData?) -> Void = { _ in }
    
    private var mqttClient: CocoaMQTT?
    
    // Input (MQTT 연결 및 데이터 수신 처리)
    func setupMQTTConnection() {
        let clientID = "iOS_Client_" + String(ProcessInfo().processIdentifier)
        mqttClient = CocoaMQTT(clientID: clientID, host: "172.30.1.18", port: 1883)
        mqttClient?.delegate = self
        
        if mqttClient?.connect() == true {
            print("✅ MQTT 연결 시도 시작됨")
        } else {
            print("❌ MQTT 연결 시도 실패")
        }
    }
}

// MQTT Delegate 처리
extension EnvironmentViewModel: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("✅ MQTT 브로커 연결됨")
        mqtt.subscribe([
            ("sensors/temperature", CocoaMQTTQoS.qos1),
            ("sensors/humidity", CocoaMQTTQoS.qos1)
        ])
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        switch message.topic {
        case "sensors/temperature":
            let newTemp = message.string
            let currentHumidity = environmentData?.humidity
            environmentData = EnvironmentData(temperature: newTemp, humidity: currentHumidity)
            
        case "sensors/humidity":
            let currentTemp = environmentData?.temperature
            let newHumidity = message.string
            environmentData = EnvironmentData(temperature: currentTemp, humidity: newHumidity)
            
        default:
            break
        }
    }
    
    // 필수 delegate 메서드들...
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
