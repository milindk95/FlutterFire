import 'package:flutter/material.dart';
import 'package:flutter_fire/ui/resources/resources.dart';

class AppNetworkImage extends StatelessWidget {
  final String url, errorIcon;
  final double? height, width;

  const AppNetworkImage({
    Key? key,
    required this.url,
    this.height,
    this.width,
    required this.errorIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage(imgPlaceHolder),
      imageErrorBuilder: (context, _, __) {
        return Image.asset(
          errorIcon,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      },
      image: NetworkImage(url),
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 500),
      width: width,
      height: height,
    );
  }
}

class RoundedShadowImage extends StatelessWidget {
  final String url, errorIcon;
  final double? size;

  const RoundedShadowImage({
    Key? key,
    required this.url,
    required this.errorIcon,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.onSecondary,
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.16),
            offset: Offset(0, 2),
            blurRadius: 2.4,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipOval(
        child: AppNetworkImage(
          url: url,
          errorIcon: errorIcon,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
