import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    Offset firstControlPoint = Offset(size.width / 4, size.height);
    Offset firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    Offset secondControlPoint = Offset(3 * size.width / 4, size.height - 60);
    Offset secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HeaderComponent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const HeaderComponent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F67E8);
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        constraints: const BoxConstraints(minHeight: 220),
        color: primaryColor,
        padding:
            const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              imagePath,
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
