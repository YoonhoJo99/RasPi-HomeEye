//
//  LiveStreamViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

// LiveStreamViewController.swift

import UIKit
import SnapKit
import Then

final class LiveStreamViewController: UIViewController {
    private var viewModel: LiveStreamViewModel!
    
    private let nameLabel = UILabel().then {
        $0.text = "LiveStreamView"
        $0.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.textAlignment = .center
    }
    
    private let streamImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        configure()
        addViews()
        setupConstraints()
    }
    
    private func setupViewModel() {
        viewModel = LiveStreamViewModel()
        viewModel.onImageUpdated = { [weak self] image in
            self?.streamImageView.image = image
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func addViews() {
        [nameLabel, streamImageView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        streamImageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(streamImageView.snp.width).multipliedBy(0.75)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startStreaming()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopStreaming()
    }
}
