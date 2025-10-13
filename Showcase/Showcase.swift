//
//  Showcase.swift
//  Showcase
//

import UIKit

@objc public protocol ShowcaseDelegate: class {
    @objc optional func showCaseWillDismiss(showcase: Showcase, didTapTarget: Bool)
    @objc optional func showCaseDidDismiss(showcase: Showcase, didTapTarget: Bool)
}

public class Showcase: UIView {

    @objc public enum BackgroundTypeStyle: Int {
        case circle   // default
        case full     // full screen
    }

    // MARK: Material design guideline constant
    let BACKGROUND_ALPHA: CGFloat = 0.96
    let TARGET_HOLDER_RADIUS: CGFloat = 44
    let TEXT_CENTER_OFFSET: CGFloat = 44 + 20
    let INSTRUCTIONS_CENTER_OFFSET: CGFloat = 20
    let LABEL_MARGIN: CGFloat = 40
    let TARGET_PADDING: CGFloat = 20

    // Other default properties
    let LABEL_DEFAULT_HEIGHT: CGFloat = 50
    let BACKGROUND_DEFAULT_COLOR = UIColor.fromHex(hexString: "#2196F3")
    let TARGET_HOLDER_COLOR = UIColor.white

    // MARK: Animation properties
    var ANI_COMEIN_DURATION: TimeInterval = 0.5 // second
    var ANI_GOOUT_DURATION: TimeInterval = 0.5  // second
    var ANI_TARGET_HOLDER_SCALE: CGFloat = 2.2
    let ANI_RIPPLE_COLOR = UIColor.white
    let ANI_RIPPLE_ALPHA: CGFloat = 0.5
    let ANI_RIPPLE_SCALE: CGFloat = 1.6

    var offsetThreshold: CGFloat = 88

    // MARK: Private view properties
    var containerView: UIView?

    var targetView: UIView?
    var backgroundView: UIView?
    var targetHolderView: UIView?
    var hiddenTargetHolderView: UIView?
    var targetRippleView: UIView?
    var targetCopyView: UIView?
    var instructionView: ShowcaseInstructionView?

    // MARK: - Public Properties

    // Background
    @objc public var backgroundPromptColor: UIColor?
    @objc public var backgroundPromptColorAlpha: CGFloat = 0.0
    @objc public var backgroundViewType: BackgroundTypeStyle = .circle

    // Tap zone settings
    // - false: tüm showcase alanında tık algılanır
    // - true: sadece targetView alanında tık algılanır
    @objc public var isTapRecognizerForTargetView: Bool = false

    // Target
    @objc public var shouldSetTintColor: Bool = true
    @objc public var targetTintColor: UIColor?
    @objc public var targetHolderRadius: CGFloat = 0.0
    @objc public var targetHolderColor: UIColor?

    // Text
    @objc public var primaryText: String?
    @objc public var secondaryText: String?
    @objc public var primaryTextColor: UIColor?
    @objc public var secondaryTextColor: UIColor?
    @objc public var primaryTextSize: CGFloat = 0.0
    @objc public var secondaryTextSize: CGFloat = 0.0
    @objc public var primaryTextFont: UIFont?
    @objc public var secondaryTextFont: UIFont?
    @objc public var primaryTextAlignment: NSTextAlignment = .left
    @objc public var secondaryTextAlignment: NSTextAlignment = .left

    /// Title + açıklama bloğunu dikeyde kaydırma (px). +: aşağı, –: yukarı
    @objc public var instructionYOffset: CGFloat = 0.0
    /// Title + açıklama bloğunu yatayda kaydırma (px). +: sağa, –: sola
    @objc public var instructionXOffset: CGFloat = 0.0
    /// Sol marj (varsayılan: LABEL_MARGIN)
    @objc public var instructionLeftMargin: CGFloat = 40.0
    /// Sağ marj (varsayılan: LABEL_MARGIN)
    @objc public var instructionRightMargin: CGFloat = 40.0

    /// Yatay marjları tek seferde set etmek için yardımcı
    @objc public func setInstructionHorizontalMargins(left: CGFloat, right: CGFloat) {
        self.instructionLeftMargin = left
        self.instructionRightMargin = right
    }

    // Animation (public override’lar)
    @objc public var aniComeInDuration: TimeInterval = 0.0
    @objc public var aniGoOutDuration: TimeInterval = 0.0
    @objc public var aniRippleScale: CGFloat = 0.0
    @objc public var aniRippleColor: UIColor?
    @objc public var aniRippleAlpha: CGFloat = 0.0

