//
//  ListViewController.swift
//  ZigZag
//
//  Created by junwoo on 05/08/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  
  private lazy var tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
    table.dataSource = self
    table.rowHeight = 100
    table.delegate = self
    return table
  }()
  
  private lazy var filterButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Filter", for: .normal)
    button.addTarget(self, action: #selector(goToFilterViewController), for: .touchUpInside)
    button.layer.borderWidth = 0.5
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .white
    button.sizeToFit()
    return button
  }()
  private var shopList: [Shop] = []
  private var cachList: [Shop] = []
  private var styleSet = Set<String>()
  private var cacheImageDict: [String:UIImage?] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    fetchList { [unowned self] list in
      self.shopList = list.sorted(by: { (shop1, shop2) -> Bool in
        return shop1.rank > shop2.rank
      })
      self.cachList = self.shopList
      self.getTotalStyles()
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  func setupUI() {
    view.backgroundColor = .white
    view.addSubview(tableView)
    
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }
  
  func getTotalStyles() {
    shopList.forEach { shop in
      for style in shop.getStyleArr() {
        styleSet.insert(style)
      }
    }
  }
  
  func fetchList(completion: @escaping ([Shop]) -> Void) {
    let url = Bundle.main.url(forResource: "shop_list",
                              withExtension: "json")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      //print(Thread.isMainThread)
      if error != nil {
        print(error.debugDescription)
        return
      }
      do {
        let shopList = try JSONDecoder().decode(ShopList.self, from: data!)
        completion(shopList.list)
      } catch {
        print("fetch error")
        completion([])
      }
    }.resume()
  }
  
  @objc func goToFilterViewController() {
    let filterViewController = FilterViewController(styles: Array(styleSet).sorted())
    filterViewController.delegate = self
    present(filterViewController, animated: true, completion: nil)
  }
}

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shopList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier) as? ListCell {
      
      let shop = shopList[indexPath.row]
      cell.configCell(shop: shop, index: indexPath.row)
      return cell
    }
    return UITableViewCell()
  }
  
}

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = .yellow
    header.addSubview(filterButton)
    filterButton.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
    filterButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10).isActive = true
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }
}

extension ListViewController: FilterViewDelegate {
  func filterView(ages: [Int], styles: [String]) {
    if ages.count + styles.count == 0 {
      shopList = cachList
    }
    if ages.count > 0 {
      shopList = shopList.filter{ $0.isMatchedByAge(selectedIndex: ages) }
    }
    if styles.count > 0 {
      shopList = shopList.filter{ $0.styleMatchCount(selectedStyle: styles) > 0 }
        .sorted(by: { (shop1, shop2) -> Bool in
        if shop1.styleMatchCount(selectedStyle: styles) != shop2.styleMatchCount(selectedStyle: styles) {
          return shop1.styleMatchCount(selectedStyle: styles) > shop2.styleMatchCount(selectedStyle: styles)
        } else {
          return shop1.rank > shop2.rank
        }
      })
    }
    tableView.reloadData()
  }
  
}
