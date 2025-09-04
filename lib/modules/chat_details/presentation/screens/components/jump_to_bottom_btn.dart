import 'package:flutter/material.dart';

Widget jumpToBottomBtn({
  required Function scrollToBottom,
  required BuildContext context,
}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Material(
      elevation: 2.5,
      borderRadius: BorderRadius.circular(24),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: InkWell(
        onTap: () {
          scrollToBottom();
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_downward,
                color: Theme.of(context).colorScheme.onSurface,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                "Jump to the Bottom",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
