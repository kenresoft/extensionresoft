// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../utility/app_colors.dart';
import 'text_field_assets.dart';
import 'text_field_configs.dart';
import 'text_field_validation.dart';

/// Enhanced CustomTextField with improved performance, accessibility, and customization
class CustomTextField<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final bool isPassword;
  final bool isRequired;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onPrefixIconTap;
  final VoidCallback? onSuffixIconTap;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? focusColor;
  final Color? borderColor;
  final double borderWidth;
  final double? focusBorderWidth;
  final BorderRadius? focusBorderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final String? helperText;
  final int? helperMaxLines;

  // Dropdown-specific properties
  final List<DropdownMenuItem<T>>? items;
  final T? dropdownValue;
  final Function(T?)? onDropdownChanged;
  final bool showDropdownIcon;

  // Enhanced properties
  final TextFieldAnimationConfig animationConfig;
  final String? semanticsLabel;
  final String? semanticsHint;
  final ValueChanged<ValidationResult>? onValidationChanged;
  final bool autofocus;
  final bool autoValidateMode;
  final GlobalKey<FormFieldState>? fieldKey;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  // Password visibility configuration
  final PasswordVisibilityConfig passwordVisibilityConfig;

  // Error styling (kept for backward compatibility)
  final TextStyle? errorStyle;
  final TextStyle? warningStyle;
  final TextStyle? helperStyle;
  final TextStyle? infoStyle;
  final EdgeInsetsGeometry? feedbackPadding;
  final bool feedbackShowIcons;
  final Duration feedbackAnimationDuration;

  // Enhanced accessibility features
  final String? accessibilityHint;
  final bool announceValidationStatus;

  /// Creates a CustomTextField with enhanced capabilities.
  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.isPassword = false,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.width,
    this.height,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.onSaved,
    this.decoration,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.borderRadius,
    this.fillColor,
    this.focusColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.focusBorderWidth,
    this.focusBorderRadius,
    this.contentPadding,
    this.margin,
    this.helperText,
    this.helperMaxLines,
    // Dropdown-specific properties
    this.items,
    this.dropdownValue,
    this.onDropdownChanged,
    this.showDropdownIcon = true,
    // Enhanced properties
    this.animationConfig = TextFieldAnimationConfig.defaultConfig,
    this.semanticsLabel,
    this.semanticsHint,
    this.onValidationChanged,
    this.autofocus = false,
    this.autoValidateMode = false,
    this.fieldKey,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    // Password visibility configuration
    this.passwordVisibilityConfig = PasswordVisibilityConfig.defaultConfig,
    // Error styling
    this.errorStyle,
    this.helperStyle,
    this.warningStyle,
    this.infoStyle,
    this.feedbackPadding,
    this.feedbackShowIcons = true,
    this.feedbackAnimationDuration = const Duration(milliseconds: 200),
    // Enhanced accessibility
    this.accessibilityHint,
    this.announceValidationStatus = true,
  });

  @override
  State<CustomTextField<T>> createState() => _CustomTextFieldState<T>();
}

