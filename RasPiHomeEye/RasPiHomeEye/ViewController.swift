//
//  ViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/23/24.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
   
   private var mqttClient: CocoaMQTT?
   
   override func viewDidLoad() {
       super.viewDidLoad()
       setupMQTT()
   }
   
   private func setupMQTT() {
       let clientID = "iOS_Client_" + String(ProcessInfo().processIdentifier)
       // 라즈베리파이 IP 주소로 변경해주세요
       mqttClient = CocoaMQTT(clientID: clientID, host: "172.30.1.18", port: 1883)
       mqttClient?.delegate = self
       mqttClient?.connect()
   }
}

extension ViewController: CocoaMQTTDelegate {
   func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
       print("✅ MQTT 브로커 연결됨")
       
       // 토픽 구독
       mqtt.subscribe([
          ("sensors/temperature", CocoaMQTTQoS.qos1),
          ("sensors/humidity", CocoaMQTTQoS.qos1),
          ("sensors/distance", CocoaMQTTQoS.qos1),
          ("sensors/light", CocoaMQTTQoS.qos1)
       ])
   }
   
   func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
       print("메시지 발행됨: \(message.string ?? "")")
   }
   
   func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
       print("메시지 발행 승인됨: \(id)")
   }
   
   func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
       print("📱 수신된 데이터: [\(message.topic)] -> \(message.string ?? "no data")")
   }
   
   func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
       print("구독 성공: \(success)")
       if !failed.isEmpty {
           print("구독 실패: \(failed)")
       }
   }
   
   func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
       print("구독 취소된 토픽들: \(topics)")
   }
   
   func mqttDidPing(_ mqtt: CocoaMQTT) {
       print("ping 전송됨")
   }
   
   func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
       print("pong 수신됨")
   }
   
   func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: (any Error)?) {
       if let error = err {
           print("❌ MQTT 연결 끊김: \(error.localizedDescription)")
       } else {
           print("MQTT 연결이 정상적으로 종료됨")
       }
   }
}

