//
//  File.swift
//  TestESewav2
//
//  Created by Aman Maharjan on 8/21/20.
//

import Foundation
import UIKit

@objc(ESewa)
class ESewa: NSObject {
  private var count = 10
  fileprivate var onResolve: RCTPromiseResolveBlock?
  fileprivate var onReject: RCTPromiseRejectBlock?
  
  @objc
  func increment() {
    count += 1
    print("Count is \(count)")
  }
  
  @objc
  func getCount(_ callback: RCTResponseSenderBlock) {
    callback([count])
  }
  
  @objc
  func decrement(_ resolve: RCTPromiseResolveBlock, rejector reject: RCTPromiseRejectBlock) -> Void {
    if(count == 0) {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_COUNT", "Count cannot be negative", error);
    } else {
      count -= 1
      resolve("Count was decremented")
    }
  }
  
  @objc
  func pay(
    _ resolve: @escaping RCTPromiseResolveBlock,
    rejector reject: @escaping RCTPromiseRejectBlock
  ) -> Void {
    DispatchQueue.main.async {
      let storyboard = UIStoryboard(name: "ESewa", bundle: nil)

      let eSewaPay = storyboard.instantiateViewController(withIdentifier: "ESewaViewController") as!ESewaViewController
      
      self.onResolve = resolve
      self.onReject = reject
      
      eSewaPay.eSewaDelegate = self
      
      let navController = UINavigationController(rootViewController: eSewaPay)
      navController.setNavigationBarHidden(true, animated: false)
      navController.modalPresentationStyle = .fullScreen
      
      let topController = UIApplication.topMostViewController()
      topController?.present(navController, animated: false, completion: nil)
    }
  }
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

extension ESewa: ESewaViewControllerDelegate {
  func success(info: [String : Any]) {
    self.onResolve!(info)
  }
  
  func failure(errorDescription: String) {
    let error = NSError(domain: "", code: 200, userInfo: nil)
    self.onReject!("E_ESewa", errorDescription, error)
  }
}
