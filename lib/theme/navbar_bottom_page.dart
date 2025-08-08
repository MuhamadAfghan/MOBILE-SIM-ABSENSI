import 'package:flutter/material.dart';

// Ganti nama class dan constructor agar konsisten
class NavbarBottomPage extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavbarBottomPage({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NavbarBottomPage> createState() => _NavbarBottomPageState();
}

class _NavbarBottomPageState extends State<NavbarBottomPage> {
  final List<IconData> icons = [
    Icons.home,
    Icons.article,
    Icons.access_time,
    Icons.person,
  ];

  final List<String> labels = [
    "Home",
    "Absensi",
    "Riwayat",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // agar proporsional dengan icon yang lebih naik
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: NavBarPainter(widget.currentIndex),
              child: Container(height: 60),
            ),
          ),
          Positioned.fill(
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                final isSelected = index == widget.currentIndex;
                return GestureDetector(
                  onTap: () => widget.onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        width: isSelected ? 54 : 36,
                        height: isSelected ? 54 : 36,
                        margin: EdgeInsets.only(
                          bottom: isSelected ? 32 : 0, // 👈️ lebih tinggi
                        ),
                        decoration: isSelected
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              )
                            : null,
                        child: Icon(
                          icons[index],
                          color: isSelected ? Colors.blue : Colors.black,
                          size: isSelected ? 28 : 20,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (isSelected)
                        Text(
                          labels[index],
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        )
                      else
                        SizedBox(height: 16),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  final int selectedIndex;

  NavBarPainter(this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.fill;

    final double circleRadius = 30; // lebih besar dan natural
    final double circleSpacing = size.width / 4;
    final double centerX = circleSpacing * selectedIndex + circleSpacing / 2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - circleRadius - 10, 0)
      ..cubicTo(
        centerX - circleRadius, 0,
        centerX - circleRadius, 0,
        centerX - circleRadius + 6, 20) // 👈️ lebih dalam
      ..arcToPoint(
        Offset(centerX + circleRadius - 6, 20), // 👈️ lebih dalam
        radius: Radius.circular(circleRadius + 10), // 👈️ lebih bulat
        clockwise: false,
      )
      ..cubicTo(
        centerX + circleRadius, 0,
        centerX + circleRadius, 0,
        centerX + circleRadius + 10, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(NavBarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}
