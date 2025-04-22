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

  // Error styling
  final TextStyle? errorStyle;
  final TextStyle? warningStyle;
  final TextStyle? infoStyle;

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
    this.warningStyle,
    this.infoStyle,
    // Enhanced accessibility
    this.accessibilityHint,
    this.announceValidationStatus = true,
  });

  @override
  State<CustomTextField<T>> createState() => _CustomTextFieldState<T>();

  /// Creates a builder for more fluent API configuration
  static CustomTextFieldBuilder<T> builder<T>() => CustomTextFieldBuilder<T>();
}

/// Builder pattern for CustomTextField to allow for more fluent API
class CustomTextFieldBuilder<T> {
  String? _labelText;
  String? _hintText;
  String? _initialValue;
  bool _isPassword = false;
  bool _isRequired = false;
  final bool _enabled = true;
  final bool _readOnly = false;
  VoidCallback? _onTap;
  Widget? _suffixIcon;
  Widget? _prefixIcon;
  VoidCallback? _onPrefixIconTap;
  VoidCallback? _onSuffixIconTap;
  double? _width;
  double? _height;
  final int _maxLines = 1;
  int? _maxLength;
  TextEditingController? _controller;
  List<TextInputFormatter>? _inputFormatters;
  TextInputType? _keyboardType;
  Function(String)? _onChanged;
  Function(String)? _onSubmitted;
  String? Function(String?)? _validator;
  Function(String?)? _onSaved;
  InputDecoration? _decoration;
  TextStyle? _textStyle;
  TextStyle? _labelStyle;
  TextStyle? _hintStyle;
  BorderRadius? _borderRadius;
  Color? _fillColor;
  Color? _focusColor;
  Color? _borderColor;
  final double _borderWidth = 1.0;
  double? _focusBorderWidth;
  BorderRadius? _focusBorderRadius;
  EdgeInsetsGeometry? _contentPadding;
  EdgeInsetsGeometry? _margin;
  String? _helperText;
  int? _helperMaxLines;
  List<DropdownMenuItem<T>>? _items;
  T? _dropdownValue;
  Function(T?)? _onDropdownChanged;
  bool _showDropdownIcon = true;
  final TextFieldAnimationConfig _animationConfig =
      TextFieldAnimationConfig.defaultConfig;
  String? _semanticsLabel;
  String? _semanticsHint;
  ValueChanged<ValidationResult>? _onValidationChanged;
  final bool _autofocus = false;
  final bool _autoValidateMode = false;
  GlobalKey<FormFieldState>? _fieldKey;
  final TextCapitalization _textCapitalization = TextCapitalization.none;
  final TextAlign _textAlign = TextAlign.start;
  TextAlignVertical? _textAlignVertical;
  PasswordVisibilityConfig _passwordVisibilityConfig =
      PasswordVisibilityConfig.defaultConfig;
  TextStyle? _errorStyle;
  TextStyle? _warningStyle;
  TextStyle? _infoStyle;
  String? _accessibilityHint;
  bool _announceValidationStatus = true;

  /// Sets the label text
  CustomTextFieldBuilder<T> withLabel(String label) {
    _labelText = label;
    return this;
  }

  /// Sets the hint text
  CustomTextFieldBuilder<T> withHint(String hint) {
    _hintText = hint;
    return this;
  }

  /// Configures this field as a password field
  CustomTextFieldBuilder<T> asPassword({PasswordVisibilityConfig? config}) {
    _isPassword = true;
    if (config != null) {
      _passwordVisibilityConfig = config;
    }
    return this;
  }

  /// Makes the field required
  CustomTextFieldBuilder<T> required() {
    _isRequired = true;
    return this;
  }

  /// Sets the controller
  CustomTextFieldBuilder<T> withController(TextEditingController controller) {
    _controller = controller;
    return this;
  }

  /// Sets the validator function
  CustomTextFieldBuilder<T> withValidator(String? Function(String?) validator) {
    _validator = validator;
    return this;
  }

