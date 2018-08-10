//
//  FilterViewController.swift
//  ZigZag
//
//  Created by junwoo on 06/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit

@objc protocol FilterViewDelegate {
  
  func filterView(ages: [Int], styles: [String])
}

class FilterViewController: UIViewController {
  private var totalStyleArr: [String]
  weak var delegate: FilterViewDelegate?
  private lazy var topView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .yellow
    return view
  }()
  
  private lazy var topLabel: UILabel = {
    let label = UILabel()
    label.text = "쇼핑몰 필터"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Back", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    return button
  }()
  private var itemsPerRow: CGFloat = 4
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: CGRect.zero,
                                collectionViewLayout: UICollectionViewFlowLayout())
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
    view.dataSource = self
    view.allowsMultipleSelection = true
    return view
  }()
  
  init(styles: [String]) {
    self.totalStyleArr = styles
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = .white
    view.addSubview(topView)
    topView.addSubview(topLabel)
    topView.addSubview(backButton)
    view.addSubview(collectionView)
    
    topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    topView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    topLabel.sizeToFit()
    topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    topLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
    
    backButton.sizeToFit()
    backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10).isActive = true
    backButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
    
    collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  @objc func goBack() {
    dismiss(animated: true) { [unowned self] in 
      var selectedAges: [Int] = []
      var selectedStyles: [String] = []
      if let selected: [IndexPath] = self.collectionView.indexPathsForSelectedItems {
        for indexPath in selected {
          if indexPath.section == 0 {
            selectedAges.append(indexPath.item)
          } else {
            let style = self.totalStyleArr[indexPath.item]
            selectedStyles.append(style)
          }
        }
      }
      self.delegate?.filterView(ages: selectedAges, styles: selectedStyles)
    }
  }
}

extension FilterViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return Shop.generation.count
    } else {
      return totalStyleArr.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier,
                                                     for: indexPath) as? FilterCell {
      if indexPath.section == 0 {
        cell.configure(title: Shop.generation[indexPath.item])
      } else {
        cell.configure(title: totalStyleArr[indexPath.item])
      }
      return cell
    }
    return UICollectionViewCell()
  }
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 1 {
      itemsPerRow = 3
    }
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = UIScreen.main.bounds.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
