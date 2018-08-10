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
  @IBOutlet private var button1: UIButton!
  
  @IBOutlet private var button2: UIButton!
  
  @IBOutlet private var button3: UIButton!
  
  private var lesson: Lesson? = nil
  
  private lazy var buttons: [UIButton] = {
    return [button1, button2, button3]
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ic.increment()
    fetchLesson { [unowned self] lesson in
      self.lesson = lesson
      self.setButton()
      self.setButtonColor()
      self.ic.decrement()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setButtonColor()
    //print(lesson?.problems[0].result)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setButton() {
    if let lesson = lesson {
      let problems = lesson.problems
      for i in 0..<buttons.count {
        buttons[i].tag = i
        buttons[i].setTitle("\(problems[i].id)", for: .normal)
        buttons[i].addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
      }
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
    let url  = Bundle.main.url(forResource: "lesson1",
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
