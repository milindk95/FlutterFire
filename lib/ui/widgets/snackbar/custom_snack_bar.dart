part of 'top_snack_bar.dart';

/// Popup widget that you can use by default to show some information
class CustomSnackBar extends StatefulWidget {
  final String message;
  final Widget icon;
  final Color backgroundColor;
  final TextStyle textStyle;

  const CustomSnackBar.success({
    Key? key,
    required this.message,
    this.icon = const Icon(
      Icons.check,
      color: const Color(0x40000000),
      size: 40,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.backgroundColor = const Color(0xff00E676),
  });

  const CustomSnackBar.info({
    Key? key,
    required this.message,
    this.icon = const Icon(
      Icons.info_outline,
      color: Colors.white,
      size: 40,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.backgroundColor = const Color(0xff2196F3),
  });

  const CustomSnackBar.error({
    Key? key,
    required this.message,
    this.icon = const Icon(
      Icons.error_outline,
      color: Colors.white,
      size: 40,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.backgroundColor = const Color(0xffff5252),
  });

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 8.0),
            spreadRadius: 1,
            blurRadius: 30,
          ),
        ],
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          widget.icon,
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              widget.message,
              style: theme.textTheme.bodyText2?.merge(
                widget.textStyle,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
