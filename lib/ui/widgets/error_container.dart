import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final IconData icon;
  final String label;

  const ErrorContainer({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Wrap(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Theme.of(context).hintColor,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ]
                ),
              ]
          ),
        )
    );
  }

}