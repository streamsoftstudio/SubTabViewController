//
//  TabItem.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 7.6.21..
//

import UIKit

public class PrimaryTabItem: MenuButton {
	var title: String
	var subMenuItems: [SubMenuTabItem]?
	public init(title: String, subMenuItems: [SubMenuTabItem]) {
		self.title = title
		self.subMenuItems = subMenuItems
	}
}

public class SubMenuTabItem: MenuButton {
	var title: String
	var tab: Int
	var viewController: UIViewController
	
	public init(title: String, tab: Int, viewController: UIViewController) {
		self.title = title
		self.tab = tab
		self.viewController = viewController
	}
}
