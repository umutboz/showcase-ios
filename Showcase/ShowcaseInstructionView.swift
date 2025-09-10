//
//  ShowcaseInstructionView.swift
//  Showcase
//

//

import Foundation
import UIKit

public class ShowcaseInstructionView: UIView {
    
    internal static let PRIMARY_TEXT_SIZE: CGFloat = 20
    internal static let SECONDARY_TEXT_SIZE: CGFloat = 15
    internal static let PRIMARY_TEXT_COLOR = UIColor.white
    internal static let SECONDARY_TEXT_COLOR = UIColor.white.withAlphaComponent(0.87)
    internal static let PRIMARY_DEFAULT_TEXT = "Awesome action"
    internal static let SECONDARY_DEFAULT_TEXT = "Tap here to do some awesome thing"
    
    public var primaryLabel: UILabel?
    public var secondaryLabel: UILabel?
    
    // Text
    public var primaryText: String?
    public var secondaryText: String?
    public var primaryTextColor: UIColor?
    public var secondaryTextColor: UIColor?
    public var primaryTextSize: CGFloat?
    public var secondaryTextSize: CGFloat?
    public var primaryTextFont: UIFont?
    public var secondaryTextFont: UIFont?
    public var primaryTextAlignment: NSTextAlignment?
    public var secondaryTextAlignment: NSTextAlignment?
    
    public init() {
        // Create frame
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        super.init(frame: frame)
        
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializes default view properties
    fileprivate func configure() {
        setDefaultProperties()
    }
    
    fileprivate func setDefaultProperties() {
        // Text
        primaryText = ShowcaseInstructionView.PRIMARY_DEFAULT_TEXT
        secondaryText = ShowcaseInstructionView.SECONDARY_DEFAULT_TEXT
        primaryTextColor = ShowcaseInstructionView.PRIMARY_TEXT_COLOR
        secondaryTextColor = ShowcaseInstructionView.SECONDARY_TEXT_COLOR
        primaryTextSize = ShowcaseInstructionView.PRIMARY_TEXT_SIZE
        secondaryTextSize = ShowcaseInstructionView.SECONDARY_TEXT_SIZE
    }
    
    /// Configures and adds primary label view
    private func addPrimaryLabel() {
        
        if primaryLabel != nil {
            primaryLabel?.removeFromSuperview()
        }
        
        primaryLabel = UILabel()
        guard let primaryLabel = primaryLabel else { return }
        
        if let font = primaryTextFont {
            primaryLabel.font = font
        } else {
            
            guard let primaryTextSize = primaryTextSize else {
                print("primaryTextSize is null")
                return
            }
            primaryLabel.font = UIFont.boldSystemFont(ofSize: primaryTextSize)
        }
        primaryLabel.textColor = primaryTextColor
        primaryLabel.textAlignment = self.primaryTextAlignment ?? .left
        primaryLabel.numberOfLines = 0
        primaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        primaryLabel.text = primaryText
        primaryLabel.frame = CGRect(x: 0,
                                    y: 0,
                                    width: getWidth(),
                                    height: 0)
        primaryLabel.sizeToFitHeight()
        addSubview(primaryLabel)
    }
    
    /// Configures and adds secondary label view
    private func addSecondaryLabel() {
        if secondaryLabel != nil  {
            secondaryLabel?.removeFromSuperview()
        }
        secondaryLabel = UILabel()
        guard let secondaryLabel = secondaryLabel else {
            return
        }
        if let font = secondaryTextFont {
            secondaryLabel.font = font
        } else {
            guard let secondaryTextSize = secondaryTextSize else {
                print("secondaryTextSize is null")
                return
            }
            secondaryLabel.font = UIFont.systemFont(ofSize: secondaryTextSize)
        }
        secondaryLabel.textColor = secondaryTextColor
        secondaryLabel.textAlignment = self.secondaryTextAlignment ?? .left
        secondaryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        secondaryLabel.text = secondaryText
        secondaryLabel.numberOfLines = 0
        guard let primaryLabel = primaryLabel else { return }
        
        secondaryLabel.frame = CGRect(x: 0,
                                      y: primaryLabel.frame.height,
                                      width: getWidth(),
                                      height: 0)
        secondaryLabel.sizeToFitHeight()
        addSubview(secondaryLabel)
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: primaryLabel.frame.height + secondaryLabel.frame.height)
    }
    
    //Calculate width per device
    private func getWidth() -> CGFloat{
        //superview was left side
        if (self.superview?.frame.origin.x)! < CGFloat(0) {
            return frame.width - (frame.minX/2)
        } else if ((self.superview?.frame.origin.x)! + (self.superview?.frame.size.width)! >
            UIScreen.main.bounds.width) { //superview was right side
            return (frame.width - frame.minX)/2
        }
        return (frame.width - frame.minX)
    }
    
    /// Overrides this to add subviews. They will be drawn when calling show()
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        addPrimaryLabel()
        addSecondaryLabel()
        
        subviews.forEach({$0.isUserInteractionEnabled = false})
    }
}
