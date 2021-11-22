//
//  TimesheetViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 20/11/21.
//

import UIKit

class TimesheetViewController: UIViewController {

    @IBOutlet weak var eventList: UITableView!
    @IBOutlet weak var timesheetImage: UIImageView!

    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var calendar: UIButton!
    @IBOutlet weak var right: UIButton!

    @IBOutlet weak var wfoImg: UIImageView!
    @IBOutlet weak var wfoTime: UILabel!

    @IBOutlet weak var wfhImg: UIImageView!
    @IBOutlet weak var wfhTime: UILabel!

    @IBOutlet weak var durationImg: UIImageView!
    @IBOutlet weak var duration: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventList.register(UINib(nibName: "ClockInOutTableViewCell", bundle: nil), forCellReuseIdentifier: "ClockInOut")
    }
}

extension TimesheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClockInOut", for: indexPath) as? ClockInOutTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
