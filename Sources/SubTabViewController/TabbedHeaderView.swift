//
//  TabbedHeaderView.swift
//  AspenDental
//
//  Created by Dusan Juranovic on 19.7.21..
//

import UIKit
protocol CustomTabbedHeaderDelegate: AnyObject {
	func didSelectSegment(entry:SubMenuTabItem)
}
class TabbedHeaderView: UIView {

	@IBOutlet var containerView: UIView!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var primaryMenuStack: UIStackView!
	@IBOutlet weak var secondaryMenuStack: UIStackView!
	@IBOutlet weak var primaryActivityView: UIView!
	@IBOutlet weak var secondaryActivityView: UIView!
	@IBOutlet weak var topSectionBackgroundView: UIView!
	@IBOutlet weak var bottomSectionBackgroundView: UIView!
	
	var primaryColor: UIColor! = .blue {
		didSet {
			self.applyColors()
		}
	}
	var secondaryColor: UIColor! = .white {
		didSet {
			self.applyColors()
		}
	}
	
	var logoImage: UIImage! {
		didSet {
			self.applyLogo()
		}
	}
	
	weak var delegate: CustomTabbedHeaderDelegate?
	var secondaryItemSelected: ((_ tab: SubMenuTabItem) -> Void)?
	
	var primaryMenuItems: [MenuItemEntry]! {
		didSet {
			self.setupPrimaryMenu()
		}
	}
	var secondaryMenuItems: [SubMenuTabItem]!
	var primaryButtons: [MenuItemButton] = []
	var secondaryButtons: [MenuItemButton] = []
	
	var currentlyActivePrimaryMenuItemIndex: Int?
	var currentlyActiveSecondaryMenuButton: MenuItemButton?
	
	var overallSubmenusCount: Int = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.commonInit()
	}
	
	func commonInit() {
		let bundle = Bundle.module
		let nib = UINib(nibName: "TabbedHeaderView", bundle: bundle)
		nib.instantiate(withOwner: self, options: nil)
		self.containerView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(containerView)
		self.addConstraints()
	}
	
	func applyColors() {
		self.primaryActivityView.backgroundColor = secondaryColor
		self.secondaryActivityView.backgroundColor = primaryColor
		self.topSectionBackgroundView.backgroundColor = primaryColor
		self.bottomSectionBackgroundView.backgroundColor = secondaryColor
	}
	
	func applyLogo() {
		self.logoImageView.image = logoImage
	}
	
	func addConstraints() {
		NSLayoutConstraint.activate([
			self.topAnchor.constraint(equalTo: containerView.topAnchor),
			self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		])
		self.layoutIfNeeded()
	}
	
	func setupPrimaryMenu() {
		primaryMenuItems.forEach {$0.tabItem.subMenuItems?.forEach {
			$0.tab = overallSubmenusCount
			overallSubmenusCount += 1
		}}
		for (index, prim) in primaryMenuItems.enumerated() {
			let primaryButton = createButton(prim.tabItem, type: .primary)
			primaryButton.tag = index
			
			primaryMenuStack.addArrangedSubview(primaryButton)
			primaryButtons.append(primaryButton)
		}
		self.primaryMenuStack.layoutIfNeeded()
	}
	
	func updateSecondaryMenu(for primaryMenuItem: MenuItemEntry) {
		for view in secondaryMenuStack.subviews where view is MenuItemButton {
			view.removeFromSuperview()
		}
		secondaryButtons = []
		guard let secondaryItems = primaryMenuItem.tabItem.subMenuItems else {return}
		for (index, sec) in secondaryItems.enumerated() {
			let secondaryButton = createButton(sec, type: .secondary)
			secondaryButton.tag = index
			secondaryMenuStack.insertArrangedSubview(secondaryButton, at: secondaryMenuStack.subviews.count - 1)
			secondaryButtons.append(secondaryButton)
		}
		secondaryMenuItems = primaryMenuItem.tabItem.subMenuItems
		secondaryMenuStack.layoutIfNeeded()
		secondarySegmentSelected(sender: secondaryButtons.first!)
	}
	
	private func createButton(_ entry: MenuButton, type: MenuType) -> MenuItemButton {
		let button = MenuItemButton(title: entry.title, type: type, primaryTextColor: secondaryColor, secondaryTextColor: primaryColor)
		
		switch type {
			case .primary: button.addTarget(self, action: #selector(primarySegmentSelected), for: .touchUpInside)
			case .secondary: button.addTarget(self, action: #selector(secondarySegmentSelected), for: .touchUpInside)
		}
		
		return button
	}
	
	@objc func primarySegmentSelected(sender: MenuItemButton) {
		guard sender.tag != currentlyActivePrimaryMenuItemIndex else {return}
		for button in self.primaryButtons {
			button.isSelected = button == sender
			if button.isSelected {
				let index = button.tag
				self.currentlyActivePrimaryMenuItemIndex = index
				let selectedItem = primaryMenuItems[index]

				slideActivityUnderButton(button)
				self.updateSecondaryMenu(for: selectedItem)
			}
		}
	}
	
	@objc private func secondarySegmentSelected(sender: MenuItemButton) {
		guard sender != self.currentlyActiveSecondaryMenuButton else {return}
		for button in self.secondaryButtons {
			button.isSelected = button == sender
			let index = sender.tag
			if button.isSelected {
				self.slideActivityUnderButton(button)
				self.currentlyActiveSecondaryMenuButton = button
				self.secondaryItemSelected?(secondaryMenuItems[index])
				self.delegate?.didSelectSegment(entry: secondaryMenuItems[index])
			}
		}
	}
	
	func slideActivityUnderButton(_ button: MenuItemButton?, animated: Bool = true) {
		guard let button = button else {return}
		DispatchQueue.main.async {
			switch button.type {
				case .primary:
					if animated {
						UIView.animate(withDuration: 0.3) {
							self.primaryActivityView.transform = CGAffineTransform(translationX: button.frame.origin.x, y: 1)
							self.primaryActivityView.frame.size.width = button.frame.size.width
							self.secondaryActivityView.transform = .identity
						}
					} else {
						self.primaryActivityView.transform = CGAffineTransform(translationX: button.frame.origin.x, y: 1)
						self.primaryActivityView.frame.size.width = button.bounds.size.width
						self.secondaryActivityView.transform = .identity
					}
				case .secondary:
					if animated {
						UIView.animate(withDuration: 0.3) {
							self.secondaryActivityView.transform = CGAffineTransform(translationX: button.frame.origin.x, y: 1)
							self.secondaryActivityView.frame.size.width = button.frame.size.width
						}
					} else {
						self.secondaryActivityView.transform = CGAffineTransform(translationX: button.frame.origin.x, y: 1)
						self.secondaryActivityView.frame.size.width = button.frame.size.width
					}
			}			
		}
	}
}


