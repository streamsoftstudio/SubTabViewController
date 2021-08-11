//
//  TabItem.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 7.6.21..
//

import UIKit

class TabItem {
	let title: String
	var tab: Int?
	var viewController: UIViewController?
	
	init(title: String, tab: Int? = nil, viewController: UIViewController? = nil) {
		self.title = title
		self.tab = tab
		self.viewController = viewController
	}
}
