//
//  ESewaV2ViewController.swift
//  TestESewav2
//
//  Created by Aman Maharjan on 8/22/20.
//

import UIKit
import EsewaSDK

protocol ESewaViewControllerDelegate {
  func success(info: [String: Any])
  func failure(errorDescription: String)
}

class ESewaViewController: UIViewController {
  // Keep it in class instance
  var sdk: EsewaSDK?
  var eSewaDelegate: ESewaViewControllerDelegate?
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    initiatePayment()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(false)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.backButton.isHidden = false
      self.messageLabel.isHidden = false
    }
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func setUpView() {
    self.view.backgroundColor = UIColor(red: 65/255.0, green: 161/255.0, blue: 37/255.0, alpha: 1.0)
    backButton.layer.borderWidth = 1
    backButton.layer.borderColor = UIColor.white.cgColor
    backButton.layer.cornerRadius = 5
  }
  
  func initiatePayment() {
    // Start payment process
    sdk = EsewaSDK(inViewController: self, environment: .development, delegate: self)
    sdk?.initiatePayment(
      merchantId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      merchantSecret: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      productName: "Apple",
      productAmount: "200",
      productId: "100",
      callbackUrl: "abish.io"
    )
  }
}

extension ESewaViewController: EsewaSDKPaymentDelegate {
  func onEsewaSDKPaymentSuccess(info:[String:Any]) {
    // Called when the payment is success. Info contains the detail of transaction.
    self.eSewaDelegate?.success(info: info)
    self.dismiss(animated: true, completion: nil)
  }
  
  func onEsewaSDKPaymentError(errorDescription: String) {
    // Called when there is error with the description of the error.
    self.eSewaDelegate?.failure(errorDescription: errorDescription)
    self.dismiss(animated: true, completion: nil)
  }
}
