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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
    
    private let titles: [String] = ["Pulsator", "Emitter", "Wave"]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UIViewController
        switch indexPath.row {
        case 0:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PulsatorVC")
        case 1:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmitterVC")
        case 2:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WaveVC")
        default:
            fatalError()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
