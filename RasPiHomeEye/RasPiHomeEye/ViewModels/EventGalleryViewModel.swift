//
//  EventGalleryViewModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/27/24.
//

import UIKit
import RealmSwift
import Starscream

// EventGalleryViewModel.swift
final class EventGalleryViewModel {
    private let webSocketManager = WebSocketAPIManager.shared
    var onEventsUpdated: (([Event]) -> Void)?
    
    func fetchEvents() {
        let events = webSocketManager.fetchEvents()
        onEventsUpdated?(events)
    }
    
    func deleteEvent(_ event: Event) {
        webSocketManager.deleteEvent(event)
        fetchEvents()
    }
}
