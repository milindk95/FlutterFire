part of 'create_team_screen.dart';

class BottomRoundedClipper extends CustomClipper<Path> {
  final double _gap = 46;

  @override
  Path getClip(Size size) {
    @override
    Path path = Path();
    path.lineTo(0, size.height - _gap);
    var startPoint = Offset(size.width / 2, size.height + _gap);
    var endPoint = Offset(size.width, size.height - _gap);
    path.quadraticBezierTo(
        startPoint.dx, startPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
