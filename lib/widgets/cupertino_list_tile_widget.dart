import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoListTileWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Color? color;
  final Widget? child;
  final VoidCallback onPressed;

  const CupertinoListTileWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconColor,
    this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.65,
      color: color ?? Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        height: 28,
                        width: 28,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: iconColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Text(
                text,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          child ?? const SizedBox()
        ],
      ),
    );
  }
}
