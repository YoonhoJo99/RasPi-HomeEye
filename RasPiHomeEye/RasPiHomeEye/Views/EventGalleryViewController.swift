//
//  EventGalleryViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

// Views/EventGalleryViewController.swift
import UIKit
import RealmSwift

final class EventGalleryViewController: UIViewController {
   // MARK: - Properties
   private let viewModel = EventGalleryViewModel()
   private var events: [Event] = []
   
   // MARK: - UI Components
   private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.minimumLineSpacing = 10
       layout.minimumInteritemSpacing = 10
       layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       
       let size = (UIScreen.main.bounds.width - 30) / 2
       layout.itemSize = CGSize(width: size, height: size)
       
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
       cv.backgroundColor = .white
       cv.register(EventCell.self, forCellWithReuseIdentifier: "EventCell")
       cv.delegate = self
       cv.dataSource = self
       return cv
   }()
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
       super.viewDidLoad()
       setupUI()
       setupViewModel()
       viewModel.fetchEvents()
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       viewModel.startConnection()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       viewModel.stopConnection()
   }
   
   // MARK: - Setup
   private func setupViewModel() {
       viewModel.onEventsUpdated = { [weak self] events in
           self?.events = events
           self?.collectionView.reloadData()
       }
   }
   
   private func setupUI() {
       view.backgroundColor = .white
       view.addSubview(collectionView)
       
       collectionView.snp.makeConstraints {
           $0.edges.equalTo(view.safeAreaLayoutGuide)
       }
       
       // 내비게이션 바 설정
       title = "Event Gallery"
       
       // 삭제 기능을 위한 편집 버튼 추가
       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(toggleEditing))
   }
   
   @objc private func toggleEditing() {
       collectionView.isEditing.toggle()
       navigationItem.rightBarButtonItem?.title = collectionView.isEditing ? "Done" : "Edit"
   }
}

// MARK: - UICollectionView DataSource & Delegate
extension EventGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return events.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCell
       let event = events[indexPath.item]
       cell.configure(with: event)
       return cell
   }
   
   // 셀 삭제 구현
   func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
       return true
   }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        if collectionView.isEditing {
            viewModel.deleteEvent(event)
        } else {
            let detailVC = EventDetailViewController(event: event, viewModel: viewModel)
            detailVC.modalPresentationStyle = .fullScreen
            present(detailVC, animated: true)
        }
    }
}