  /// Configures as a dropdown with items
  CustomTextFieldBuilder<T> asDropdown({
    required List<DropdownMenuItem<T>> items,
    T? value,
    required Function(T?) onChanged,
    bool showIcon = true,
  }) {
    _items = items;
    _dropdownValue = value;
    _onDropdownChanged = onChanged;
    _showDropdownIcon = showIcon;
    return this;
  }

  /// Sets input formatting options
  CustomTextFieldBuilder<T> withInputFormatters(
    List<TextInputFormatter> formatters,
  ) {
    _inputFormatters = formatters;
    return this;
  }

  /// Sets validation change callback
  CustomTextFieldBuilder<T> withValidationCallback(
    ValueChanged<ValidationResult> callback,
  ) {
    _onValidationChanged = callback;
    return this;
  }

  /// Sets the keyboard type
  CustomTextFieldBuilder<T> withKeyboardType(TextInputType type) {
    _keyboardType = type;
    return this;
  }

  /// Configure accessibility options
  CustomTextFieldBuilder<T> withAccessibility({
    String? hint,
    String? label,
    bool announceValidation = true,
  }) {
    _accessibilityHint = hint;
    _semanticsLabel = label;
    _announceValidationStatus = announceValidation;
    return this;
  }

  /// Configures custom styling
  CustomTextFieldBuilder<T> withStyling({
    Color? fill,
    Color? border,
    Color? focus,
    BorderRadius? radius,
    TextStyle? text,
    TextStyle? label,
    TextStyle? hint,
    TextStyle? error,
    TextStyle? warning,
    TextStyle? info,
  }) {
    _fillColor = fill;
    _borderColor = border;
    _focusColor = focus;
    _borderRadius = radius;
    _textStyle = text;
    _labelStyle = label;
    _hintStyle = hint;
    _errorStyle = error;
    _warningStyle = warning;
    _infoStyle = info;
    return this;
  }

