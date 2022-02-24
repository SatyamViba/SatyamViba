//
//  LoadingViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/01/22.
//

import UIKit
import SwiftyGif

class LoadingViewController: UIViewController {
    @IBOutlet var splashimage: UIImageView!
    @IBOutlet var ver: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let bld = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            ver.text = "v \(version) (\(bld))"
        }
        
        do {
            splashimage.delegate = self
            let gif = try UIImage(gifName: "splash.gif")
            splashimage.setGifImage(gif, loopCount: 1) // Will loop forever
        } catch {
            print(error)
        }
    }
}

extension LoadingViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        performSegue(withIdentifier: "Main", sender: nil)
    }
}
