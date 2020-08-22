//
//  ESewaV2ViewController.swift
//  TestESewav2
//
//  Created by Aman Maharjan on 8/22/20.
//

import UIKit
import EsewaSDK

protocol <#name#> {
  <#requirements#>
}

class ESewaViewController: UIViewController, EsewaSDKPaymentDelegate {
  // Keep it in class instance
  var sdk: EsewaSDK?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    testSdkButtonTap()
  }
  
  func testSdkButtonTap() {
    //Start payment process
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
  
  func onEsewaSDKPaymentSuccess(info:[String:Any]) {
    // Called when the payment is success. Info contains the detail of transaction.
    self.dismiss(animated: true, completion: nil)
    print(info)
  }
  
  func onEsewaSDKPaymentError(errorDescription: String) {
    // Called when there is error with the description of the error.
    self.dismiss(animated: true, completion: nil)
    print(errorDescription)
  }
}
