//
//  ViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/23/24.
//

import UIKit
import CocoaMQTT

// ViewController 클래스 정의
class ViewController: UIViewController {
    
    // CocoaMQTT 클라이언트 객체를 저장할 변수
    private var mqttClient: CocoaMQTT?
    
    // 뷰가 로드될 때 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMQTT()  // MQTT 설정 함수 호출
    }
    
    // MQTT 클라이언트를 초기화하고 설정하는 함수
    private func setupMQTT() {
        let clientID = "iOS_Client_" + String(ProcessInfo().processIdentifier)
        // 고유 클라이언트 ID 생성 (프로세스 ID를 포함하여 중복 방지)
        
        mqttClient = CocoaMQTT(clientID: clientID, host: "172.30.1.18", port: 1883)
        // MQTT 클라이언트 생성 (호스트는 라즈베리파이 IP, 포트는 1883 기본 MQTT 포트)
        
        mqttClient?.delegate = self
        // MQTT 클라이언트의 delegate 설정 (이 클래스에서 이벤트 처리)
        
        if mqttClient?.connect() == true {
            print("✅ MQTT 연결 시도 시작됨")
        } else {
            print("❌ MQTT 연결 시도 실패")
        }
        // MQTT 브로커에 연결 요청
    }
}

// CocoaMQTTDelegate 프로토콜을 준수하는 익스텐션
extension ViewController: CocoaMQTTDelegate {
    
    // MQTT 브로커와 연결 성공 시 호출되는 메서드
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("✅ MQTT 브로커 연결됨")
        
        // 여러 토픽을 구독
        mqtt.subscribe([
            ("sensors/temperature", CocoaMQTTQoS.qos1),  // 온도 센서 데이터
            ("sensors/humidity", CocoaMQTTQoS.qos1),    // 습도 센서 데이터
//            ("sensors/distance", CocoaMQTTQoS.qos1),    // 초음파 거리 데이터
//            ("sensors/light", CocoaMQTTQoS.qos1)        // 조도 센서 데이터
        ])
    }
    
    // MQTT 토픽 구독 성공/실패 시 호출되는 메서드
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("구독 성공: \(success)")
        // 성공한 토픽 출력
        
        if !failed.isEmpty {
            print("구독 실패: \(failed)")
            // 실패한 토픽 출력
        }
    }
    
    // MQTT 메시지를 수신했을 때 호출되는 메서드
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("📱 수신된 데이터: [\(message.topic)] -> \(message.string ?? "no data")")
        // 토픽과 메시지를 출력
    }
    
    // MQTT 연결이 끊어졌을 때 호출되는 메서드
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: (any Error)?) {
        if let error = err {
            print("❌ MQTT 연결 끊김: \(error.localizedDescription)")
            // 에러 메시지를 출력
        } else {
            print("MQTT 연결이 정상적으로 종료됨")
            // 정상 종료 메시지 출력
        }
    }
    
    // MQTT 메시지가 발행되었을 때 호출되는 메서드
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) { }
    
    // MQTT 메시지가 성공적으로 발행되었을 때 호출되는 메서드
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) { }
    
    // MQTT 토픽 구독 취소 시 호출되는 메서드
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) { }
    
    // MQTT 클라이언트가 ping을 전송했을 때 호출되는 메서드
    func mqttDidPing(_ mqtt: CocoaMQTT) { }
    
    // MQTT 클라이언트가 pong을 수신했을 때 호출되는 메서드
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) { }
}
