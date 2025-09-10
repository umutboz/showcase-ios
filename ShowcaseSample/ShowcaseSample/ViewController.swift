//
//  ViewController.swift
//  ShowcaseSample
//
//  Created by Veli Bacik on 17.04.2019.
//  Copyright © 2019 Veli Bacik. All rights reserved.
//

import UIKit
import Showcase
class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchItem: UIBarButtonItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let sequence = ShowcaseSequence()
    let animals = ["Dolphin", "Penguin", "Panda", "Neko", "Inu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        sequenceShowcase()
        
    }
    @IBAction func playSequence(_ sender: Any) {
        sequenceShowcase()
    }
    func sequenceShowcase() {
        let showcase3 = Showcase()
        showcase3.setTargetView(tableView: self.tableView, section: 0, row: 2)
        showcase3.primaryText = "Action 3"
        showcase3.secondaryText = "Click here to go into details"
        showcase3.isTapRecognizerForTargetView = false
        
        
        let showcase1 = Showcase()
        showcase1.setTargetView(view: button)
        showcase1.primaryText = "Action 1"
        showcase1.secondaryText = "Click here to go into details"
        showcase1.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase1.backgroundPromptColor = UIColor.blue
        showcase1.isTapRecognizerForTargetView = true
        
        
        let showcase2 = Showcase()
        showcase2.setTargetView(barButtonItem: searchItem)
        showcase2.primaryText = "Action 1.1"
        showcase2.secondaryText = "Click here to go into details"
        showcase2.isTapRecognizerForTargetView = true
        
        
        showcase3.delegate = self
        showcase2.delegate = self
        showcase1.delegate = self
        
        sequence.target(showcase1).target(showcase2).target(showcase3).once(key: "firstx").start()
    }
    
    @IBAction func showButton(_ sender: Any) {
        let showcase = Showcase()
        showcase.setTargetView(view: button)
        showcase.primaryText = "Action 1"
        showcase.secondaryText = "Click here to go into details"
        showcase.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase.backgroundPromptColor = UIColor.blue
        showcase.isTapRecognizerForTargetView = true
        //        showcase.delegate = self
        showcase.show(completion: {
            print("==== completion Action 1 ====")
            // You can save showcase state here
        })
    }
    
    @IBAction func placementButton(_ sender: UIButton) {
        let showcase = Showcase()
        showcase.setTargetView(view: sender)
        showcase.primaryText = "Action 1.1"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = true
        showcase.show(completion: {
            print("==== completion Action 1.1 ====")
            // You can save showcase state here
        })
    }
    
    @IBAction func showBarButtonItem(_ sender: Any) {
        let showcase = Showcase()
        showcase.setTargetView(barButtonItem: searchItem)
        showcase.targetTintColor = UIColor.red
        showcase.targetHolderRadius = 50
        showcase.targetHolderColor = UIColor.yellow
        showcase.aniComeInDuration = 0.3
        showcase.aniRippleColor = UIColor.black
        showcase.aniRippleAlpha = 0.2
        showcase.primaryText = "Action 2"
        showcase.secondaryText = "Click here to go into long long long long long long long long long long long long long long long details"
        showcase.secondaryTextSize = 14
        showcase.isTapRecognizerForTargetView = true
        // Delegate to handle other action after showcase is dismissed.
        //        showcase.delegate = self
        showcase.show(completion: {
            // You can save showcase state here
            print("==== completion Action 2 ====")
        })
    }
    
    @IBAction func showTabBar(_ sender: Any) {
        let showcase = Showcase()
        showcase.setTargetView(tabBar: tabBar, itemIndex: 0)
        showcase.backgroundViewType = .circle
        showcase.targetTintColor = UIColor.clear
        showcase.targetHolderColor = UIColor.clear
        showcase.primaryText = "Action 3"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = true
        //        showcase.delegate = self
        showcase.show(completion: nil)
    }
    
    @IBAction func showTableView(_ sender: Any) {
        let showcase = Showcase()
        showcase.setTargetView(tableView: tableView, section: 0, row: 2)
        showcase.primaryText = "Action 3"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = false
        //        showcase.delegate = self
        showcase.show(completion: nil)
    }
    
    
    
}

extension ViewController : ShowcaseDelegate {
    func showCaseDidDismiss(showcase: Showcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = animals[indexPath.row]
        return cell
    }
    
    
}

