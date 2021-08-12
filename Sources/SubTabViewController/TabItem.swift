//
//  TabItem.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 7.6.21..
//

import UIKit

///Represents a primary menu item which itself, does not contain a ViewController, but is merely a segue to one of its sub tabs.
public class PrimaryTabItem: MenuButton {
	var title: String
	var subMenuItems: [SubMenuTabItem]?
	public init(title: String, subMenuItems: [SubMenuTabItem]) {
		self.title = title
		self.subMenuItems = subMenuItems
	}
}

///Represents a sub menu item which contains a ViewController.
public class SubMenuTabItem: MenuButton {
	var title: String
	var tab: Int?
	var viewController: UIViewController
	
	public init(title: String, viewController: UIViewController) {
		self.title = title
		self.viewController = viewController
	}
}
