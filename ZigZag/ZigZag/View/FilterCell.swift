//
//  FilterCell.swift
//  ZigZag
//
//  Created by junwoo on 06/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
  
  static let reuseIdentifier: String = "ListCell"
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.layer.borderWidth = 0.5
    label.layer.cornerRadius = 10
    label.textAlignment = .center
    return label
  }()
  
  override var isSelected: Bool {
    didSet {
      backgroundColor = isSelected ? .green : .white
    }
  }
  
  func configure(title: String) {
    titleLabel.text = title
    
    addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    isSelected = false
  }
}
