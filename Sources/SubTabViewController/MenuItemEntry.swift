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
	
	public init(tabItem: PrimaryTabItem) {
		self.tabItem = tabItem
	}
}
