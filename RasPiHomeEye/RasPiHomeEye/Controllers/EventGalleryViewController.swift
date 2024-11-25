//
//  EventGalleryViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit

final class EventGalleryViewController: UIViewController {
    
    private let eventGalleryView = EventGalleryView()
    
    override func loadView() {
        view = eventGalleryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
    }
    
    func setupAddTarget() { }
}
