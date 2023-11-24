import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/utils/app_size.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.5,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Center(
          child: isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.blue, size: 30)
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
