//
//  FaceView.swift
//  Viba
//
//  Created by Satyam Sutapalli on 30/11/21.
//

import UIKit
import Vision

class FaceView: UIView {
  var boundingBox = CGRect.zero
  
  func clear() {
    boundingBox = .zero

    DispatchQueue.main.async {
      self.setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }

    context.saveGState()
    defer {
      context.restoreGState()
    }
    
    context.addRect(boundingBox)
    UIColor.red.setStroke()
    context.strokePath()
  }
}
