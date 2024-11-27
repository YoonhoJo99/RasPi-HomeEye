//
//  EventModel.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/27/24.
//

import Foundation
import RealmSwift

class Event: Object {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var timestamp: Date = Date()
    @Persisted var imageData: Data?
    
    convenience init(imageData: Data) {
        self.init()
        self.imageData = imageData
    }
}
