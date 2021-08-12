//
//  MenuItemEntry.swift
//  
//
//  Created by Dusan Juranovic on 11.8.21..
//

import Foundation
protocol MenuButton {
	var title: String {get set}
}
public struct MenuItemEntry {
	var tabItem: PrimaryTabItem
	var subMenuItems: [SubMenuTabItem]?
	
	public init(tabItem: PrimaryTabItem, subMenuItems: [SubMenuTabItem]?) {
		self.tabItem = tabItem
		self.subMenuItems = subMenuItems
	}
}
