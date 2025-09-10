<div id="page">

<div id="main" class="aui-page-panel">

<div id="main-header">

<div id="breadcrumb-section">

1.  <span>[OneFrameMobile](index.html)</span>
2.  <span>[Components](Components_9601453.html)</span>
3.  <span>[Showcase](Showcase_42402321.html)</span>

</div>

# <span id="title-text">OneFrameMobile : Showcase - IOS</span>

</div>

<div id="content" class="view">

<div class="page-metadata">Created by <span class="author">Unknown User (02484320)</span>, last modified on 30 May, 2019</div>

<div id="main-content" class="wiki-content group">

*   ##### [Introduction](#Showcase-IOS-Introduction)

*   ##### <span class="toc-item-body">[Getting Started](#Showcase-IOS-GettingStarted)</span>

*   ##### [Requirement](#Showcase-IOS-Requirement)

*   ##### [Showcase](Showcase---IOS_51577043.html)

    *   [UI Options](#Showcase-IOS-UIOptions)
    *   [UIView Case](#Showcase-IOS-UIViewCase)
    *   [UITableView Case](#Showcase-IOS-UITableViewCase)
    *   [UITabBarItem Case](Showcase---IOS_51577043.html)
    *   [UIBarButton Case](#Showcase-IOS-UIBarButtonCase)
*   **[Sequence](#Showcase-IOS-Sequence)**

*   **[Release Notes](RELEASE_NOTES.md)**

# Introduction

Showcase library spots a given view. It can be used to highlight new features.

You can download sample application or look at bellatrix repository.

[ShowcaseSample.zip](.documentation/51577045.zip)

<span class="confluence-embedded-file-wrapper confluence-embedded-manual-size">![](.documentation/51577177.gif)</span>

# <span>Getting Started</span>

[CocoaPods](http://cocoapods.org/)  is a dependency manager for Cocoa projects. You can install it with the following command:

$ gem install cocoapods

> CocoaPods 1.1+ is required to build  1.0

To integrate KSNetwork into your Xcode project using CocoaPods, specify it in your `Podfile`:

source '[https://github.com/CocoaPods/Specs.git](https://github.com/CocoaPods/Specs.git) ' platform :ios, '10.0' use_frameworks!

target 'Target Name' do

**pod 'Showcase' , :git => '[http://bellatrix:8080/tfs/ArgeMimariCollection/OneFrameIOS/_git/Showcase](http://bellatrix:8080/tfs/ArgeMimariCollection/OneFrameIOS/_git/Showcase)', :tag => '1.1.0****'**

 end

Then, run the following command:

$ pod install

# Requirement

*   iOS 10.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
*   Xcode 9.0+
*   Swift 4+

# Showcase

## UI Options

Showcase have a lot options , primary text , circle color , tableview options ... 

<div class="code panel pdl" style="border-width: 1px;">

<div class="codeHeader panelHeader pdl" style="border-bottom-width: 1px;">**Basic GET**</div>

<div class="codeContent panelContent pdl">

<pre class="syntaxhighlighter-pre" data-syntaxhighlighter-params="brush: py; gutter: false; theme: Midnight" data-theme="Midnight">		showcase.setTargetView(view: button)
        showcase.primaryText = "Action 1"
        showcase.secondaryText = "Click here to go into details"
        showcase.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase.backgroundPromptColor = UIColor.blue
        showcase.isTapRecognizerForTargetView = true
			showcase.show(completion: {
            print("==== completion Action 1.1 ====")
            // You can save showcase state here
        })</pre>

</div>

</div>

## UIView Case

You can use text , button or all UIView component will  use "tapTarget : view"  param. 

<div class="code panel pdl" style="border-width: 1px;">

<div class="codeHeader panelHeader pdl" style="border-bottom-width: 1px;">**UIView**</div>

<div class="codeContent panelContent pdl">

<pre class="syntaxhighlighter-pre" data-syntaxhighlighter-params="brush: py; gutter: false; theme: Midnight" data-theme="Midnight">   let showcase = Showcase()
        showcase.setTargetView(view: button)
        showcase.primaryText = "Action 1"
        showcase.secondaryText = "Click here to go into details"
        showcase.shouldSetTintColor = false // It should be set to false when button uses image.
        showcase.backgroundPromptColor = UIColor.blue
        showcase.isTapRecognizerForTargetView = true
		  showcase.show(completion: {
            print("==== completion Action 1.1 ====")
            // You can save showcase state here
        })</pre>

</div>

</div>

## UITableView Case

You can use Tableview will  use "tapTarget : tableView"  and could you add section and row param. 

<div class="code panel pdl" style="border-width: 1px;">

<div class="codeHeader panelHeader pdl" style="border-bottom-width: 1px;">**UITableView**</div>

<div class="codeContent panelContent pdl">

<pre class="syntaxhighlighter-pre" data-syntaxhighlighter-params="brush: py; gutter: false; theme: Midnight" data-theme="Midnight">        let showcase = Showcase()
        showcase.setTargetView(tableView: tableView, section: 0, row: 2)
        showcase.primaryText = "Action 3"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = false
		  showcase.show(completion: {
            print("==== completion Action 1.1 ====")
            // You can save showcase state here
        })</pre>

</div>

</div>

## UIBarButton Case

You can use barButtonItem will use "tapTarget : view"  param. 

<div class="code panel pdl" style="border-width: 1px;">

<div class="codeHeader panelHeader pdl" style="border-bottom-width: 1px;">**UIBarButton**</div>

<div class="codeContent panelContent pdl">

<pre class="syntaxhighlighter-pre" data-syntaxhighlighter-params="brush: py; gutter: false; theme: Midnight" data-theme="Midnight">		let showcase = Showcase()
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
		  showcase.show(completion: {
            print("==== completion Action 1.1 ====")
            // You can save showcase state here
        })</pre>

</div>

</div>

##   
UITabBarItem Case

If use UITabbarItem will you can use "tabBar : view"  param and could you set itemIndex param. 

<div class="code panel pdl" style="border-width: 1px;">

<div class="codeHeader panelHeader pdl" style="border-bottom-width: 1px;">**Basic GET**</div>

<div class="codeContent panelContent pdl">

<pre class="syntaxhighlighter-pre" data-syntaxhighlighter-params="brush: py; gutter: false; theme: Midnight" data-theme="Midnight">   		let showcase = Showcase()
        showcase.setTargetView(tabBar: tabBar, itemIndex: 0)
        showcase.backgroundViewType = .circle
        showcase.targetTintColor = UIColor.clear
        showcase.targetHolderColor = UIColor.clear
        showcase.primaryText = "Action 3"
        showcase.secondaryText = "Click here to go into details"
        showcase.isTapRecognizerForTargetView = true
		  showcase.show(completion: {
            print("==== completion Action 1.1 ====")
            // You can save showcase state here
        })</pre>

</div>

</div>

# Sequence

This options use need three requirements.

1.  Declare many Showcase item.
    1.  Must set delegate self
2.  You will use page extends (Inheritance) ShowcaseDelegate
3.  Add ShowcaseDismiss function into sequence.showCaseWillDismis()

**You want app start run showcase sequence call sequence function viewDidAppear**

> Set sequence.once(key : "veli") param and sequence showcase only once show.

<div class="code panel pdl" style="border-width: 1px;">

<div class="codeHeader panelHeader pdl" style="border-bottom-width: 1px;">**Basic GET**</div>

<div class="codeContent panelContent pdl">

<pre class="syntaxhighlighter-pre" data-syntaxhighlighter-params="brush: py; gutter: false; theme: Midnight" data-theme="Midnight">    let sequence = ShowcaseSequence()
    override func viewDidAppear(_ animated: Bool) {
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
        //sequence.target(showcase1).target(showcase2).target(showcase3).once(key : "first").start()
        sequence.target(showcase1).target(showcase2).target(showcase3).start()
    }

extension ViewController : ShowcaseDelegate {
    func showCaseDidDismiss(showcase: Showcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
    }
}

</pre>

</div>

</div>

</div>

<div class="pageSection group">

<div class="pageSectionHeader">

## Attachments:

</div>

<div class="greybox" align="left">![](images/icons/bullet_blue.gif) [ShowcaseSample.zip](.documentation/51577175.zip) (application/zip)  
![](images/icons/bullet_blue.gif) [ShowcaseSample.zip](.documentation/51577045.zip) (application/zip)  
![](images/icons/bullet_blue.gif) [demoshow.gif](.documentation/51577177.gif) (image/gif)  
</div>

</div>

</div>

</div>

<div id="footer" role="contentinfo">

<section class="footer-body">

Document generated by Confluence on 26 Mar, 2021 11:14

<div id="footer-logo">[Atlassian](http://www.atlassian.com/)</div>

</section>

</div>

</div>