    /// Dış çemberin metin/target etrafındaki ekstra payı
    @objc public var outerCirclePadding: CGFloat = 40.0

    /// Dış çemberi büyüt/küçült (1.0 = eski davranış)
    @objc public var outerCircleScale: CGFloat = 1.0 {
        didSet { outerCircleScale = max(0.5, min(1.5, outerCircleScale)) }
    }

    // Delegate
    @objc public weak var delegate: ShowcaseDelegate?

    // MARK: - Init

    public init() {
        // Create frame
        let frame = CGRect(x: 0, y: 0,
                           width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
        super.init(frame: frame)
        configure()
    }

    // No supported initialization method
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public APIs
extension Showcase {

    /// Sets a general UIView as target
    @objc public func setTargetView(view: UIView) {
        targetView = view
        if let label = targetView as? UILabel {
            targetTintColor = label.textColor
            backgroundPromptColor = label.textColor
        } else if let button = targetView as? UIButton {
            let tintColor = button.titleColor(for: .normal)
            targetTintColor = tintColor
            backgroundPromptColor = tintColor
        } else {
            targetTintColor = targetView?.tintColor
            backgroundPromptColor = targetView?.tintColor
        }
    }

    /// Sets a UIBarButtonItem as target
    @objc public func setTargetView(barButtonItem: UIBarButtonItem) {
        if let view = (barButtonItem.value(forKey: "view") as? UIView)?.subviews.first {
            targetView = view
        }
    }

    /// Sets a UITabBar Item as target
    @objc public func setTargetView(tabBar: UITabBar, itemIndex: Int) {
        let tabBarItems = orderedTabBarItemViews(of: tabBar)
        if itemIndex < tabBarItems.count {
            targetView = tabBarItems[itemIndex]
            targetTintColor = tabBar.tintColor
            backgroundPromptColor = tabBar.tintColor
        } else {
            print("The tab bar item index is out of range")
        }
    }

    /// Sets a UITableViewCell as target
    @objc public func setTargetView(tableView: UITableView, section: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: section)
        targetView = tableView.cellForRow(at: indexPath)?.contentView
        // TableViewCell için hedef arka daire gerekmez
        targetHolderRadius = 0
    }

    /// Shows it over current screen after completing setup process
    @objc public func show(animated: Bool = true, completion handler: (() -> Void)?) {
        initViews()
        alpha = 0.0
        guard let containerView = containerView else { return }
        guard let backgroundView = backgroundView else { return }
        guard let targetHolderView = targetHolderView else { return }

        containerView.addSubview(self)
        layoutIfNeeded()

        let scale = TARGET_HOLDER_RADIUS / (backgroundView.frame.width / 2)
        let center = backgroundView.center

        backgroundView.transform = CGAffineTransform(scaleX: scale, y: scale) // Initial for animation
        backgroundView.center = targetHolderView.center
        if animated {
            UIView.animate(withDuration: aniComeInDuration, animations: {
                targetHolderView.transform = CGAffineTransform(scaleX: 1, y: 1)
                backgroundView.transform = CGAffineTransform(scaleX: 1, y: 1)
                backgroundView.center = center
                self.alpha = 1.0
            }, completion: { _ in
                self.startAnimations()
            })
        } else {
            self.alpha = 1.0
        }
        handler?()
    }
}

// MARK: - Utility API
extension Showcase {
    /// Returns the current showcases displayed on screen.
    /// It will return null if no showcase exists.
    public static func presentedShowcases() -> [Showcase]? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        return window.subviews.compactMap { $0 as? Showcase }
    }
}

// MARK: - Setup views internally
extension Showcase {

    /// Initializes default view properties
    func configure() {
        backgroundColor = .clear
        guard let window = UIApplication.shared.keyWindow else { return }
        containerView = window
        setDefaultProperties()
    }

