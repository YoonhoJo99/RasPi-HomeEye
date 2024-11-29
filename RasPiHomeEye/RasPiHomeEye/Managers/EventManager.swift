//
//  EventManager.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/27/24.
//


//import Foundation
//import RealmSwift
//import Starscream
//
//final class EventManager {
//    static let shared = EventManager()
//    
//    private let realm = try! Realm()
//    private var socket: WebSocket?
//    var onNewEventSaved: (() -> Void)?
//    
//    private init() {
//        setupWebSocket()
//    }
//    
//    private func setupWebSocket() {
//        guard let url = URL(string: "ws://172.30.1.18:8081") else { return }
//        var request = URLRequest(url: url)
//        request.timeoutInterval = 5
//        
//        socket = WebSocket(request: request)
//        socket?.delegate = self
//        startConnection()
//    }
//    
//    func startConnection() {
//        socket?.connect()
//    }
//    
//    func stopConnection() {
//        socket?.disconnect()
//    }
//    
//    func fetchEvents() -> [Event] {
//        let events = realm.objects(Event.self).sorted(byKeyPath: "timestamp", ascending: false)
//        return Array(events)
//    }
//    
//    func deleteEvent(_ event: Event) {
//        try? realm.write {
//            realm.delete(event)
//        }
//    }
//    
//    private func saveEvent(imageData: Data) {
//        let event = Event(imageData: imageData)
//        try? realm.write {
//            realm.add(event)
//        }
//        onNewEventSaved?()
//    }
//}
//
//extension EventManager: WebSocketDelegate {
//    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
//        switch event {
//        case .connected:
//            print("✅ WebSocket 연결됨")
//            
//        case .binary(let data):
//            DispatchQueue.main.async { [weak self] in
//                self?.saveEvent(imageData: data)
//            }
//            
//        case .disconnected(let reason, _):
//            print("❌ WebSocket 연결 끊김: \(reason)")
//            
//        case .error(let error):
//            print("❌ WebSocket 에러: \(error?.localizedDescription ?? "Unknown error")")
//            
//        default:
//            break
//        }
//    }
//}