/// State implementation for CustomTextField with optimized rebuilds
class _CustomTextFieldState<T> extends State<CustomTextField<T>>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late LazyValueNotifier<bool> _obscureTextNotifier;
  late LazyValueNotifier<bool> _isFocusedNotifier;
  late LazyValueNotifier<ValidationResult?> _validationResultNotifier;
  final FocusNode _focusNode = FocusNode();

  // Animation controller for validation feedback
  late AnimationController _validationAnimationController;
  late Animation<double> _shakeAnimation;

  /// Memoized decoration to prevent unnecessary rebuilds
  InputDecoration? _cachedDecoration;
  bool _isDirty = false;
  ThemeData? _lastTheme;
  TextScaler? _lastTextScaler;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeNotifiers();
    _initializeAnimations();
    _setupEventListeners();
    _handleAutofocus();
  }

  /// Initialize text controller with provided or default value
  void _initializeControllers() {
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  /// Initialize lazy value notifiers for efficient state management
  void _initializeNotifiers() {
    _obscureTextNotifier = LazyValueNotifier(() => widget.isPassword);
    _isFocusedNotifier = LazyValueNotifier(() => false);
    _validationResultNotifier = LazyValueNotifier(() => null);
  }

  /// Setup animation controllers for smooth transitions
  void _initializeAnimations() {
    _validationAnimationController = AnimationController(
      duration: widget.animationConfig.errorTransitionDuration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_validationAnimationController);
  }

  /// Setup event listeners for focus and state changes
  void _setupEventListeners() {
    _focusNode.addListener(_handleFocusChange);
  }

  /// Handle autofocus if requested
  void _handleAutofocus() {
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(CustomTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleControllerUpdates(oldWidget);
    _invalidateDecorationCache();
  }

  /// Handle external controller changes
  void _handleControllerUpdates(CustomTextField<T> oldWidget) {
    if (widget.controller != oldWidget.controller && widget.controller != null) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller!;
    }
  }

  /// Invalidate decoration cache when widget updates
  void _invalidateDecorationCache() {
    _cachedDecoration = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Invalidate cache when theme or text scaling changes
    _cachedDecoration = null;
  }

  /// Handle focus state changes and mark field as dirty
  void _handleFocusChange() {
    _isFocusedNotifier.value = _focusNode.hasFocus;
    if (_focusNode.hasFocus && !_isDirty) {
      _isDirty = true;
    }
  }

  // ===========================
  // VALIDATION LOGIC
  // ===========================

  /// Perform comprehensive field validation with optimized logic
  void _performValidation() {
    final currentText = _controller.text.trim();

    // Early exit for non-required empty fields
    if (_isNonRequiredEmpty(currentText)) {
      _updateValidationResult(ValidationResult.valid());
      return;
    }

    // Handle required field validation
    if (_isRequiredEmpty(currentText)) {
      final fieldName = widget.labelText ?? 'This field';
      _updateValidationResult(ValidationResult.error('$fieldName is required'));
      return;
    }

    // Execute custom validation with error handling
    _executeCustomValidation(currentText);
  }

  /// Check if field is non-required and empty
  bool _isNonRequiredEmpty(String text) {
    return !widget.isRequired && text.isEmpty;
  }

  /// Check if required field is empty
  bool _isRequiredEmpty(String text) {
    return widget.isRequired && text.isEmpty;
  }

  /// Execute custom validator with graceful error handling
  void _executeCustomValidation(String text) {
    if (widget.validator == null) {
      _updateValidationResult(ValidationResult.valid());
      return;
    }

    try {
      final validationMessage = widget.validator!(text);
      final result = validationMessage != null
          ? ValidationResult.error(validationMessage)
          : ValidationResult.valid();
      _updateValidationResult(result);
    } catch (e) {
      // Graceful handling of validator exceptions
      _updateValidationResult(ValidationResult.error('Validation error occurred'));
    }
  }

  /// Update validation result with change detection to prevent unnecessary rebuilds
  void _updateValidationResult(ValidationResult result) {
    final previousResult = _validationResultNotifier.value;

    // Only update if result actually changed
    if (_hasValidationChanged(previousResult, result)) {
      _validationResultNotifier.value = result;
      widget.onValidationChanged?.call(result);
      _handleValidationTransition(previousResult, result);
    }
  }

  /// Check if validation result has meaningfully changed
  bool _hasValidationChanged(ValidationResult? previous, ValidationResult current) {
    return previous?.isValid != current.isValid ||
        previous?.errorMessage != current.errorMessage ||
        previous?.severity != current.severity;
  }

  /// Handle validation state transitions with animations and accessibility
  void _handleValidationTransition(
    ValidationResult? previous,
    ValidationResult current,
  ) {
    _triggerValidationAnimation(previous, current);
    _announceValidationChange(current);
  }

  /// Trigger shake animation for new validation errors
  void _triggerValidationAnimation(
    ValidationResult? previous,
    ValidationResult current,
  ) {
    if (!current.isValid && (previous?.isValid ?? true)) {
      _validationAnimationController.forward().then((_) {
        _validationAnimationController.reset();
      });
    }
  }

  /// Announce validation changes for accessibility
  void _announceValidationChange(ValidationResult current) {
    if (widget.announceValidationStatus && !current.isValid) {
      final announcement = _buildAccessibilityAnnouncement(current);
      SemanticsService.announce(announcement, TextDirection.ltr);
    }
  }

  /// Build contextual accessibility announcements
  String _buildAccessibilityAnnouncement(ValidationResult result) {
    final fieldName = widget.labelText ?? 'Input field';
    final severityText = _getSeverityText(result.severity);
    return '$severityText in $fieldName: ${result.errorMessage}';
  }

  /// Get user-friendly severity text
  String _getSeverityText(ValidationSeverity? severity) {
    switch (severity) {
      case ValidationSeverity.error:
        return 'Error';
      case ValidationSeverity.warning:
        return 'Warning';
      case ValidationSeverity.info:
        return 'Information';
      default:
        return 'Error';
    }
  }

  // ===========================
  // THEMING & STYLING
  // ===========================

  /// Build input decoration with intelligent caching for performance
  InputDecoration _buildInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    // Return cached decoration if theme hasn't changed
    if (_isDecorationCacheValid(theme, mediaQuery)) {
      return _cachedDecoration!;
    }

    // Build and cache new decoration
    _cachedDecoration = _createInputDecoration(context, theme);
    _updateCacheReferences(theme, mediaQuery);

    return _cachedDecoration!;
  }

  /// Check if cached decoration is still valid
  bool _isDecorationCacheValid(ThemeData theme, MediaQueryData mediaQuery) {
    return _cachedDecoration != null &&
        _lastTheme == theme &&
        _lastTextScaler == mediaQuery.textScaler;
  }

  /// Update cache reference tracking
  void _updateCacheReferences(ThemeData theme, MediaQueryData mediaQuery) {
    _lastTheme = theme;
    _lastTextScaler = mediaQuery.textScaler;
  }

  /// Create comprehensive input decoration
  InputDecoration _createInputDecoration(BuildContext context, ThemeData theme) {
    if (widget.decoration != null) {
      return widget.decoration!;
    }

    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      labelStyle: _buildLabelStyle(context, isDark),
      hintStyle: _buildHintStyle(context, isDark),
      filled: true,
      fillColor: _getFillColor(isDark),
      contentPadding: _calculateContentPadding(context, mediaQuery),
      border: _buildBorder(isDark),
      enabledBorder: _buildBorder(isDark),
      focusedBorder: _buildFocusedBorder(isDark),
      prefixIcon: _buildPrefixIcon(),
      suffixIcon: _buildSuffixIcon(isDark, theme),
      errorStyle: const TextStyle(height: 0, fontSize: 0), // Hide built-in error
    );
  }

  /// Build label text style with theme integration
  TextStyle _buildLabelStyle(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.titleMedium ?? const TextStyle();

    return baseStyle
        .merge(widget.labelStyle)
        .copyWith(
          color:
              widget.labelStyle?.color ??
              (isDark ? AppColors.darkInputText : AppColors.lightInputText),
          fontSize: widget.labelStyle?.fontSize ?? baseStyle.fontSize ?? 16,
          height: 1.0,
        );
  }

  /// Build hint text style with theme integration
  TextStyle _buildHintStyle(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.titleMedium ?? const TextStyle();

    return baseStyle
        .merge(widget.hintStyle)
        .copyWith(
          color:
              widget.hintStyle?.color ??
              (isDark ? AppColors.grey5 : AppColors.white5),
          fontSize: widget.hintStyle?.fontSize ?? baseStyle.fontSize ?? 16,
          height: 1.0,
        );
  }

  /// Get appropriate fill color based on theme
  Color _getFillColor(bool isDark) {
    return widget.fillColor ??
        (isDark ? AppColors.darkOutlinedBg : AppColors.lightOutlinedBg);
  }

  /// Calculate content padding with dynamic height support
  EdgeInsetsGeometry _calculateContentPadding(
    BuildContext context,
    MediaQueryData mediaQuery,
  ) {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }

    if (widget.height != null) {
      final textStyle = _getEffectiveTextStyle(context);
      return _calculateDynamicPadding(
        widget.height!,
        textStyle,
        mediaQuery.textScaler,
      );
    }

    return const EdgeInsets.symmetric(horizontal: 14, vertical: 14);
  }

  /// Calculate dynamic padding based on text scale and container height
  EdgeInsets _calculateDynamicPadding(
    double totalHeight,
    TextStyle textStyle,
    TextScaler textScaler,
  ) {
    final fontSize = textStyle.fontSize ?? 16;
    final scaledFontSize = textScaler.scale(fontSize);
    final verticalPadding = (totalHeight - scaledFontSize) / 2;

    return EdgeInsets.symmetric(
      horizontal: 14,
      vertical: verticalPadding.clamp(8, double.infinity),
    );
  }

  /// Build standard border styling
  OutlineInputBorder _buildBorder(bool isDark) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      borderSide: BorderSide(
        color:
            widget.borderColor ??
            (isDark ? AppColors.darkEnabledBorder : AppColors.lightEnabledBorder),
        width: widget.borderWidth,
      ),
    );
  }

  /// Build focused border styling
  OutlineInputBorder _buildFocusedBorder(bool isDark) {
    return OutlineInputBorder(
      borderRadius:
          widget.focusBorderRadius ??
          widget.borderRadius ??
          BorderRadius.circular(8),
      borderSide: BorderSide(
        color:
            widget.focusColor ??
            (isDark ? AppColors.darkFocusedBorder : AppColors.lightFocusedBorder),
        width: widget.focusBorderWidth ?? 2,
      ),
    );
  }

  /// Build prefix icon with tap handling
  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) return null;

    return GestureDetector(
      onTap: widget.onPrefixIconTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: widget.prefixIcon,
      ),
    );
  }

  /// Build suffix icon with conditional password visibility toggle
  Widget? _buildSuffixIcon(bool isDark, ThemeData theme) {
    if (widget.suffixIcon != null) {
      return _buildCustomSuffixIcon();
    }

    if (widget.isPassword) {
      return _buildPasswordVisibilityToggle(theme);
    }

    return null;
  }

  /// Build custom suffix icon with tap handling
  Widget _buildCustomSuffixIcon() {
    return GestureDetector(
      onTap: widget.onSuffixIconTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 16),
        child: widget.suffixIcon,
      ),
    );
  }

  /// Build password visibility toggle with state management
  Widget _buildPasswordVisibilityToggle(ThemeData theme) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextNotifier,
      builder: (context, obscureText, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isFocusedNotifier,
          builder: (context, isFocused, _) {
            return _createPasswordToggleButton(obscureText, isFocused, theme);
          },
        );
      },
    );
  }

  /// Create accessible password toggle button
  Widget _createPasswordToggleButton(
    bool obscureText,
    bool isFocused,
    ThemeData theme,
  ) {
    return Semantics(
      button: true,
      label: obscureText
          ? widget.passwordVisibilityConfig.visibilityOnTooltip
          : widget.passwordVisibilityConfig.visibilityOffTooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: _togglePasswordVisibility,
        child: Padding(
          padding: widget.passwordVisibilityConfig.iconPadding,
          child: _buildVisibilityIcon(obscureText, isFocused, theme),
        ),
      ),
    );
  }

  /// Toggle password visibility with haptic feedback
  void _togglePasswordVisibility() {
    HapticFeedback.lightImpact();
    _obscureTextNotifier.value = !_obscureTextNotifier.value;
  }

  /// Build appropriate visibility icon
  Widget _buildVisibilityIcon(bool isVisible, bool isFocused, ThemeData theme) {
    // Use custom widgets if provided
    final customIcon = isVisible
        ? widget.passwordVisibilityConfig.customVisibilityOnIcon
        : widget.passwordVisibilityConfig.customVisibilityOffIcon;

    if (customIcon != null) {
      return IconTheme(
        data: IconThemeData(
          color: _getIconColor(isFocused),
          size: widget.passwordVisibilityConfig.iconSize,
        ),
        child: customIcon,
      );
    }

    // Use asset resolver for fallback icons
    return AssetResolver.resolveVisibilityIcon(
      isVisible: isVisible,
      userAssetPath: isVisible
          ? widget.passwordVisibilityConfig.customVisibilityOnIconPath
          : widget.passwordVisibilityConfig.customVisibilityOffIconPath,
      color: _getIconColor(isFocused),
      size: widget.passwordVisibilityConfig.iconSize,
    );
  }

  /// Get appropriate icon color based on focus state
  Color? _getIconColor(bool isFocused) {
    return widget.passwordVisibilityConfig.iconColor ??
        (isFocused ? widget.focusColor : null);
  }

  /// Get effective text style considering theme and scaling
  TextStyle _getEffectiveTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseStyle = theme.textTheme.displayMedium ?? const TextStyle();

    return baseStyle
        .merge(widget.textStyle)
        .copyWith(
          color:
              widget.textStyle?.color ??
              (isDark ? AppColors.darkInputText : AppColors.lightInputText),
          fontSize: widget.textStyle?.fontSize ?? baseStyle.fontSize ?? 16,
          height: 1.0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Enhanced semantics for accessibility
    return Semantics(
      label: widget.semanticsLabel ?? widget.labelText,
      hint: widget.semanticsHint ?? widget.accessibilityHint ?? widget.helperText,
      textField: true,
      enabled: widget.enabled,
      focused: _focusNode.hasFocus,
      child: Container(
        width: widget.width,
        margin: widget.margin,
        /*constraints: BoxConstraints(
          minHeight: widget.height ?? 48,
          maxHeight: widget.height ?? 48,
        ),*/
        child: _buildAnimatedFieldContent(theme, isDark),
      ),
    );
  }

  // It includes the feedback widget
  Widget _buildAnimatedFieldContent(ThemeData theme, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextField with fixed height
        Container(
          constraints: BoxConstraints(
            minHeight: widget.height ?? 48,
            maxHeight: widget.height ?? 48,
          ),
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              );
            },
            child: ValueListenableBuilder<ValidationResult?>(
              valueListenable: _validationResultNotifier,
              builder: (context, validationResult, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: _isFocusedNotifier,
                  builder: (context, isFocused, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _obscureTextNotifier,
                      builder: (context, obscureText, _) {
                        return _buildTextField(
                          theme,
                          isDark,
                          isFocused,
                          obscureText,
                          validationResult,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        // Feedback widget (adds to total height)
        ValueListenableBuilder<ValidationResult?>(
          valueListenable: _validationResultNotifier,
          builder: (context, validationResult, _) {
            return _buildCustomFeedbackWidget(validationResult);
          },
        ),
      ],
    );
  }

  Widget _buildCustomFeedbackWidget(ValidationResult? validationResult) {
    // Determine what content to show with priority logic
    final hasValidationFeedback =
        validationResult != null &&
        (!validationResult.isValid || validationResult.errorMessage != null);
    final hasHelperText = widget.helperText?.isNotEmpty == true;

    // Show nothing if no content to display
    if (!hasValidationFeedback && !hasHelperText) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: widget.animationConfig.errorTransitionDuration,
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(top: 6),
      child: CustomFeedbackWidget(
        validationResult: validationResult,
        helperText: widget.helperText,
        errorStyle: widget.errorStyle,
        warningStyle: widget.warningStyle,
        infoStyle: widget.infoStyle,
        helperStyle: widget.helperStyle,
        padding:
            widget.feedbackPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        showIcons: widget.feedbackShowIcons,
        animationDuration: widget.feedbackAnimationDuration,
        maxLines: widget.helperMaxLines ?? 2,
      ),
    );
  }

  Widget _buildTextField(
    ThemeData theme,
    bool isDark,
    bool isFocused,
    bool obscureText,
    ValidationResult? validationResult,
  ) {
    final decoration = _getDecorationWithValidation(validationResult);
    return widget.items != null
        ? _buildDropdownField(decoration)
        : _buildStandardTextField(theme, isDark, obscureText, decoration);
  }

  /// Builds a standard text field with optimized properties
  Widget _buildStandardTextField(
    ThemeData theme,
    bool isDark,
    bool obscureText,
    InputDecoration decoration,
  ) {
    return TextFormField(
      key: widget.fieldKey,
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: widget.isPassword && obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
      style: _getEffectiveTextStyle(context),
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      decoration: decoration,
      onTap: widget.onTap,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (widget.autoValidateMode && _isDirty) {
          _performValidation();
        }
      },
      onFieldSubmitted: widget.onSubmitted,
      validator: (value) {
        _performValidation();
        return null;
      },
      onSaved: widget.onSaved,
      autovalidateMode: AutovalidateMode.disabled, // We handle validation manually
    );
  }

  /// Builds a dropdown field with optimized selection handling
  Widget _buildDropdownField(InputDecoration decoration) {
    return DropdownButtonFormField<T>(
      key: widget.fieldKey,
      value: widget.dropdownValue,
      focusNode: _focusNode,
      items: widget.items,
      onChanged: widget.enabled
          ? (value) {
              widget.onDropdownChanged?.call(value);
              _performValidation();
            }
          : null,
      decoration: decoration,
      icon: widget.showDropdownIcon
          ? const Icon(Icons.arrow_drop_down)
          : const SizedBox.shrink(),
      isExpanded: true,
      onTap: widget.onTap,
      style: _getEffectiveTextStyle(context),
      validator: (value) {
        _performValidation();
        return null;
      },
      onSaved: widget.onSaved as void Function(T?)?,
    );
  }

  /// Applies validation state to the decoration using cached resources when possible
  InputDecoration _getDecorationWithValidation(ValidationResult? validationResult) {
    final baseDecoration = _buildInputDecoration(context);

    // Return base decoration for valid states
    if (validationResult?.isValid != false) {
      return baseDecoration;
    }

    final theme = Theme.of(context);
    final borderColor = _getValidationBorderColor(validationResult!, theme);

    return baseDecoration.copyWith(
      // Remove errorText as we handle it in custom widget
      errorText: null,
      errorStyle: const TextStyle(height: 0, fontSize: 0),

      // Apply validation border styling
      enabledBorder: OutlineInputBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: widget.borderWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            widget.focusBorderRadius ??
            widget.borderRadius ??
            BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor,
          width: widget.focusBorderWidth ?? (widget.borderWidth * 1.5),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor, width: widget.borderWidth),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius:
            widget.focusBorderRadius ??
            widget.borderRadius ??
            BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor,
          width: widget.focusBorderWidth ?? (widget.borderWidth * 1.5),
        ),
      ),
    );
  }

  // Get appropriate border color based on validation severity
  Color _getValidationBorderColor(ValidationResult result, ThemeData theme) {
    switch (result.severity) {
      case ValidationSeverity.error:
        return theme.colorScheme.error;
      case ValidationSeverity.warning:
        return const Color(0xFFF57C00);
      case ValidationSeverity.info:
        return theme.colorScheme.primary;
    }
  }
}

