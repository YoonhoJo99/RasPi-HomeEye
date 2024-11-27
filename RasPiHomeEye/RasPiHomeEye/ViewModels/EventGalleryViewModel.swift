//
//  EventGalleryViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/27/24.
//

import UIKit
import RealmSwift
import Starscream

final class EventGalleryViewModel {
   // MARK: - Properties
   private let realm = try! Realm()
   private var socket: WebSocket?
   
   // 데이터 변경 시 뷰 업데이트를 위한 클로저
   var onEventsUpdated: (([Event]) -> Void)?
   
   // MARK: - Initialize
   init() {
       setupWebSocket()
   }
   
   // MARK: - WebSocket
   private func setupWebSocket() {
       guard let url = URL(string: "ws://172.30.1.18:8081") else { return }
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
   func fetchEvents() {
       let events = realm.objects(Event.self).sorted(byKeyPath: "timestamp", ascending: false)
       onEventsUpdated?(Array(events))
   }
   
   func deleteEvent(_ event: Event) {
       try? realm.write {
           realm.delete(event)
       }
       fetchEvents()
   }
   
   private func saveEvent(imageData: Data) {
       let event = Event(imageData: imageData)
       try? realm.write {
           realm.add(event)
       }
       fetchEvents()
   }
}

// MARK: - WebSocket Delegate
extension EventGalleryViewModel: WebSocketDelegate {
   func didReceive(event: WebSocketEvent, client: WebSocketClient) {
       switch event {
       case .connected:
           print("✅ WebSocket 연결됨")
           
       case .binary(let data):
           DispatchQueue.main.async { [weak self] in
               self?.saveEvent(imageData: data)
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
