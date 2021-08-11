//
//  NavigationBaseController.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 7.6.21..
//

import UIKit

public class NavigationBaseController: UITabBarController {
	var customTabBar: TabbedHeaderView!
	var tabItems: [MenuItemEntry] = []
	var height: CGFloat!
	
	var primaryColor: UIColor!
	var secondaryColor: UIColor!
	var logoImage: UIImage!
	
	public init(tabItems:[MenuItemEntry], height: CGFloat = 156, primaryColor: UIColor = .blue, secondaryColor: UIColor = .white, logoImage: UIImage? = UIImage(named: "no_photo")) {
		self.tabItems = tabItems
		self.height = height
		self.primaryColor = primaryColor
		self.secondaryColor = secondaryColor
		self.logoImage = logoImage
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
		self.customTabBar.logoImage = self.logoImage
		self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
		self.customTabBar.primaryMenuItems = items
		self.customTabBar.clipsToBounds = false
		self.customTabBar.secondaryItemSelected = self.changeTab
		// Add it to the view
		self.view.addSubview(customTabBar)
		NSLayoutConstraint.activate([
			self.customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.customTabBar.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.customTabBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.customTabBar.heightAnchor.constraint(equalToConstant: self.height)
		])
		
		for item in items {
			if let submenuItems = item.subMenuItems {
				for i in 0..<submenuItems.count {
					controllers.append(item.subMenuItems![i].tabItem.viewController!)
				}
			}
		}
		self.view.layoutIfNeeded() 
		completion(controllers) // setup complete. handoff here
	}
	func changeTab(tab: TabItem) {
		self.selectedIndex = tab.tab ?? 0
	}
}

extension NavigationBaseController: CustomTabbedHeaderDelegate {
	func didSelectSegment(entry: MenuItemEntry) {
		print("Selected: \(entry.tabItem.title)")
	}
}

