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
    
    public var autoCenterDescriptionWhenNoTitle: Bool = true

    
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
    
    /// Configures and adds secondary label vie
    
    //Calculate width per device
    private func getWidth() -> CGFloat{
        guard let sv = self.superview else { return frame.width - frame.minX }
        if sv.frame.origin.x < 0 {
            return frame.width - (frame.minX / 2)
        } else if sv.frame.origin.x + sv.frame.size.width > UIScreen.main.bounds.width {
            return (frame.width - frame.minX) / 2
        }
        return (frame.width - frame.minX)
    }
    /// Configures and adds primary label view (title)
    private func addPrimaryLabelIfNeeded() {
        // Temizle
        primaryLabel?.removeFromSuperview()
        primaryLabel = nil
        
        // Title boşsa HİÇ oluşturma (description en üstten başlayacak)
        guard let text = primaryText, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let label = UILabel()
        // Font
        if let font = primaryTextFont {
            label.font = font
        } else {
            let size = primaryTextSize ?? ShowcaseInstructionView.PRIMARY_TEXT_SIZE
            label.font = UIFont.boldSystemFont(ofSize: size)
        }
        label.textColor = primaryTextColor
        label.textAlignment = self.primaryTextAlignment ?? .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = text
        label.frame = CGRect(x: 0, y: 0, width: getWidth(), height: 0)
        label.sizeToFitHeight()
        
        addSubview(label)
        primaryLabel = label
    }
    private func addSecondaryLabelIfNeeded() {
        // Temizle
        secondaryLabel?.removeFromSuperview()
        secondaryLabel = nil

        guard let text = secondaryText,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            frame.size.height = 0
            return
        }

        let label = UILabel()

        // Font
        if let font = secondaryTextFont {
            label.font = font
        } else {
            let size = secondaryTextSize ?? ShowcaseInstructionView.SECONDARY_TEXT_SIZE
            label.font = UIFont.systemFont(ofSize: size)
        }

        label.textColor = secondaryTextColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = text

        // --- HİZALAMA ÖNCELİĞİ ---
        // 1) Eğer Showcase'ten bir hizalama geldiyse (ör. .right), HER ZAMAN onu uygula.
        // 2) Hizalama gelmediyse ve title YOKSA -> .center
        // 3) Hizalama gelmediyse ve title VARSA -> .left
        if let explicitAlignment = self.secondaryTextAlignment {
            // Showcase.swift tarafında secondaryTextAlignment genelde non-optional (.left default).
            // Dışarıdan .right atanmışsa buraya .right düşer ve her zaman korunur.
            label.textAlignment = explicitAlignment
        } else if primaryLabel == nil {
            label.textAlignment = .center
        } else {
            label.textAlignment = .left
        }

        // Y konumu: title varsa altına, yoksa en üstten
        let startY: CGFloat = (primaryLabel != nil) ? primaryLabel!.frame.height : 0
        label.frame = CGRect(x: 0, y: startY, width: getWidth(), height: 0)
        label.sizeToFitHeight()
        addSubview(label)
        secondaryLabel = label

        // Toplam yükseklik
        let totalHeight = startY + label.frame.height
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: totalHeight)
    }

    
    /// Overrides this to add subviews. They will be drawn when calling show()
    public override func layoutSubviews() {
        super.layoutSubviews()
              // Baştan kur
        subviews.forEach { $0.removeFromSuperview() }
        addPrimaryLabelIfNeeded()
        addSecondaryLabelIfNeeded()
        subviews.forEach { $0.isUserInteractionEnabled = false }
    }
}
