//
//  WebSocketAPIManager.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/29/24.
//
import Foundation
import Starscream
import RealmSwift

final class WebSocketAPIManager {
    static let shared = WebSocketAPIManager()
    
    // WebSocket 관련
    private var socket: WebSocket?
    var onImageUpdated: ((UIImage?) -> Void)?
    
    // Realm 관련
    private let realm = try! Realm()
    
    private init() {
        setupWebSocket()
    }
    
    private func setupWebSocket() {
        guard let url = URL(string: "ws://172.30.1.18:8080") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket?.delegate = self
    }
    
    func startConnection() {
        socket?.connect()
    }
    
    func stopConnection() {
        socket?.disconnect()
    }
    
    // MARK: - Realm CRUD
    func fetchEvents() -> [Event] {
        let events = realm.objects(Event.self).sorted(byKeyPath: "timestamp", ascending: false)
        return Array(events)
    }
    
    func deleteEvent(_ event: Event) {
        try? realm.write {
            realm.delete(event)
        }
    }
    
    private func saveEvent(imageData: Data) {
        let event = Event(imageData: imageData)
        try? realm.write {
            realm.add(event)
        }
    }
    
    // 데이터 처리
    private func handleWebSocketData(_ data: Data) {
        do {
            if let jsonString = String(data: data, encoding: .utf8),
               let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let type = jsonData["type"] as? String,
               let base64Data = jsonData["data"] as? String,
               let imageData = Data(base64Encoded: base64Data) {
                
                switch type {
                case "stream":
                    // 스트리밍 데이터 처리
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.onImageUpdated?(image)
                        }
                    }
                    
                case "event":
                    // 이벤트 데이터 처리 (Realm에 저장)
                    DispatchQueue.main.async {
                        self.saveEvent(imageData: imageData)
                    }
                    
                default:
                    break
                }
            }
        } catch {
            print("JSON 파싱 에러: \(error)")
        }
    }
}

extension WebSocketAPIManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            print("✅ WebSocket 연결됨")
            
        case .text(let string):
            if let data = string.data(using: .utf8) {
                handleWebSocketData(data)
            }
            
        case .disconnected(let reason, _):
            print("❌ WebSocket 연결 끊김: \(reason)")
            
        case .error(let error):
            print("❌ WebSocket 에러: \(error?.localizedDescription ?? "Unknown error")")
            
        default:
            break
        }
    }
}