    func setDefaultProperties() {
        // Background
        backgroundPromptColor = BACKGROUND_DEFAULT_COLOR
        backgroundPromptColorAlpha = BACKGROUND_ALPHA

        // Target view
        targetTintColor = BACKGROUND_DEFAULT_COLOR
        targetHolderColor = TARGET_HOLDER_COLOR
        targetHolderRadius = TARGET_HOLDER_RADIUS

        // Text
        primaryText = ShowcaseInstructionView.PRIMARY_DEFAULT_TEXT
        secondaryText = ShowcaseInstructionView.SECONDARY_DEFAULT_TEXT
        primaryTextColor = ShowcaseInstructionView.PRIMARY_TEXT_COLOR
        secondaryTextColor = ShowcaseInstructionView.SECONDARY_TEXT_COLOR
        primaryTextSize = ShowcaseInstructionView.PRIMARY_TEXT_SIZE
        secondaryTextSize = ShowcaseInstructionView.SECONDARY_TEXT_SIZE

        // Animation
        aniComeInDuration = ANI_COMEIN_DURATION
        aniGoOutDuration = ANI_GOOUT_DURATION
        aniRippleAlpha = ANI_RIPPLE_ALPHA
        aniRippleColor = ANI_RIPPLE_COLOR
        aniRippleScale = ANI_RIPPLE_SCALE

        // Instruction offsets & margins
        instructionYOffset = 0.0
        instructionXOffset = 0.0
        instructionLeftMargin = LABEL_MARGIN
        instructionRightMargin = LABEL_MARGIN

        // Outer circle tuning
        outerCirclePadding = 40.0
        outerCircleScale = 1.0
    }

