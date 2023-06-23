import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/res/colors.dart';

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic>? image;
  final Color? borderColor;
  final double radius;
  final double borderWidth;
  final Function? onButtonPressed;
  final bool showButton;

  const Avatar(
      {Key? key,
      required this.image,
      this.borderColor,
      this.radius = 30,
      this.onButtonPressed,
      this.showButton = false,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CircleAvatar(
          radius: radius,
          backgroundColor:
              borderColor ?? AppColors.primaryColorLight,
          child: CircleAvatar(
            radius: radius - borderWidth,
            backgroundImage: image as ImageProvider<Object>?,
          ),
        ),
        if(showButton)
        Positioned(
          bottom: 0,
          right: -30,
          child: MaterialButton(
            elevation: 1,
            color: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.camera_alt),
            padding: const EdgeInsets.all(4.0),
            onPressed: onButtonPressed as void Function()?,
          ),
        )
      ],
    );
  }
}
