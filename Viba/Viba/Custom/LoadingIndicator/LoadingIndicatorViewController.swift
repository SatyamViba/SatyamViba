//
//  LoadingIndicatorViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 22/02/22.
//

import UIKit
import SwiftyGif

class LoadingIndicatorViewController: UIViewController {
    @IBOutlet var gifImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let gif = try UIImage(gifName: "loading.gif")
            gifImage.setGifImage(gif, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }
    }
}
