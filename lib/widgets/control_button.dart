import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({
    super.key,
    required this.title,
    required this.onClick,
  });

  final String title;
  final void Function() onClick;

  static final buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onClick,
        child: Text(title),
      ),
    );
  }
}
