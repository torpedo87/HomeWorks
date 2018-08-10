//
//  ListCell.swift
//  ZigZag
//
//  Created by junwoo on 05/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
  static let reuseIdentifier: String = "ListCell"
  
  private lazy var containerGuide: UILayoutGuide = {
    let container = UILayoutGuide()
    return container
  }()
  
  private lazy var rankLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    return label
  }()
  private lazy var imgView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.backgroundColor = .lightGray
    view.clipsToBounds = true
    return view
  }()
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private lazy var ageLabel: UILabel = {
    let label = UILabel()
    label.layer.borderWidth = 0.5
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private lazy var styleLabelView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private var styleLabels = [UILabel]()
  
  func setupUI() {
    addLayoutGuide(containerGuide)
    addSubview(rankLabel)
    addSubview(imgView)
    addSubview(titleLabel)
    addSubview(ageLabel)
    addSubview(styleLabelView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerGuide.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    containerGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    containerGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    containerGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    
    rankLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
    rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    rankLabel.leadingAnchor.constraint(equalTo: containerGuide.leadingAnchor).isActive = true
    
    imgView.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 10).isActive = true
    imgView.topAnchor.constraint(equalTo: containerGuide.topAnchor).isActive = true
    imgView.bottomAnchor.constraint(equalTo: containerGuide.bottomAnchor).isActive = true
    imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
    imgView.layer.cornerRadius = containerGuide.layoutFrame.height / 2
    
    titleLabel.topAnchor.constraint(equalTo: containerGuide.topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: containerGuide.centerYAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: containerGuide.trailingAnchor).isActive = true
    
    ageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
    ageLabel.bottomAnchor.constraint(equalTo: containerGuide.bottomAnchor).isActive = true
    ageLabel.sizeToFit()
    
    styleLabelView.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 10).isActive = true
    styleLabelView.topAnchor.constraint(equalTo: ageLabel.topAnchor).isActive = true
    styleLabelView.bottomAnchor.constraint(equalTo: ageLabel.bottomAnchor).isActive = true
    styleLabelView.trailingAnchor.constraint(equalTo: containerGuide.trailingAnchor).isActive = true
    
    styleLabels.forEach {
      styleLabelView.addSubview($0)
    }
    
    var lastLabel: UILabel?
    for i in 0..<styleLabels.count {
      let label = styleLabels[i]
      label.sizeToFit()
      if i == 0 {
        label.leadingAnchor.constraint(equalTo: styleLabelView.leadingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: styleLabelView.centerYAnchor).isActive = true
      } else {
        if let last = lastLabel {
          label.leadingAnchor.constraint(equalTo: last.trailingAnchor).isActive = true
          label.centerYAnchor.constraint(equalTo: last.centerYAnchor).isActive = true
        }
      }
      lastLabel = label
    }
  }
  
  func configCell(shop: Shop, index: Int) {
    rankLabel.text = "\(index + 1)"
    titleLabel.text = shop.name + " rank : \(shop.rank)"
    ageLabel.text = shop.convertToGeneration()
    
    let styles = shop.styles.components(separatedBy: ",").sorted()
    for i in 0..<styles.count {
      let label = UILabel()
      label.layer.borderWidth = 0.5
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = styles[i]
      self.styleLabels.append(label)
    }
    
    let title: String = shop.url.components(separatedBy: ".")[1]
    if let imgUrl = URL(string: "https://cf.shop.s.zigzag.kr/images/\(title).jpg") {
      URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
        if error != nil {
          print(error.debugDescription)
          return
        }
        if let image = UIImage(data: data!) {
          DispatchQueue.main.async {
            self.imgView.image = image
          }
        }
      }.resume()
    }
    
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    rankLabel.text = nil
    titleLabel.text = nil
    ageLabel.text = nil
    imgView.image = nil
    styleLabels = []
    
    styleLabelView.subviews.forEach {
      $0.removeFromSuperview()
    }
  }
}
