import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final String buttonText;
  final VoidCallback? onTap;

  const MyButton({
    super.key,
    this.color,
    this.textColor,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: color ?? Colors.grey[300],
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}