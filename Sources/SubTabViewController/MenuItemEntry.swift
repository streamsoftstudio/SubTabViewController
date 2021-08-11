//
//  MenuItemEntry.swift
//  
//
//  Created by Dusan Juranovic on 11.8.21..
//

import Foundation

public struct MenuItemEntry {
	var tabItem: TabItem
	var subMenuItems: [MenuItemEntry]?
	
	public init(tabItem: TabItem, subMenuItems: [MenuItemEntry]?) {
		self.tabItem = tabItem
		self.subMenuItems = subMenuItems
	}
}
