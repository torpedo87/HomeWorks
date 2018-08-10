//
//  ProblemListViewController.swift
//  Anchorage
//
//  Created by Joshua Park on 16/07/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import UIKit
import KRIndicatorController

/**
 The initially displayed view controller when launching `Anchorage`.
 */
class ProblemListViewController: UIViewController {
  private let ic = IndicatorController()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.distribution = .fillEqually
    view.spacing = 10
    return view
  }()
  private var buttons: [UIButton] = []
  
  private var lesson: Lesson? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    ic.increment()
    fetchLesson { [unowned self] lesson in
      self.lesson = lesson
      self.setupButton(problems: lesson.problems)
      self.setButtonColor()
      self.ic.decrement()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setButtonColor()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupUI() {
    view.addSubview(stackView)
    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
  }
  
  private func setupButton(problems: [Problem]) {
    for i in 0..<problems.count {
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.tag = i
      button.setTitle("\(i+1)", for: .normal)
      self.buttons.append(button)
      self.stackView.addArrangedSubview(button)
      button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
    }
    
  }
  
  private func setButtonColor() {
    if let lesson = lesson {
      let problems = lesson.problems
      for i in 0..<buttons.count {
        if let result = problems[i].result {
          buttons[i].backgroundColor = result ? UIColor(hex: "86D750") : UIColor(hex: "D30023")
        } else {
          buttons[i].backgroundColor = UIColor(hex: "DBDBDB")
        }
      }
    }
  }
  
  private func fetchLesson(completion: @escaping (Lesson) -> Void) {
    // Assume data is asynchronously downloaded from a remote server.
    simulateHTTPRequest { (data) in
      // TODO: Convert data to lesson object
      let decoder = JSONDecoder()
      do {
        let lesson = try decoder.decode(Lesson.self, from: data)
        lesson.problems.forEach{ $0.lesson = lesson }
        completion(lesson)
      } catch {
        print("lesson decode error")
      }
    }
  }
  
  private func simulateHTTPRequest(_ completion: @escaping (Data) -> Void) {
    let url  = Bundle.main.url(forResource: "lesson2-2",
                               withExtension: "json")!,
    data = try! Data(contentsOf: url)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
    {
      completion(data)
    }
  }
  
  @objc func buttonTapped(button: UIButton) {
    let problemViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "problemVC") as! ProblemViewController
    problemViewController.problem = lesson?.problems[button.tag]
    self.navigationController?.pushViewController(problemViewController, animated: true)
  }
}
