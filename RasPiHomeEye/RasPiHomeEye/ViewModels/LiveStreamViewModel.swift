//
//  LiveStreamViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/26/24.
//

import UIKit
import Starscream

// 실시간 스트리밍 WebSocket 통신을 관리하는 ViewModel
final class LiveStreamViewModel {
    // 업데이트된 이미지를 뷰 컨트롤러에 전달하기 위한 클로저
    var onImageUpdated: ((UIImage?) -> Void)?
    private var socket: WebSocket? // WebSocket 인스턴스 (통신 담당)
    
    // ViewModel 초기화 및 WebSocket 설정
    init() {
        setupWebSocket()
    }
    
    // WebSocket 설정 메서드
    private func setupWebSocket() {
        // WebSocket 서버 URL 생성 (IP 및 포트 설정)
        guard let url = URL(string: "ws://172.30.1.18:8080/stream") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5 // 요청 타임아웃: 5초
        
        // WebSocket 객체 생성 및 델리게이트 설정
        socket = WebSocket(request: request)
        socket?.delegate = self
    }
    
    // 스트리밍 시작: WebSocket 연결
    func startStreaming() {
        socket?.connect()
    }
    
    // 스트리밍 종료: WebSocket 연결 해제
    func stopStreaming() {
        socket?.disconnect()
    }
    
    // ViewModel 소멸 시 WebSocket 연결 해제
    deinit {
        socket?.disconnect()
    }
}

// WebSocketDelegate 프로토콜 구현
extension LiveStreamViewModel: WebSocketDelegate {
    // WebSocket 이벤트 처리 (WebSocket이 데이터를 받으면 호출)
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            // WebSocket 연결 성공 시 헤더 출력
            print("WebSocket 연결됨: \(headers)")
            
        case .binary(let data):
            // 수신한 이진 데이터를 UIImage로 변환
            if let image = UIImage(data: data) {
                // 메인 스레드에서 UI 업데이트 실행
                DispatchQueue.main.async { [weak self] in
                    self?.onImageUpdated?(image) // 이미지 업데이트 클로저 호출
                }
            }
            
        case .disconnected(let reason, let code):
            // WebSocket 연결 종료 시 이유와 코드 출력
            print("WebSocket 연결 끊김: \(reason) with code: \(code)")
            
        case .error(let error):
            // WebSocket 에러 발생 시 메시지 출력
            print("WebSocket 에러: \(error?.localizedDescription ?? "알 수 없는 에러")")
            
        case .text(let string):
            // 텍스트 메시지 수신 시 출력 (사용되지 않음)
            print("텍스트 메시지 수신: \(string)")
            
        case .cancelled:
            // WebSocket 연결 취소 시
            print("WebSocket 취소됨")
            
        case .ping(_), .pong(_), .viabilityChanged(_), .reconnectSuggested(_), .peerClosed:
            // 기타 이벤트 처리 (필요하지 않음)
            break
        }
    }
}
