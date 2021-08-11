//
//  MenuItemButton.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 19.7.21..
//

import UIKit

enum MenuType {
	case primary, secondary
}
class MenuItemButton: UIButton {
	var type: MenuType = .secondary
	var text: String? = "Some text"
	
	var primaryTextColor: UIColor?
	var secondaryTextColor: UIColor?
	
	private var textLabel: UILabel!
	
	init(title: String,
		 type: MenuType,
		 primaryTextColor: UIColor = .white,
		 secondaryTextColor: UIColor = .blue)
	{
		super.init(frame: CGRect.zero)
		self.text = title
		self.type = type
		setupButton()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupButton()
	}
	
	func setupButton() {
		self.translatesAutoresizingMaskIntoConstraints = false
		textLabel = UILabel()
		textLabel.text = text
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.font = UIFont(name: "MessinaSans-Book", size: 14)
		
		switch type {
			case .primary: textLabel?.textColor = primaryTextColor
			case .secondary: textLabel?.textColor = secondaryTextColor
		}
		
		self.addSubview(textLabel!)
		textLabel.sizeToFit()
		
		NSLayoutConstraint.activate([
			self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.widthAnchor.constraint(equalTo: self.textLabel!.widthAnchor, constant: 20)
		])
		self.layoutIfNeeded()
	}
	
	override var isSelected: Bool {
		didSet {
			self.toggleSelection()
		}
	}
	
	func toggleSelection() {
		changeColorForState(self.isSelected)
	}
	
	private func changeColorForState(_ selected: Bool) {
		switch type {
			case .primary: 	 self.textLabel.textColor = .white
			case .secondary: self.textLabel.textColor = selected ? secondaryTextColor : .darkGray
		}
		self.textLabel.font = selected ? UIFont(name: "MessinaSans-SemiBold", size: 14) : UIFont(name: "MessinaSans-Book", size: 14)
	}
}