class LazyValueNotifier<T> extends ValueNotifier<T> {
  LazyValueNotifier(T Function() initialValueProvider)
    : super(initialValueProvider());
}

/// Professional feedback widget with sophisticated validation handling
class CustomFeedbackWidget extends StatefulWidget {
  final ValidationResult? validationResult;
  final String? helperText;
  final TextStyle? errorStyle;
  final TextStyle? warningStyle;
  final TextStyle? infoStyle;
  final TextStyle? helperStyle;
  final EdgeInsetsGeometry? padding;
  final bool showIcons;
  final Duration animationDuration;
  final Curve animationCurve;
  final BoxDecoration? decoration;
  final int maxLines;

  const CustomFeedbackWidget({
    super.key,
    this.validationResult,
    this.helperText,
    this.errorStyle,
    this.warningStyle,
    this.infoStyle,
    this.helperStyle,
    this.padding,
    this.showIcons = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.decoration,
    this.maxLines = 2,
  });

  @override
  State<CustomFeedbackWidget> createState() => _CustomFeedbackWidgetState();
}

class _CustomFeedbackWidgetState extends State<CustomFeedbackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _currentText;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.animationCurve),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.animationCurve,
          ),
        );

    _updateCurrentState();

    if (_currentText != null) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomFeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldText = _getCurrentDisplayText(
      oldWidget.validationResult,
      oldWidget.helperText,
    );
    final newText = _getCurrentDisplayText(
      widget.validationResult,
      widget.helperText,
    );

    // Handle text changes with smooth transitions
    if (oldText != newText) {
      if (newText == null) {
        // Fade out
        _animationController.reverse();
      } else if (oldText == null) {
        // Fade in
        _updateCurrentState();
        _animationController.forward();
      } else {
        // Cross-fade between different messages
        _animationController.reverse().then((_) {
          if (mounted) {
            _updateCurrentState();
            _animationController.forward();
          }
        });
      }
    }
  }

  void _updateCurrentState() {
    _currentText = _getCurrentDisplayText(
      widget.validationResult,
      widget.helperText,
    );
  }

  String? _getCurrentDisplayText(ValidationResult? result, String? helperText) {
    // Priority: Validation message > Helper text
    if (result != null && !result.isValid && result.errorMessage != null) {
      return result.errorMessage;
    }
    return helperText?.isNotEmpty == true ? helperText : null;
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _getCurrentDisplayText(
      widget.validationResult,
      widget.helperText,
    );

    if (displayText == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildFeedbackContent(displayText),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackContent(String text) {
    final theme = Theme.of(context);
    final textStyle = _getEffectiveTextStyle(theme);
    final iconData = _getIconData();
    final iconColor = _getIconColor(theme);

    return Container(
      padding:
          widget.padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: widget.decoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showIcons && iconData != null) ...[
            Icon(iconData, size: 16, color: iconColor),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: textStyle,
              maxLines: widget.maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getEffectiveTextStyle(ThemeData theme) {
    final baseStyle =
        theme.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          height: 1.33,
          fontWeight: FontWeight.w400,
        ) ??
        const TextStyle(fontSize: 12, height: 1.33, fontWeight: FontWeight.w400);

    // Apply custom styles based on validation state or helper text
    if (widget.validationResult != null && !widget.validationResult!.isValid) {
      final customStyle = _getValidationStyle();
      return baseStyle
          .merge(customStyle)
          .copyWith(color: customStyle?.color ?? _getTextColor(theme));
    }

    // Helper text styling
    return baseStyle
        .merge(widget.helperStyle)
        .copyWith(color: widget.helperStyle?.color ?? _getHelperTextColor(theme));
  }

  TextStyle? _getValidationStyle() {
    if (widget.validationResult?.severity == ValidationSeverity.error) {
      return widget.errorStyle;
    } else if (widget.validationResult?.severity == ValidationSeverity.warning) {
      return widget.warningStyle;
    } else if (widget.validationResult?.severity == ValidationSeverity.info) {
      return widget.infoStyle;
    }
    return null;
  }

  Color _getTextColor(ThemeData theme) {
    switch (widget.validationResult?.severity) {
      case ValidationSeverity.error:
        return theme.colorScheme.error;
      case ValidationSeverity.warning:
        return const Color(0xFFF57C00);
      case ValidationSeverity.info:
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.error;
    }
  }

  Color _getHelperTextColor(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);
  }

  Color _getIconColor(ThemeData theme) {
    if (widget.validationResult != null && !widget.validationResult!.isValid) {
      return _getTextColor(theme);
    }
    return _getHelperTextColor(theme);
  }

  IconData? _getIconData() {
    switch (widget.validationResult?.severity) {
      case ValidationSeverity.error:
        return Icons.error_outline_rounded;
      case ValidationSeverity.warning:
        return Icons.warning_amber_outlined;
      case ValidationSeverity.info:
        return Icons.info_outline_rounded;
      default:
        return widget.validationResult != null ? null : Icons.help_outline;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
