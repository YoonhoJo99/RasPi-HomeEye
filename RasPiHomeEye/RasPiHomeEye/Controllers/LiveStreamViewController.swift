//
//  LiveStreamViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit

final class LiveStreamViewController: UIViewController {
    
    private let liveStreamView = LiveStreamView()
    
    override func loadView() {
        view = liveStreamView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
    }
    
    func setupAddTarget() { }
}
