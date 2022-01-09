//
//  ReviewViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/01/22.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet var tick: VibaCircularImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tickImage = UIImage.fontAwesomeIcon(name: .check, style: .solid, textColor: .white, size: CGSize(width: 18, height: 18))
        tick.image = tickImage
        // Do any additional setup after loading the view.
    }

    @IBAction func goBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
