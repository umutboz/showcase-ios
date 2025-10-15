//
//  ViewController.swift
//  UI
//
//  Created by AVS21862 on 13.10.2025.
//  Copyright © 2025 Veli Bacik. All rights reserved.
//

import UIKit

import Showcase
class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btn: UIButton!
    let sequence = ShowcaseSequence()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showcaseInit()
    }
    
    func showcaseInit(){
        let showcase1 = Showcase()
        showcase1.tag = 1
        showcase1.setTargetView(view: self.btn)
        showcase1.primaryText = nil
        showcase1.secondaryText = "Click here go"
        showcase1.isTapRecognizerForTargetView = false
        showcase1.outerCircleScale = 0.3
        showcase1.secondaryTextAlignment = .left
       // showcase1.setInstructionHorizontalMargins(left: 150, right: 0)
        //showcase1.instructionYOffset = 100
        showcase1.centerInstructionToOuterCircle = true
        //showcase1.instructionXOffset = 250
        //showcase1.setInstructionHorizontalMargins(left: 150, right: 0)
        //showcase1.outerCirclePadding = 24
        //showcase1.out
        showcase1.delegate = self
    
        
        let showcase2 = Showcase()
        showcase2.tag = 2
        showcase2.setTargetView(view:label)
        showcase2.delegate = self
        showcase2.targetTintColor = UIColor.red
        showcase2.targetHolderRadius = 50
        //showcase2.targetHolderColor = UIColor.yellow
        //showcase2.aniComeInDuration = 0.3
        //showcase2.backgroundPromptColor = UIColor(hex:"#F6A9000")
        //showcase2.aniRippleColor = UIColor(hex:"#F6A9000")
        //showcase2.aniRippleAlpha = 0.2
        showcase2.primaryText = "Action 1.1"
        showcase2.secondaryText = "Click here to go into details detaylar"
        showcase2.isTapRecognizerForTargetView = true
        showcase2.primaryTextAlignment = .right
        showcase2.secondaryTextAlignment = .right
        showcase2.centerInstructionToOuterCircle = true
               // Metin balonu konumu: sağa yaklaştır + biraz aşağı indir
        //showcase2.instructionYOffset = 20
       // showcase2.setInstructionHorizontalMargins(left: 24, right: 8) // sağ boşluğu azalt
        //showcase2.instructionXOffset = 24
               // Dış çember (arka plan balonu) küçültme
        showcase2.outerCircleScale = 0.85
        showcase2.outerCirclePadding = 24
        showcase2.backgroundViewType = .circle
        showcase2.backgroundPromptColor = .systemBlue
        showcase2.backgroundPromptColorAlpha = 0.90
        
        sequence.target(showcase1).target(showcase2).start()
    }


}

extension ViewController : ShowcaseDelegate {
    func showCaseDidDismiss(showcase: Showcase, didTapTarget: Bool) {
        let selectedView = showcase as UIView
        if selectedView.tag != 2 {
            sequence.showCaseWillDismis()
        }
        
    }
}
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
