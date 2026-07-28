import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.contentPadding,
    this.fillColor,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialValue;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _hasError ? AppColors.error : AppColors.outlineVariant,
        width: 1.5,
      ),
    );

    final enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _hasError ? AppColors.error : AppColors.outlineVariant,
        width: 1.5,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: _hasError ? AppColors.error : AppColors.primary,
        width: 2,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 1.5,
      ),
    );

    final defaultPadding = contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: RichText(
              text: TextSpan(
                text: label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
                children: required
                    ? [
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onTap: onTap,
          focusNode: focusNode,
          autofocus: autofocus,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: enabled ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: fillColor ??
                (enabled
                    ? AppColors.surfaceContainerLowest
                    : AppColors.surfaceContainer),
            contentPadding: defaultPadding,
            hintStyle: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            helperStyle: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.error,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      prefixIcon,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  )
                : null,
            prefixIconConstraints: prefixIcon != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        suffixIcon,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: suffixIcon != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            border: border,
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            disabledBorder: border.copyWith(
              borderSide: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