  /// Builds the final CustomTextField
  CustomTextField<T> build() {
    return CustomTextField<T>(
      labelText: _labelText,
      hintText: _hintText,
      initialValue: _initialValue,
      isPassword: _isPassword,
      isRequired: _isRequired,
      enabled: _enabled,
      readOnly: _readOnly,
      onTap: _onTap,
      suffixIcon: _suffixIcon,
      prefixIcon: _prefixIcon,
      onPrefixIconTap: _onPrefixIconTap,
      onSuffixIconTap: _onSuffixIconTap,
      width: _width,
      height: _height,
      maxLines: _maxLines,
      maxLength: _maxLength,
      controller: _controller,
      inputFormatters: _inputFormatters,
      keyboardType: _keyboardType,
      onChanged: _onChanged,
      onSubmitted: _onSubmitted,
      validator: _validator,
      onSaved: _onSaved,
      decoration: _decoration,
      textStyle: _textStyle,
      labelStyle: _labelStyle,
      hintStyle: _hintStyle,
      borderRadius: _borderRadius,
      fillColor: _fillColor,
      focusColor: _focusColor,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
      focusBorderWidth: _focusBorderWidth,
      focusBorderRadius: _focusBorderRadius,
      contentPadding: _contentPadding,
      margin: _margin,
      helperText: _helperText,
      helperMaxLines: _helperMaxLines,
      items: _items,
      dropdownValue: _dropdownValue,
      onDropdownChanged: _onDropdownChanged,
      showDropdownIcon: _showDropdownIcon,
      animationConfig: _animationConfig,
      semanticsLabel: _semanticsLabel,
      semanticsHint: _semanticsHint,
      onValidationChanged: _onValidationChanged,
      autofocus: _autofocus,
      autoValidateMode: _autoValidateMode,
      fieldKey: _fieldKey,
      textCapitalization: _textCapitalization,
      textAlign: _textAlign,
      textAlignVertical: _textAlignVertical,
      passwordVisibilityConfig: _passwordVisibilityConfig,
      errorStyle: _errorStyle,
      warningStyle: _warningStyle,
      infoStyle: _infoStyle,
      accessibilityHint: _accessibilityHint,
      announceValidationStatus: _announceValidationStatus,
    );
  }
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

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);

    // Use lazy initializers to avoid unnecessary object creation
    _obscureTextNotifier = LazyValueNotifier(() => widget.isPassword);
    _isFocusedNotifier = LazyValueNotifier(() => false);
    _validationResultNotifier = LazyValueNotifier(() => null);

    _focusNode.addListener(_onFocusChange);

    // Initialize validation animation controller
    _validationAnimationController = AnimationController(
      duration: widget.animationConfig.errorTransitionDuration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_validationAnimationController);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(CustomTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller updates
    if (widget.controller != oldWidget.controller && widget.controller != null) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller!;
    }

    // Reset cached decoration if relevant properties changed
    if (_shouldRecalculateDecoration(oldWidget)) {
      _cachedDecoration = null;
    }
  }

  /// Determines if we need to recalculate the decoration
  bool _shouldRecalculateDecoration(CustomTextField<T> oldWidget) {
    return widget.decoration != oldWidget.decoration ||
        widget.labelText != oldWidget.labelText ||
        widget.hintText != oldWidget.hintText ||
        widget.borderRadius != oldWidget.borderRadius ||
        widget.fillColor != oldWidget.fillColor ||
        widget.focusColor != oldWidget.focusColor ||
        widget.borderColor != oldWidget.borderColor ||
        widget.passwordVisibilityConfig != oldWidget.passwordVisibilityConfig;
  }

  void _onFocusChange() {
    _isFocusedNotifier.value = _focusNode.hasFocus;
    if (_focusNode.hasFocus && !_isDirty) {
      _isDirty = true;
    }
  }

  /// Validates the field and notifies listeners with optimized logic
  void _validate() {
    // Optimize validation for empty required fields
    if (!widget.isRequired && (_controller.text.isEmpty)) {
      _setValidationResult(ValidationResult.valid());
      return;
    }

    if (widget.isRequired && _controller.text.isEmpty) {
      _setValidationResult(ValidationResult.error('This field is required'));
      return;
    }

    // Run custom validator if provided
    if (widget.validator != null) {
      final validationMessage = widget.validator!(_controller.text);
      final result =
          validationMessage != null
              ? ValidationResult.error(validationMessage)
              : ValidationResult.valid();
      _setValidationResult(result);
    } else {
      _setValidationResult(ValidationResult.valid());
    }
  }

  /// Sets validation result and handles animations
  void _setValidationResult(ValidationResult result) {
    final previousResult = _validationResultNotifier.value;
    _validationResultNotifier.value = result;

    // Notify listeners of validation change
    widget.onValidationChanged?.call(result);

    // Play animation if transitioning to error state
    if (!result.isValid && (previousResult?.isValid ?? true)) {
      _validationAnimationController.forward().then((_) {
        _validationAnimationController.reset();
      });

      // Announce validation status for accessibility if enabled
      if (widget.announceValidationStatus) {
        SemanticsService.announce(
          result.errorMessage ?? 'Validation error',
          TextDirection.ltr,
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up resources
    if (widget.controller == null) {
      _controller.dispose();
    }

    _obscureTextNotifier.dispose();
    _isFocusedNotifier.dispose();
    _validationResultNotifier.dispose();
    _focusNode.dispose();
    _validationAnimationController.dispose();

    super.dispose();
  }

  /// Builds decoration with memoization for performance
  InputDecoration _buildDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Return cached decoration if theme hasn't changed
    if (_cachedDecoration != null && _lastTheme == theme) {
      return _cachedDecoration!;
    }

    _lastTheme = theme;

    _cachedDecoration =
        widget.decoration ??
        InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          labelStyle:
              widget.labelStyle != null
                  ? theme.textTheme.titleMedium?.merge(widget.labelStyle)
                  : theme.textTheme.titleMedium?.copyWith(
                    color:
                        isDark ? AppColors.darkInputText : AppColors.lightInputText,
                  ),
          hintStyle:
              widget.hintStyle != null
                  ? theme.textTheme.titleMedium?.merge(widget.hintStyle)
                  : theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.grey5 : AppColors.white5,
                  ),
          helperMaxLines: widget.helperMaxLines,
          filled: true,
          fillColor:
              widget.fillColor ??
              (isDark ? AppColors.darkOutlinedBg : AppColors.lightOutlinedBg),
          contentPadding:
              widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 14,
                vertical: (widget.height != null) ? (widget.height! - 16) / 2 : 14,
              ),
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  widget.borderColor ??
                  (isDark
                      ? AppColors.darkEnabledBorder
                      : AppColors.lightEnabledBorder),
              width: widget.borderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  widget.borderColor ??
                  (isDark
                      ? AppColors.darkEnabledBorder
                      : AppColors.lightEnabledBorder),
              width: widget.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                widget.focusBorderRadius ??
                widget.borderRadius ??
                BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  widget.focusColor ??
                  (isDark
                      ? AppColors.darkFocusedBorder
                      : AppColors.lightFocusedBorder),
              width: widget.focusBorderWidth ?? 2,
            ),
          ),
          prefixIcon:
              widget.prefixIcon != null
                  ? GestureDetector(
                    onTap: widget.onPrefixIconTap,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: widget.prefixIcon,
                    ),
                  )
                  : null,
          suffixIcon: _buildSuffixIcon(isDark, theme),
          errorStyle: widget.errorStyle ?? const TextStyle(height: 0.5),
        );

    return _cachedDecoration!;
  }

  /// Build suffix icon with optimized conditional logic
  Widget? _buildSuffixIcon(bool isDark, ThemeData theme) {
    if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixIconTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16),
          child: widget.suffixIcon,
        ),
      );
    } else if (widget.isPassword) {
      return ValueListenableBuilder<bool>(
        valueListenable: _obscureTextNotifier,
        builder: (context, obscureText, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: _isFocusedNotifier,
            builder: (context, isFocused, _) {
              return _buildPasswordVisibilityToggle(obscureText, isFocused, theme);
            },
          );
        },
      );
    }

    return null;
  }

  /// Builds an optimized password visibility toggle with improved accessibility
  Widget _buildPasswordVisibilityToggle(
    bool obscureText,
    bool isFocused,
    ThemeData theme,
  ) {
    return Semantics(
      button: true,
      label:
          obscureText
              ? widget.passwordVisibilityConfig.visibilityOnTooltip
              : widget.passwordVisibilityConfig.visibilityOffTooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          // Toggle password visibility with haptic feedback
          HapticFeedback.lightImpact();
          _obscureTextNotifier.value = !_obscureTextNotifier.value;
        },
        child: Padding(
          padding: widget.passwordVisibilityConfig.iconPadding,
          child: _buildVisibilityIcon(obscureText, isFocused, theme),
        ),
      ),
    );
  }

  Widget _buildVisibilityIcon(bool isVisible, bool isFocused, ThemeData theme) {
    // Use custom widgets if provided (highest priority)
    if (isVisible &&
        widget.passwordVisibilityConfig.customVisibilityOnIcon != null) {
      return IconTheme(
        data: IconThemeData(
          color:
              widget.passwordVisibilityConfig.iconColor ??
              (isFocused ? widget.focusColor : null),
          size: widget.passwordVisibilityConfig.iconSize,
        ),
        child: widget.passwordVisibilityConfig.customVisibilityOnIcon!,
      );
    }
    if (!isVisible &&
        widget.passwordVisibilityConfig.customVisibilityOffIcon != null) {
      return IconTheme(
        data: IconThemeData(
          color:
              widget.passwordVisibilityConfig.iconColor ??
              (isFocused ? widget.focusColor : null),
          size: widget.passwordVisibilityConfig.iconSize,
        ),
        child: widget.passwordVisibilityConfig.customVisibilityOffIcon!,
      );
    }

    // Otherwise use asset images with fallback
    return AssetResolver.resolveVisibilityIcon(
      isVisible: isVisible,
      userAssetPath:
          isVisible
              ? widget.passwordVisibilityConfig.customVisibilityOnIconPath
              : widget.passwordVisibilityConfig.customVisibilityOffIconPath,
      color:
          widget.passwordVisibilityConfig.iconColor ??
          (isFocused ? widget.focusColor : null),
      size: widget.passwordVisibilityConfig.iconSize,
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
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.height ?? 48),
          child: _buildAnimatedFieldContent(theme, isDark),
        ),
      ),
    );
  }

  /// Builds field content with animation support
  Widget _buildAnimatedFieldContent(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
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
    );
  }

  /// Builds the text field with optimization for field type
  Widget _buildTextField(
    ThemeData theme,
    bool isDark,
    bool isFocused,
    bool obscureText,
    ValidationResult? validationResult,
  ) {
    final decoration = _getDecorationWithValidation(validationResult);

    // Use dedicated builders for specific field types
    if (widget.items != null) {
      return _buildDropdownField(decoration);
    } else {
      return _buildStandardTextField(theme, isDark, obscureText, decoration);
    }
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
      textAlignVertical: widget.textAlignVertical,
      style:
          widget.textStyle ??
          theme.textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.darkInputText : AppColors.lightInputText,
          ),
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      decoration: decoration,
      onTap: widget.onTap,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (widget.autoValidateMode && _isDirty) {
          _validate();
        }
      },
      onFieldSubmitted: widget.onSubmitted,
      validator: (value) {
        // Use our custom validation logic
        _validate();
        // Return null to satisfy the FormField validator
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
      onChanged:
          widget.enabled
              ? (value) {
                widget.onDropdownChanged?.call(value);
                _validate();
              }
              : null,
      decoration: decoration,
      icon:
          widget.showDropdownIcon
              ? const Icon(Icons.arrow_drop_down)
              : const SizedBox.shrink(),
      isExpanded: true,
      onTap: widget.onTap,
      validator: (value) {
        // Use our custom validation logic
        _validate();
        // Return null to satisfy the FormField validator
        return null;
      },
      onSaved: widget.onSaved as void Function(T?)?,
    );
  }

  /// Applies validation state to the decoration using cached resources when possible
  InputDecoration _getDecorationWithValidation(ValidationResult? validationResult) {
    final baseDecoration = _buildDecoration(context);

    if (validationResult == null ||
        validationResult.isValid && validationResult.errorMessage == null) {
      return baseDecoration;
    }

    // Apply appropriate styling based on validation severity
    final TextStyle? feedbackStyle =
        validationResult.isSeverity(ValidationSeverity.error)
            ? widget.errorStyle
            : validationResult.isSeverity(ValidationSeverity.warning)
            ? widget.warningStyle
            : widget.infoStyle;

    // Apply appropriate colors based on validation severity
    final Color feedbackColor =
        validationResult.isSeverity(ValidationSeverity.error)
            ? AppColors.error
            : validationResult.isSeverity(ValidationSeverity.warning)
            ? AppColors.warning
            : AppColors.info;

    return baseDecoration.copyWith(
      errorText: validationResult.errorMessage,
      errorStyle: feedbackStyle,
      errorBorder: OutlineInputBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        borderSide: BorderSide(color: feedbackColor, width: widget.borderWidth),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius:
            widget.focusBorderRadius ??
            widget.borderRadius ??
            BorderRadius.circular(8),
        borderSide: BorderSide(
          color: feedbackColor,
          width: widget.focusBorderWidth ?? widget.borderWidth * 1.5,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset cached resources when theme or dependencies change
    _cachedDecoration = null;
  }
}

/// Lazy-initialized value notifier to minimize unnecessary object creation
class LazyValueNotifier<T> extends ValueNotifier<T> {
  LazyValueNotifier(T Function() initialValueProvider)
    : super(initialValueProvider());
}
