//
//  EnvironmentMonitorViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit

final class EnvironmentMonitorViewController: UIViewController {
    
    private let enviromentView = EnvironmentMonitorView()
    
    override func loadView() {
        // -> viewDidLoad()보다 먼저 호출이 되는 메소드 -> 기본 view를 교체해줄 수 있음
        // super.loadView() 필요없음
        view = enviromentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
    }
    
    func setupAddTarget() { }
}
