//
//  LiveStreamViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/26/24.
//

// LiveStreamViewModel.swift
import UIKit
import Starscream

final class LiveStreamViewModel {
    // 클로저를 통해 이미지 업데이트를 뷰컨트롤러에 전달
    var onImageUpdated: ((UIImage?) -> Void)?
    private var socket: WebSocket?
    
    init() {
        setupWebSocket()
    }
    
    private func setupWebSocket() {
        guard let url = URL(string: "ws://172.30.1.18:8080/stream") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket?.delegate = self
    }
    
    func startStreaming() {
        socket?.connect()
    }
    
    func stopStreaming() {
        socket?.disconnect()
    }
    
    deinit {
        socket?.disconnect()
    }
}

extension LiveStreamViewModel: WebSocketDelegate {
   func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
       switch event {
       case .connected(let headers):
           print("WebSocket 연결됨: \(headers)")
           
       case .binary(let data):
           if let image = UIImage(data: data) {
               DispatchQueue.main.async { [weak self] in
                   self?.onImageUpdated?(image)
               }
           }
           
       case .disconnected(let reason, let code):
           print("WebSocket 연결 끊김: \(reason) with code: \(code)")
           
       case .error(let error):
           print("WebSocket 에러: \(error?.localizedDescription ?? "알 수 없는 에러")")
           
       case .text(let string):
           print("텍스트 메시지 수신: \(string)")
           
       case .cancelled:
           print("WebSocket 취소됨")
           
       case .ping(_):
           break
           
       case .pong(_):
           break
           
       case .viabilityChanged(_):
           break
           
       case .reconnectSuggested(_):
           break
           
       case .peerClosed:
           print("peer closed")
       }
   }
}
