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
        showcase1.outerCircleScale = 0.4
        showcase1.primaryTextAlignment = .center
        showcase1.secondaryTextAlignment = .center
        showcase1.setInstructionHorizontalMargins(left: 20, right: 20)
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
        showcase2.primaryText = nil
        showcase2.secondaryText = "Click here to"
        showcase2.secondaryTextAlignment = .center

        showcase2.backgroundViewType = .circle
        showcase2.constrainInstructionInsideCircle = false     // <-- dairenin içine sığdır
        showcase2.instructionInsidePadding = 124               // içten pay (sağ iç kenara yaklaşım)
  // opsiyonel (içine sığdırma bunu zaten çözüyor)
        showcase2.setInstructionHorizontalMargins(left: 0, right: 0) // dış marjları sıfırla (gerek yok artık)
        showcase2.instructionXOffset = 0                      // genelde gerekmez
        showcase2.instructionYOffset = 0                      // dikey ayarı kendine göre

        showcase2.outerCircleScale = 0.50
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
