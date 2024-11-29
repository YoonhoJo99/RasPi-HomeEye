//
//  EventGalleryViewController.swift
//  RasPiHomeEye
//
//  Created by 조윤호 on 11/25/24.
//

import UIKit

// EventGalleryViewController.swift
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
    
   // EventGalleryViewController.swift
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       viewModel.fetchEvents()  // 화면이 나타날 때마다 데이터 새로 불러오기
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
       
       title = "Event Gallery"
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
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let event = events[indexPath.item]
       let detailVC = EventDetailViewController(event: event, viewModel: viewModel)
       detailVC.modalPresentationStyle = .fullScreen
       present(detailVC, animated: true)
   }
}
