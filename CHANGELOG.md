# Changelog

## [1.5.1] - 2026-08-15 (Bug Fix Release)

### **Fixes:**
- Fixed `CustomTextField` silently accepting invalid input: when used without a `validationController`, its internal `TextFormField`/`DropdownButtonFormField` validator always returned `null` regardless of what `validator` computed, so a wrapping `Form.validate()` could never fail because of the field — invalid values (e.g. a malformed phone number) would pass validation and could be submitted. The validator now reports the real result to the `Form`.
- Fixed `AppImage` network images failing to load on Flutter Web: `CachedNetworkImage`/`CachedNetworkImageProvider` now fall back to `Image.network`/`NetworkImage` on web, where the disk-caching plugin isn't supported. Also treats whitespace-only image strings as absent instead of attempting to load them.

### **Chores:**
- Bumped `connectivity_plus` from `^7.1.1` to `^7.3.1`.

## [1.5.0] - 2026-05-19 (Feature Release)

### **Breaking Changes:**
- Removed `shared_preferences` dependency and the `SharedPreferencesService` class.
- Removed `logger` dependency and the `logger` utility.

### **Enhancements:**
- Added `CustomRatingBar` widget for advanced star rating systems.
- Replaced internal `logger` usage with `debugPrint` in `AppImage`.
- Enhanced `InternetConnectionChecker` with support for `vpn`, `satellite`, and `other` connectivity types.
- Improved stability of `InternetChecker` with safer connectivity result list handling.
- Modernized color manipulation using `withValues` instead of `withOpacity`.
- Fixed `CustomTextField` issues:
    - Resolved text clipping/blurring at the bottom and top of the field by optimizing internal padding and line-height estimates.
    - Fixed `ErrorStyle` not applying to the validation icon.
    - Improved lifecycle management of `FocusNode` updates.
- Updated `README.md` and example app with comprehensive usage examples for all features including Animations and Functional Programming types.
- Overall enhancements and performance optimizations.

---

## [1.4.3] - 2025-11-26 (Fix Release)

### **Fixes & Enhancements:**
- Updated `CustomTextField` to support autofill and bumped version to 1.4.3.

---

## [1.4.2] - 2025-09-12 (Fix Release)

### **Fixes & Enhancements:**
- Fixed `CustomTextField` height constraints and padding for multiline support.
  - Adjusted `maxHeight` constraint to be `double.infinity` when `maxLines` is not 1, allowing the text field to expand vertically.
  - Set `minLines` to 1 in the underlying `TextField` to ensure a consistent starting height.
  - Modified the vertical padding calculation to better accommodate multiline text.
  - Upgraded `connectivity_plus` to `^7.0.0`.
  - Upgraded `logger` to `^2.6.2`.

---

## [1.4.1] - 2025-09-05 (Refactor & Fix Release)

### **Refactoring & Formatting:**
- Refactored and formatted code for improved readability and consistency.

### **Fixes & Enhancements:**
- **`AppImage`**: Enhanced the error icon in `_defaultErrorWidget` to scale proportionally with the image container's height.

---

## [1.4.0] - 2025-08-24 (Feature Release)

### **New Features:**
- **CustomRangeSlider**: Introduced a highly customizable dual-handle range slider widget with:
    - Custom theming for track, thumb, and overlay colors
    - Optional haptic feedback and customizable accessibility labels
    - Discrete or continuous value selection with validation and clamping
    - Animated thumb scaling on interaction with Material 3 inspired design
    - Elevation shadow and border effects with rounded track shape

- **ValidationKey**: Implemented new validation management system with:
    - `ValueNotifier<String>` wrapper for managing validation field keys
    - Debug labeling for easier troubleshooting
    - Comprehensive lifecycle management with listener support
    - Integration with `ValidationController` for enhanced field management

### **New Utility Types:**
- **Either<L, R>**: Added functional programming support with:
    - Left/Right value representation for failure/success patterns
    - Comprehensive transformation methods (map, bimap, flatMap, fold)
    - Error handling utilities (tryCatch, tryCatchAsync)
    - Combining operations (zip, zipWith) and recovery mechanisms
    - Future integration with async operation extensions
    - `EitherUtils` for sequence, traverse, and firstRight operations

- **Option<T>**: Introduced optional value handling with:
    - Some/None pattern implementation
    - Core operations (fold, map, flatMap, getOrElse)
    - Conversion utilities to Either types

- **Unit**: Added unit type for representing absence of value in generic contexts

### **Enhancements:**
- **CustomTextField**:
    - Reordered initialization methods for improved clarity and reliability
    - Added `validationKey` property for `ValidationKey` association
    - Updated text style to use `bodyLarge` instead of `displayMedium`
    - Enhanced validation initialization with non-empty text handling
    - Adjusted `minHeight` constraint for multiline support

- **ValidationController**:
    - Added `updateFieldValueAt` method for index-based field updates
    - Implemented `fieldKeys` getter for retrieving all registered field keys
    - Enhanced documentation with comprehensive method descriptions

- **ImageBackground**:
    - Made `child` parameter optional for increased flexibility
    - Updated rendering logic to conditionally display child content

### **New Extensions:**
- **List Extensions**:
    - Added `itemMargin` extension for calculating list item margins by position
    - Implemented `itemMargins` extension returning named record with left/right margins

