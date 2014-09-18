Swift Fly
====================================

It's my first application write on Swift

###Preview: 

<p align="center">
  <img src="http://adowya.fr/img/swiftfly2.png" />
  <img src="http://adowya.fr/img/swiftfly1.png" />
</p>


Features
======

- Home screen / Switching views
- Display flight start/stop/duration time values
- GPS Lookup of nearest airflied
- Data persistance
- List / manage past flights

Tree
======

```html
FlySupCaen
	airports.plist // Locations of airports
	FlyListPersistent.xcdatamodeld //BDD
	PersistenceHelper.swift // Persistance object
	LocationManager.swift // Check user location
	FlyManager.swift // Class Fly
	AppDelegate.swift 
	Base.lproj // Main.storyboard
	FirstViewController.swift // Fist view
	Images.xcassets // All pictures
	Info.plist 
	SecondViewController.swift // Second view

```