    func startAnimations() {
        let options: UIView.KeyframeAnimationOptions = [.curveEaseInOut, .repeat]
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: options, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.targetRippleView?.alpha = self.ANI_RIPPLE_ALPHA
                self.targetHolderView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.targetRippleView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.targetHolderView?.transform = .identity
                self.targetRippleView?.alpha = 0
                self.targetRippleView?.transform = CGAffineTransform(scaleX: self.aniRippleScale, y: self.aniRippleScale)
            })
        }, completion: nil)
    }

    func initViews() {
        guard let containerView = containerView else { print("containerView = null"); return }
        guard let targetView = targetView else { print("targetView is null"); return }

        let center = calculateCenter(at: targetView, to: containerView)
        addTargetRipple(at: center)
        addTargetHolder(at: center)

        // if color is not UIColor.clear, then add the target snapshot
        if targetHolderColor != .clear {
            addTarget(at: center)
        }

        // iPad: instruction önce background’a eklenir
        if UIDevice.current.userInterfaceIdiom == .pad {
            addBackground()
        }

        addInstructionView(at: center)
        instructionView?.layoutIfNeeded()

        // iPhone: instruction kendisine; sonra background eklenir
        if UIDevice.current.userInterfaceIdiom != .pad {
            addBackground()
        }

        // Disable subview interaction to let users click to general view only
        subviews.forEach { $0.isUserInteractionEnabled = false }

        if isTapRecognizerForTargetView {
            hiddenTargetHolderView?.addGestureRecognizer(tapGestureRecoganizer())
            hiddenTargetHolderView?.isUserInteractionEnabled = true
        } else {
            addGestureRecognizer(tapGestureRecoganizer())
            hiddenTargetHolderView?.addGestureRecognizer(tapGestureRecoganizer())
            hiddenTargetHolderView?.isUserInteractionEnabled = true
        }
    }

    /// Add background which is a big circle
    private func addBackground() {
        switch self.backgroundViewType {
        case .circle:
            let radius: CGFloat

            guard let center = targetRippleView?.center else { print("center is null"); return }

            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad eski sabit 300 => scale ile
                radius = 300.0 * outerCircleScale
            } else {
                guard let instructionView = instructionView else { print("instructionView is null"); return }
                guard let targetRippleView = targetRippleView else { print("targetRippleView is null"); return }
                // Not: getOuterCircleRadius içinde outerCirclePadding kullanılmalı
                let base = getOuterCircleRadius(center: center,
                                                textBounds: instructionView.frame,
                                                targetBounds: targetRippleView.frame)
                radius = base * outerCircleScale
            }

            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
            backgroundView?.center = center
            backgroundView?.asCircle()

        case .full:
            backgroundView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: UIScreen.main.bounds.height))
        }

        guard let backgroundPromptColor = backgroundPromptColor else { print("backgroundPromptColor is null"); return }
        guard let targetRippleView = targetRippleView else { print("targetRippleView is null"); return }
        guard let backgroundView = backgroundView else { print("backgroundView is null"); return }

        backgroundView.backgroundColor = backgroundPromptColor.withAlphaComponent(backgroundPromptColorAlpha)
        insertSubview(backgroundView, belowSubview: targetRippleView)
        addBackgroundMask(with: targetHolderRadius, in: backgroundView)
    }

    private func addBackgroundMask(with radius: CGFloat, in view: UIView) {
        guard let targetRippleView = targetRippleView else { print("targetRippleView is null"); return }
        let center = backgroundViewType == .circle ? view.bounds.center : targetRippleView.center
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: 2 * .pi, clockwise: false)

        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = .evenOdd

        view.layer.mask = mask
    }

    /// A background view which add ripple animation when showing target view
    private func addTargetRipple(at center: CGPoint) {
        targetRippleView = UIView(frame: CGRect(x: 0, y: 0,
                                                width: targetHolderRadius * 2,
                                                height: targetHolderRadius * 2))
        targetRippleView?.center = center
        targetRippleView?.backgroundColor = aniRippleColor
        targetRippleView?.alpha = 0.0 // invisible initially
        targetRippleView?.asCircle()
        guard let targetRippleView = targetRippleView else { print("targetRippleView is null"); return }
        addSubview(targetRippleView)
    }

    /// A circle-shape background view of target view
    private func addTargetHolder(at center: CGPoint) {
        hiddenTargetHolderView = UIView()
        hiddenTargetHolderView?.backgroundColor = .clear

        targetHolderView = UIView(frame: CGRect(x: 0, y: 0,
                                                width: targetHolderRadius * 2,
                                                height: targetHolderRadius * 2))
        targetHolderView?.center = center
        targetHolderView?.backgroundColor = targetHolderColor
        targetHolderView?.asCircle()
        targetHolderView?.transform = CGAffineTransform(scaleX: 1 / ANI_TARGET_HOLDER_SCALE,
                                                        y: 1 / ANI_TARGET_HOLDER_SCALE) // initial for animation

        guard let targetHolderView = targetHolderView else { print("targetHolderView is null"); return }

        hiddenTargetHolderView?.frame = targetHolderView.frame
        addSubview(hiddenTargetHolderView!)
        addSubview(targetHolderView)
    }

    /// Create a copy view of target view (not to affect original)
    private func addTarget(at center: CGPoint) {
        targetCopyView = targetView?.snapshotView(afterScreenUpdates: true)
        guard let targetCopyView = targetCopyView else { print("targetCopyView is null"); return }

        if shouldSetTintColor {
            guard let targetTintColor = targetTintColor else { print("targetTintColor is null"); return }
            targetCopyView.setTintColor(targetTintColor, recursive: true)

            if targetCopyView is UIButton {
                let button = targetView as! UIButton
                let buttonCopy = targetCopyView as! UIButton
                buttonCopy.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                buttonCopy.setTitleColor(targetTintColor, for: .normal)
                buttonCopy.isEnabled = true
            } else if targetCopyView is UIImageView {
                let imageView = targetView as! UIImageView
                let imageViewCopy = targetCopyView as! UIImageView
                imageViewCopy.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            } else if let imageViewCopy = targetCopyView.subviews.first as? UIImageView,
                      let labelCopy = targetCopyView.subviews.last as? UILabel {
                let imageView = targetView?.subviews.first as! UIImageView
                imageViewCopy.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                labelCopy.textColor = targetTintColor
            } else if let label = targetCopyView as? UILabel {
                label.textColor = targetTintColor
            }
        }

        let width = targetCopyView.frame.width
        let height = targetCopyView.frame.height
        targetCopyView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        targetCopyView.center = center
        targetCopyView.translatesAutoresizingMaskIntoConstraints = true

        addSubview(targetCopyView)
    }

    /// Configures and adds primary label view
    private func addInstructionView(at center: CGPoint) {
        instructionView = ShowcaseInstructionView()
        guard let instructionView = instructionView else { print("instructionView is null"); return }
        guard let targetView = targetView else { print("targetView is null"); return }
        guard let containerView = containerView else { print("containerView is null"); return }

        // Text config
        instructionView.primaryTextAlignment = primaryTextAlignment
        instructionView.primaryTextFont = primaryTextFont
        instructionView.primaryTextSize = primaryTextSize
        instructionView.primaryTextColor = primaryTextColor
        instructionView.primaryText = primaryText

        instructionView.secondaryTextAlignment = secondaryTextAlignment
        instructionView.secondaryTextFont = secondaryTextFont
        instructionView.secondaryTextSize = secondaryTextSize
        instructionView.secondaryTextColor = secondaryTextColor
        instructionView.secondaryText = secondaryText

        let isAbove = (getTargetPosition(target: targetView, container: containerView) == .above)

        var x: CGFloat
        var y: CGFloat
        var w: CGFloat

        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let backgroundView = backgroundView else { print("backgroundView is null"); return }

            // Genişlik: sol/sağ marjlar
            w = backgroundView.frame.width - (instructionLeftMargin + instructionRightMargin)

            // X: sol marj
            x = instructionLeftMargin

            // backgroundView ekranı dışına taşıyorsa telafi
            if backgroundView.frame.origin.x < 0 {
                x = abs(backgroundView.frame.origin.x) + instructionLeftMargin
            } else if (backgroundView.frame.origin.x + backgroundView.frame.size.width) > UIScreen.main.bounds.width {
                w = backgroundView.frame.size.width - (instructionLeftMargin + instructionRightMargin)
            }

            // Dikey konum + instructionYOffset
            if isAbove {
                y = (backgroundView.frame.size.height / 2) + TEXT_CENTER_OFFSET + instructionYOffset
            } else {
                y = TEXT_CENTER_OFFSET + LABEL_DEFAULT_HEIGHT * 2 + instructionYOffset
            }

            // Yatay ofset + clamp
            x += instructionXOffset
            x = max(0, min(x, backgroundView.frame.width - w))

            instructionView.frame = CGRect(x: x, y: y, width: w, height: 0)
            backgroundView.addSubview(instructionView)
        } else {
            // iPhone

            // Dikey konum: hedef üst/alt + instructionYOffset
            if isAbove {
                y = center.y
                    + TARGET_PADDING
                    + max(targetView.bounds.height / 2, self.targetHolderRadius)
                    + instructionYOffset
            } else {
                y = center.y
                    - TEXT_CENTER_OFFSET
                    - LABEL_DEFAULT_HEIGHT * 2
                    + instructionYOffset
            }

            // Genişlik: sol/sağ marjlar
            w = containerView.frame.width - (instructionLeftMargin + instructionRightMargin)

            // X: sol marj + instructionXOffset
            x = instructionLeftMargin + instructionXOffset

            // Kenara taşmayı engelle
            x = max(0, min(x, containerView.frame.width - w))

            instructionView.frame = CGRect(x: x, y: y, width: w, height: 0)
            addSubview(instructionView)
        }
    }

    /// Handles user's tap
    private func tapGestureRecoganizer() -> UIGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Showcase.tapGestureSelector))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        return tapGesture
    }

    @objc private func tapGestureSelector(tapGesture: UITapGestureRecognizer) {
        completeShowcase(didTapTarget: tapGesture.view === hiddenTargetHolderView)
    }

    /// Default action when dimissing showcase
    /// Notifies delegate, removes views, and handles out-going animation
    @objc public func completeShowcase(animated: Bool = true, didTapTarget: Bool = false) {

        if delegate != nil && delegate?.showCaseDidDismiss != nil {
            delegate?.showCaseWillDismiss?(showcase: self, didTapTarget: didTapTarget)
        }

        if animated {
            guard let targetHolderView = targetHolderView else { print("targetHolderView is null"); return }
            guard let backgroundView = backgroundView else { print("backgroundView is null"); return }
            guard let targetRippleView = targetRippleView else { print("targetRippleView is null"); return }

            targetRippleView.removeFromSuperview()
            UIView.animateKeyframes(withDuration: aniGoOutDuration, delay: 0, options: [.calculationModeLinear], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 3/5, animations: {
                    targetHolderView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    backgroundView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    backgroundView.alpha = 0
                })
                UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 2/5, animations: {
                    self.alpha = 0
                })
            }, completion: { _ in
                self.recycleSubviews()
                self.removeFromSuperview()
            })
        } else {
            recycleSubviews()
            removeFromSuperview()
        }

        if delegate != nil && delegate?.showCaseDidDismiss != nil {
            delegate?.showCaseDidDismiss?(showcase: self, didTapTarget: didTapTarget)
        }
    }

    private func recycleSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - Private helper methods
extension Showcase {

    /// Defines the position of target view to place texts suitably
    enum TargetPosition {
        case above // at upper screen part
        case below // at lower screen part
    }

    /// Detects the position of target view relative to its container
    func getTargetPosition(target: UIView, container: UIView) -> TargetPosition? {
        guard let targetView = targetView else { print("targetView is null"); return nil }
        let center = calculateCenter(at: targetView, to: container)
        if center.y < container.frame.height / 2 {
            return .above
        } else {
            return .below
        }
    }

    // Calculates the center point based on targetView
    func calculateCenter(at targetView: UIView, to containerView: UIView) -> CGPoint {
        let targetRect = targetView.convert(targetView.bounds, to: containerView)
        return targetRect.center
    }

    // Gets all UIView from TabBarItem.
    func orderedTabBarItemViews(of tabBar: UITabBar) -> [UIView] {
        let interactionViews = tabBar.subviews.filter { $0.isUserInteractionEnabled }
        return interactionViews.sorted(by: { $0.frame.minX < $1.frame.minX })
    }
}
