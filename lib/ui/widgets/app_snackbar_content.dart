import 'package:flutter/material.dart';

class AppSnackBarContent extends StatelessWidget {
  final String label;
  final IconData icon;

  const AppSnackBarContent({
    super.key,
    required this.label,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.white
                ),
              )
          )
        ]
    );
  }
}