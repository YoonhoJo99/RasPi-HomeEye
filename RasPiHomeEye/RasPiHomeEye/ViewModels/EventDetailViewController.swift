//
//  EventDetailViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/27/24.
//

// Views/EventDetailViewController.swift
import UIKit

final class EventDetailViewController: UIViewController {
    // MARK: - Properties
    private let event: Event
    private let viewModel: EventGalleryViewModel
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .black
        return iv
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Initialize
    init(event: Event, viewModel: EventGalleryViewModel) {
        self.event = event
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        // 이미지 설정
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if let imageData = event.imageData,
           let image = UIImage(data: imageData) {
            imageView.image = image
        }
        
        // 삭제 버튼 설정
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(44)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "삭제",
            message: "이 이벤트를 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "예", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteEvent(self.event)
            self.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
