//
//  SubTabViewController.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 7.6.21..
//

import UIKit

public class SubTabViewController: UITabBarController {
	var customTabBar: TabbedHeaderView!
	var tabItems: [MenuItemEntry] = []
	var height: CGFloat!
	
	///A background color of a primary menu. This would also be the color of sub menu's activity bar and text.
	var primaryColor: UIColor!
	///A background color of a sub menu. This would also be the color of primary menu's activity bar and text.
	var secondaryColor: UIColor!
	///An optional logo image
	var logoImage: UIImage!
	///Set this property to `false` if you do not want the logo. Default value is `true`.
	var shouldDisplayLogo: Bool!
	///Covers status backround view, so that the status bar is inside the tab bar. Defaults to `false`, which results in respecting the safeArea.
	var respectSafeAreas: Bool!
	///Position the TabBar on `.top` or `.bottom` of the SubTabViewController.
	var position: TabBarPosition!
	/// Initializer for NavigationBarController
	/// - Parameters:
	///   - tabItems: An array of primary menu items, with their respective sub menu items.
	///   - height: Overall height of the NavigationBarController. The height is distributed among the primary and secondary bars in approximate 3:1 ratio. Defaults to 156
	///   - primaryColor: A background color of a primary menu. This would also be the color of sub menu's activity bar and text. Defaults to UIColor.blue.
	///   - secondaryColor: A background color of a sub menu. This would also be the color of primary menu's activity bar and text. Defaults to UIColor.white.
	///   - logoImage: An optional logo image
	///   - shouldDisplayLogo: Set this property to `false` if you do not want the logo. Default value is `true`. In case this property is `true` and the `logoImage` property is not provided, logo placeholder will display a generic "no_image" UIImage.
	///   - respectSafeAreas: Bool indicating whether tab bar respect the safe areas. Defaults to `true`.
	///	  - position: Position the TabBar on `.top` or `.bottom` of the SubTabViewController. Defaults to `.top`.
	public init(tabItems:[MenuItemEntry],
				height: CGFloat = 156,
				primaryColor: UIColor = .blue,
				secondaryColor: UIColor = .white,
				logoImage: UIImage? = nil,
				shouldDisplayLogo: Bool = true,
				respectSafeAreas: Bool = true,
				position:  TabBarPosition = .top) {
		self.tabItems = tabItems
		self.height = height
		self.primaryColor = primaryColor
		self.secondaryColor = secondaryColor
		self.shouldDisplayLogo = shouldDisplayLogo
		self.respectSafeAreas = respectSafeAreas
		self.position = position
		
		let image = Bundle.module.path(forResource: "no_image", ofType: "png")
		self.logoImage = logoImage ?? UIImage(named: image!)
		super.init(nibName: "NavigationBaseController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		loadTabBar()
		customTabBar.delegate = self
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.customTabBar.primarySegmentSelected(sender: self.customTabBar.primaryButtons.first!)
	}
	
	func loadTabBar() {
		self.setupCustomTabBar(tabItems) { (controllers) in
			self.viewControllers = controllers
		}
		self.selectedIndex = 0 // default our selected index to the first item
	}
	func setupCustomTabBar(_ items: [MenuItemEntry], completion: @escaping ([UIViewController]) -> Void) {
		var controllers = [UIViewController]()
		// hide the tab bar
		tabBar.isHidden = true
		self.customTabBar = TabbedHeaderView()
		self.customTabBar.primaryColor = primaryColor
		self.customTabBar.secondaryColor = secondaryColor
		self.customTabBar.logoImage = self.shouldDisplayLogo ? self.logoImage : UIImage()
		self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
		self.customTabBar.primaryMenuItems = items
		self.customTabBar.clipsToBounds = false
		self.customTabBar.secondaryItemSelected = self.changeTab
		// Add it to the view
		self.view.addSubview(customTabBar)
		
		self.layoutFor(self.position, safeAreas: self.respectSafeAreas)
		self.customTabBar.layoutIfNeeded()
		
		for item in items {
			if let submenuItems = item.tabItem.subMenuItems {
				for i in 0..<submenuItems.count {
					controllers.append(item.tabItem.subMenuItems![i].viewController)
				}
			}
		}
		self.view.layoutIfNeeded() 
		completion(controllers) // setup complete. handoff here
	}
	
	private func layoutFor(_ position: TabBarPosition, safeAreas: Bool) {
		let leadingAnchor = safeAreas ? self.view.safeAreaLayoutGuide.leadingAnchor : self.view.leadingAnchor
		let trailingAnchor = safeAreas ? self.view.safeAreaLayoutGuide.trailingAnchor : self.view.trailingAnchor
		switch position {
			case .top:
				let topAnchor = safeAreas ? self.view.safeAreaLayoutGuide.topAnchor : self.view.topAnchor
				NSLayoutConstraint.activate([self.customTabBar.topAnchor.constraint(equalTo: topAnchor)])
			case .bottom:
				let bottomAnchor = safeAreas ? self.view.safeAreaLayoutGuide.bottomAnchor : self.view.bottomAnchor
				NSLayoutConstraint.activate([self.customTabBar.bottomAnchor.constraint(equalTo: bottomAnchor)])
		}
		NSLayoutConstraint.activate([
			self.customTabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
			self.customTabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
			self.customTabBar.heightAnchor.constraint(equalToConstant: self.height)
		])
	}
	
	func changeTab(item: SubMenuTabItem) {
		self.selectedIndex = item.tab ?? 0
	}
}

extension SubTabViewController: CustomTabbedHeaderDelegate {
	func didSelectSegment(entry: SubMenuTabItem) {
		print("Selected: \(entry.title)")
	}
}

public enum TabBarPosition {
	case top, bottom
}
