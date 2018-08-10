//
//  ProblemView.swift
//  ProblemKit
//
//  Created by Joshua Park on 16/07/2018.
//  Copyright © 2018 Knowre. All rights reserved.
//

import UIKit

@objc public protocol ProblemViewDelegate {
  
  func problemView(_ problemView: ProblemView,
                   didSubmitAnswer: String)
  
}

public class ProblemView: UIView {
  
  /// A factory method to instantiate a `ProblemView` object
  /// from the Interface Builder.
  public class func loadFromNib() -> ProblemView {
    let bundle = Bundle(for: ProblemView.self),
    nib    = bundle.loadNibNamed("ProblemView", owner: nil, options: nil)!
    
    return nib[0] as! ProblemView
  }
  
  @IBOutlet public weak var delegate: ProblemViewDelegate?
  
  @IBOutlet private var problemLabel: UILabel!
  
  @IBOutlet private var textField: UITextField!
  
  @IBOutlet private var submitButton: UIButton!
  
  @IBOutlet private var resultImageView: UIImageView!
  
  // MARK: - Public
  private var id: Int!
  private var result: Bool?
  /**
   Displays the problem on view.
   
   - Parameter problem: The problem data to display.
   */
  
  public func displayProblem(_ problem: ProblemData) {
    problemLabel.text = problem.problem
  }
  
  public func refresh() {
    textField.text = nil
    submitButton.isEnabled = false
    resultImageView.image = nil
  }
  
  public func getResult() -> Bool? {
    return result
  }
  
  public func setProblemId(id: Int) {
    self.id = id
  }
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview()
    textField.delegate = self
    submitButton.isEnabled = false
  }
  
  /**
   Displays the result on view.
   
   - Parameter result: The result of solving the problem.
   */
  public func displayResult(_ result: Bool) {
    resultImageView.image = result ? UIImage(named: "correct") : UIImage(named: "incorrect")
  }
  
  
  
  // MARK: - Private
  
  @IBAction private func submitAction(_ sender: Any) {
    assert(textField.text != nil)
    
    ProblemLoader.checkAnswer(textField.text!, id: id) { [unowned self] bool in
      if let bool = bool {
        //print(Thread.isMainThread)
        self.result = bool
        self.displayResult(bool)
        self.delegate?.problemView(self, didSubmitAnswer: self.textField.text!)
      }
    }
  }
}

extension ProblemView: UITextFieldDelegate {

  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let textString : NSString = textField.text as! NSString
    let newTextString = textString.replacingCharacters(in: range, with: string)
    submitButton.isEnabled = newTextString.count != 0
    return true
  }
}
