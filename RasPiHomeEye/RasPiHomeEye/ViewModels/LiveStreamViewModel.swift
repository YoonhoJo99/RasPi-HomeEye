//
//  LiveStreamViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/26/24.
//

import UIKit

// LiveStreamViewModel.swift
final class LiveStreamViewModel {
    private let webSocketManager = WebSocketAPIManager.shared
    var onImageUpdated: ((UIImage?) -> Void)?
    
    init() {
        setupBinding()
    }
    
    private func setupBinding() {
        webSocketManager.onImageUpdated = { [weak self] image in
            self?.onImageUpdated?(image)
        }
    }
    
    func startStream() {
        webSocketManager.startConnection()
    }
    
    func stopStream() {
        webSocketManager.stopConnection()
    }
}

