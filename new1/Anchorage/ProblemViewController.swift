//
//  ProblemViewController.swift
//  Anchorage
//
//  Created by Joshua Park on 16/07/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import UIKit
import ProblemKit
import KRIndicatorController

/**
 The view controller that displays the problem UI.
 */

class ProblemViewController: UIViewController {
  private let ic = IndicatorController()
  
  var problem: Problem! {
    didSet {
      ic.increment()
      title = "\(problem.lesson!.id)-\(problem.id)"
      ProblemLoader.fetchProblem(id: problem.id) { problemData in
        self.problemView.displayProblem(problemData!)
        self.problemView.setProblemId(id: self.problem.id)
        self.problemView.refresh()
        self.ic.decrement()
      }
    }
  }
  
  @IBOutlet private var nextPanel: UIView!
  
  @IBOutlet private var nextButton: UIButton!
  
  private lazy var problemView: ProblemView = {
    let view = ProblemView.loadFromNib()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    view.setProblemId(id: problem.id)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupButton()
  }
  
  private func setupUI() {
    view.addSubview(problemView)
    
    problemView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    problemView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    problemView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    problemView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  private func setupButton() {
    let lesson = problem.lesson!
    let problemNumber = getProblemNumber(problemId: self.problem.id)
    let hasNext = problemNumber < lesson.problems.count
    if hasNext {
      nextButton.setTitle("Next", for: .normal)
    } else {
      nextButton.setTitle("Done", for: .normal)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
  // MARK: - Private
  
  @IBAction private func nextAction(_ sender: Any) {
    let lesson = problem.lesson!
    let problemNumber = getProblemNumber(problemId: self.problem.id)
    let hasNext = problemNumber < lesson.problems.count
    if hasNext {
      changeToNextProblem()
    } else {
      popViewController()
    }
  }
  
  private func changeToNextProblem() {
    animatePanel(isGoingUp: false) { [unowned self] _ in
      guard let lesson = self.problem.lesson else { return }
      let problemNumber: Int = self.getProblemNumber(problemId: self.problem.id)
      self.problem = lesson.problems[problemNumber]
      self.setupButton()
    }
  }
  
  private func getProblemNumber(problemId: Int) -> Int {
    if let lastChar = String(problemId).last {
      if let lastNumber = Int(String(lastChar)) {
        return lastNumber
      }
    }
    return -1
  }
  
  private func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func animatePanel(isGoingUp: Bool, completion: ((Bool) -> Void)? ) {
    view.bringSubview(toFront: nextPanel)
    let height = self.nextPanel.frame.height
    if isGoingUp {
      nextPanel.transform = CGAffineTransform(translationX: 0, y: height)
      UIView.animate(withDuration: 0.3, animations: {
        self.nextPanel.transform = CGAffineTransform.identity
      }, completion: completion)
    } else {
      UIView.animate(withDuration: 0.3, animations: {
        self.nextPanel.transform = CGAffineTransform(translationX: 0, y: height)
      }, completion: completion)
    }
  }
}

extension ProblemViewController: ProblemViewDelegate {
  func problemView(_ problemView: ProblemView, didSubmitAnswer: String) {
    problem.result = problemView.getResult()
    animatePanel(isGoingUp: true, completion: nil)
  }
}