### **Documentation:**
- Enhanced code documentation across all new components
- Added comprehensive usage examples for new components
- Improved API documentation for validation system

### **Dependencies:**
- Upgraded `connectivity_plus` to `^6.1.5`.
- Upgraded `logger` to `^2.6.1`.

---

## [1.3.0] - 2025-07-07 (Feature Release)

### **New Features:**
- **ValidationController**: Introduced high-performance form validation solution with:
    - Field registration/validation management
    - Efficient change detection
    - State/error message access
    - Batch validation capabilities

### **Improvements:**
- **CustomTextField**:
    - Integrated `ValidationController` support
    - Added `focusNode` and `textInputAction` properties
    - Optimized lifecycle management and state updates
    - Refactored internal logic for clarity and efficiency

- **Image Widgets**:
    - Added `placeholderColor` property to `AppCircleImage` and `AppImage`
    - Implemented default dimensions (`defaultWidth`/`defaultHeight`) for `ImageBackground`
    - Enhanced circular clipping logic
    - Improved default placeholder styling using theme colors

### **Documentation:**
- Updated README with usage examples and feature descriptions

### **Dependencies:**
- Upgraded `logger` dependency to `^2.6.0`
- Removed `equatable` dependency
- Marked `shared_preferences` and `logger` for future removal

--- 

## [1.2.0] - 2025-06-10 (Feature Release)

### **Features:**
- **CustomTextField**: Introduced a powerful and highly customizable `CustomTextField` widget with built-in validation, styling options, accessibility enhancements, and dropdown support. 
- **Connectivity Bloc Demo**: Added a comprehensive demo showcasing real-time internet connectivity monitoring using the `Bloc` pattern, complete with events, states, and a repository. 
- **ImageBackground Widget**: Launched a new `ImageBackground` widget to easily display images with overlay content.

### **New Animation Widgets**:
- **AnimatedFadeScale**: A widget for combining fade and scale animations seamlessly.
- **FadeSlideTransition**: A transition widget for creating smooth fade and slide effects.
- **UI Assets**: Added password visibility toggle icons directly to the package assets.

### **Improvements**:
- **Theming**: Added the `AppColors` class, providing a set of predefined color constants for consistent UI theming.
- **String Extensions**: Included a capitalize extension on the `String` class for convenient text formatting.

---

## [1.1.0] - 2025-04-20 (Feature Release)

### **Features:**
- **Enhanced Image Handling**: Added comprehensive file support (`File` objects) for both `AppImage` and `AppCircleImage` widgets.
- **Border Radius Support**: Introduced `borderRadius` parameter for `AppImage` to enable custom clipping without additional widgets.
- **Background Customization**: Added `backgroundColor` parameter to both image widgets for better visual integration.
- **Performance Optimizations**: Implemented device pixel ratio-aware image caching for improved memory usage.
- **Robust Source Detection**: Enhanced network URL validation with multiple detection methods for more reliable image loading.

### **Improvements:**
- **Unified Image API**: Consolidated handling of network, asset, and file sources through a single consistent interface.
- **Error Handling**: Improved logging and fallback mechanisms for better debugging and user experience.
- **Customization**: Added `fit` parameter to `AppCircleImage` for more control over image scaling.
- **Documentation**: Enhanced code documentation and usage examples.

### **Deprecated:**
- The `assetFallback` parameter is now recommended to be replaced with `fallbackImage` for naming consistency (backward compatible).

### **Other Changes:**
- Fixed edge cases in network URL detection and fallback image handling.
- Improved default placeholder and error widgets for better visual consistency.

---

## [1.0.0] - 2025-01-08 (Major Release)

### **Features:**
- **PIN Screen**: Introduced a secure and customizable PIN entry widget for robust user authentication.
- **Internet Connection Checker**: Integrated utilities for real-time internet connectivity monitoring, enabling developers to build apps that gracefully handle network availability.
- **Versatile Image Handling**: Added customizable image widget features, including circular and rectangular shapes with placeholders, error handling, and fallbacks, simplifying image management in Flutter apps.

### **Deprecated:**
- Streamlined API: Deprecated `SharedPreferencesService` in favor of leveraging the latest `shared_preferences` package API for a more efficient approach to managing shared preferences.

### **Other Changes:**
- Bug fixes and general improvements across the library.
- Enhanced usability and code readability by streamlining utility functions and extensions.

---

## [0.0.6] - 2024-03-20

- Minor fixes and upgrades to improve performance.

## [0.0.5] - 2024-03-20

- Improved documentation for the `SharedPreferencesService` class.
- Added example usage in `README.md`.
- Bug fixes and performance improvements.

## [0.0.4] - 2024-03-20

- Introduced `SharedPreferencesService` class for managing SharedPreferences in Flutter applications.
- Implemented methods for storing and retrieving various data types in SharedPreferences.
- Added methods to initialize, clear, and remove data from SharedPreferences.

## [0.0.3] - 2024-02-09

### **Changes:**
- Formatted Dart code.
- Further updated documentation for improved clarity.

## [0.0.2] - 2024-02-08

### **Added:**
- Added sample tests to ensure functionality.

### **Changes:**
- Updated documentation for better guidance.

## [0.0.1] - 2024-02-08

- **Initial release.**
