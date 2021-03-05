//
//  TableViewController.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/5/27.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Animations"
    }

    // MARK: - Table view data source
    
    private let vcs: [[String : String]] = [["title" : "Pulsator", "vc" : "PulsatorVC"],
                                            ["title" : "Emitter", "vc" : "EmitterVC"],
                                            ["title" : "Wave", "vc" : "WaveVC"],
                                            ["title" : "Shaking TextField", "vc" : "ShakeTextFieldVC"],
                                            ["title" : "Pulsating Tap", "vc" : "PulsatingTapVC"],
                                            ["title" : "Circle Progress", "vc" : "CircleProgressVC"],
    ]


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = vcs[indexPath.row]["title"]
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = vcs[indexPath.row]["vc"]!
        let vc: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc, animated: true)
    }
}
