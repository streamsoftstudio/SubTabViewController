# SubTabViewController overview

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)

SubTabViewController is a custom UITabViewController capable of displaying a large number of tabs in a 1 level deep drill-down to sub menus. Each of primary tabs can have as many sub menu tabs as needed.

# _Installing the `SubTabViewController`_
Installing the `SubTabViewController` is possible with `Swift Package Manager (SPM)`
### <u>_Swift Package Manager (SPM)_</u>
The [Swift Package Manager](https://swift.org/package-manager/) is a dependency manager integrated into the `swift` compiler and `Xcode`.

To integrate `SubTabViewController` into an Xcode project, go to the project editor, and select `Swift Packages`. From here hit the `+` button and follow the prompts using  `https://github.com/streamsoftstudio/SubTabViewController.git` as the URL.

To include `SubTabViewController` in a Swift package, simply add it to the dependencies section of your `Package.swift` file. And add the product `SubTabViewController` as a dependency for your targets.

```Swift
dependencies: [
	.package(url: "https://github.com/streamsoftstudio/SubTabViewController.git", .upToNextMinor(from: "1.0.3"))
]
```
# _Using the `SubTabViewController`_
In order to use `SubTabViewController` in your application, there are a few steps that you would need to take.

## **_Initialization_**
Instantiate the `SubTabViewController` as usual, via 

`public init(tabItems:height:primaryColor:secondaryColor:logoImage:shouldDisplayLogo:)`

method after adding import statement:
```Swift
import SubTabViewController
```

Values for the init are as follows:
- tabItems: An array of primary menu items, with their respective sub menu items.
- height: Overall height of the NavigationBarController. The height is distributed among the primary and secondary bars in approximate 3:1 ratio. Defaults to 156
- primaryColor: A background color of a primary menu. This would also be the color of sub menu's activity bar and text. Defaults to UIColor.blue.
- secondaryColor: A background color of a sub menu. This would also be the color of primary menu's activity bar and text. Defaults to UIColor.white.
- logoImage: An optional logo image
- shouldDisplayLogo: Set this property to `false` if you do not want the logo. Default value is `true`. In case this property is `true` and the `logoImage` property is not provided, logo placeholder will display a generic "no_image" UIImage.
- coversStatusBar: Covers status view, so that the status bar is inside the tab bar. Defaults to `false`, which results in respecting the safeArea.

NOTE: Some of the properties have default values and can be ommited from the initializer if default values are what you need.

## **_Implementation_**
In order to populate the tabs, pass-in an array of `[MenuItemEntry]` into the initializer.
Each `MenuItemEntry` has subMenuItems, of which, each sub menu item has `viewController` property which is the view controller to be displayed on selection of the sub tab.
This array needs to be formed as per example below:

```Swift
	var menues = [
		MenuItemEntry(tabItem: PrimaryTabItem(title: "Primary Tap 1", subMenuItems: [
			SubMenuTabItem(title: "Sub tab 1", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 2", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 3", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 4", viewController: UIViewController())
		])),
		MenuItemEntry(tabItem: PrimaryTabItem(title: "Primary Tap 2", subMenuItems: [
			SubMenuTabItem(title: "Sub tab 1", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 2", viewController: UIViewController()))
		])),
		MenuItemEntry(tabItem: PrimaryTabItem(title: "Primary Tap 3", subMenuItems: [
			SubMenuTabItem(title: "Sub tab 1", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 2", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 3", viewController: UIViewController()))
		])),
		MenuItemEntry(tabItem: PrimaryTabItem(title: "Primary Tap 4", subMenuItems: [
			SubMenuTabItem(title: "Sub tab 1", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 2", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 3", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 4", viewController: UIViewController()),
			SubMenuTabItem(title: "Sub tab 5", viewController: UIViewController())
		]))
	]
```

```Swift
	let subTabViewController = SubTabViewController(tabItems: menues,
													height: 200,
													primaryColor: .myCustomPrimaryColor,
													secondaryColor: .myCustomSecondaryColor,
													logoImage: UIImage(named: "myLogoImage"),
													shouldDisplayLogo: true,
													coverStatusBar: true)
	
	subTabViewController.modalPresentationStyle = .fullScreen
	present(subTabViewController, animated: true, completion: nil)
```
