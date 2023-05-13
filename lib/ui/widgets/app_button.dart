import 'package:flutter/material.dart';

import '../colors.dart';
import '../shapes.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Color? hoverColor;
  final Color? splashColor;
  final TextStyle? textStyle;

  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.hoverColor,
    this.splashColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.transparent,
      hoverColor: hoverColor,
      highlightColor: Colors.transparent,
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      shape: AppShapes.circleShape,
      splashColor: splashColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const AppIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: AppShapes.circleShape,
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: Theme.of(context).hintColor),
            )));
  }
}

class AppButton extends StatefulWidget {
  final String text;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool isLoading;
  final bool isEnabled;
  final TextStyle textStyle;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(AppColors.primaryColor),
    this.foregroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
    this.margin = const EdgeInsets.all(0.0),
    this.isLoading = false,
    this.isEnabled = true,
    this.textStyle = const TextStyle(fontSize: 15),
    this.height = 50,
  });

  @override
  State<StatefulWidget> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: widget.margin,
        child: ElevatedButton(
            onPressed: (!widget.isLoading) ? widget.onPressed : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.backgroundColor,
                elevation: 0,
                foregroundColor: widget.foregroundColor,
                disabledBackgroundColor: Theme.of(context).disabledColor,
                padding: widget.padding,
                shape: AppShapes.roundedRectangleShape,
                minimumSize: Size.fromHeight(widget.height)),
            child: (widget.isLoading)
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: Colors.white,
                    ))
                : Text(
                    widget.text,
                    style: widget.textStyle,
                    textAlign: TextAlign.center,
                  )));
  }
}
