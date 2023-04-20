import 'package:flutter/material.dart';

class URLFormButton extends StatelessWidget {
  final Color? color;
  final void Function()? onTap;
  final Widget? icon;

  const URLFormButton({
    super.key,
    this.color,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          color: color,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
