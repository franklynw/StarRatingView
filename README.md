# StarRatingView

A simple SwiftUI rating view, with customisable colours.

<img src="Resources//Example1.png" alt="Example 1"/>

## Installation

### Swift Package Manager

In Xcode:
* File ⭢ Swift Packages ⭢ Add Package Dependency...
* Use the URL https://github.com/franklynw/StarRatingView


## Example

> **NB:** All examples require `import StarRatingView` at the top of the source file

```swift
StarRatingView(rating: rating)
    .outline(.purple)
    .padding()
```

### Set a precise width

You can specify a width for the stars view in the init -

```swift
StarRatingView(rating: rating, width: geometry.size.width * 0.5)
```

If the width parameter is omitted, it will fit into the available space.

### Set the base colour

```swift
StarRatingView(rating: rating)
    .baseColor(.myLightBlueColor)
```

### Set the hightlighted colour

```swift
StarRatingView(rating: rating)
    .highlightedColor(.myBrightPinkColor)
```

### Draw an outline around the stars (the highlighted portions)

```swift
StarRatingView(rating: rating)
    .outline(.purple, weight: .semibold)
```


## Licence  

`StarRatingView` is available under the MIT licence.
