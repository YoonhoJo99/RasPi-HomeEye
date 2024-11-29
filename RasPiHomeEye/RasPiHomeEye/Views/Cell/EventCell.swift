//
//  EventCell.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/27/24.
//

import UIKit
import SnapKit

// EventCell.swift
final class EventCell: UICollectionViewCell {
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(timeLabel)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    func configure(with event: Event) {
        if let imageData = event.imageData,
           let image = UIImage(data: imageData) {
            imageView.image = image
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = dateFormatter.string(from: event.timestamp)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        timeLabel.text = nil
    }
}
