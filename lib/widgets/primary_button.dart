import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: 56,
        decoration: BoxDecoration(
          gradient: widget.isSecondary
              ? null
              : const LinearGradient(
                  colors: AppColors.orangeGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: widget.isSecondary ? Colors.transparent : null,
          border: widget.isSecondary
              ? Border.all(color: AppColors.darkBrown, width: 2)
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isPressed || widget.isSecondary
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: widget.isSecondary
                            ? AppColors.darkBrown
                            : Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: widget.isSecondary
                                ? AppColors.darkBrown
                                : Colors.white,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
