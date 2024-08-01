import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.textColor,
    required this.borderColor,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final Color? textColor;
  final Color borderColor;
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: TextButton(
        onPressed: onPressed, // Utiliser onPressed
        style: TextButton.styleFrom(
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: textColor,
                  ),
            ),
            (icon != null)
                ? Row(
                    children: [
                      const SizedBox(width: 15),
                      Icon(
                        icon,
                        color: textColor,
                        size: 30,
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
