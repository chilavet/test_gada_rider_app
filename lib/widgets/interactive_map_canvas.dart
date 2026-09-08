import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class InteractiveMapCanvas extends StatefulWidget {
  final double progress; // 0.0 to 1.0 along the route
  final String pickupLabel;
  final String dropoffLabel;

  const InteractiveMapCanvas({
    super.key,
    this.progress = 0.45,
    this.pickupLabel = 'Wuse Market',
    this.dropoffLabel = 'Aminu Kano Cres',
  });

  @override
  State<InteractiveMapCanvas> createState() => _InteractiveMapCanvasState();
}

class _InteractiveMapCanvasState extends State<InteractiveMapCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _MapCanvasPainter(
            progress: widget.progress,
            pulse: _pulseController.value,
            pickupLabel: widget.pickupLabel,
            dropoffLabel: widget.dropoffLabel,
          ),
        );
      },
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  final double progress;
  final double pulse;
  final String pickupLabel;
  final String dropoffLabel;

  _MapCanvasPainter({
    required this.progress,
    required this.pulse,
    required this.pickupLabel,
    required this.dropoffLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dark Base
    final bgPaint = Paint()..color = const Color(0xFF141416);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. City Grid & Street network
    final roadMinorPaint = Paint()
      ..color = const Color(0xFF222228)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final roadMajorPaint = Paint()
      ..color = const Color(0xFF2E2E36)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    // Grid lines representing blocks
    for (double x = 30; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadMinorPaint);
    }
    for (double y = 40; y < size.height; y += 70) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadMinorPaint);
    }

    // Diagonal avenues
    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.2),
      roadMajorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.85, size.height),
      roadMajorPaint,
    );

    // 3. Curved Delivery Route Polyline
    final startPoint = Offset(size.width * 0.22, size.height * 0.72);
    final controlPoint1 = Offset(size.width * 0.35, size.height * 0.45);
    final controlPoint2 = Offset(size.width * 0.65, size.height * 0.55);
    final endPoint = Offset(size.width * 0.82, size.height * 0.25);

    final routePath = Path();
    routePath.moveTo(startPoint.dx, startPoint.dy);
    routePath.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Route Outer Glow
    final routeGlowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.25)
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, routeGlowPaint);

    // Route Inner Line
    final routeLinePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, routeLinePaint);

    // 4. Pickup Marker (Green)
    final pickupPaint = Paint()..color = AppColors.onlineGreen;
    canvas.drawCircle(startPoint, 8, pickupPaint);
    final pickupBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(startPoint, 8, pickupBorderPaint);

    // 5. Destination Pin (Orange)
    final dropoffPaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(endPoint, 9, dropoffPaint);
    final dropoffBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(endPoint, 9, dropoffBorderPaint);

    // 6. Current Rider Position along route
    // Approximate position using cubic interpolation
    final t = progress.clamp(0.05, 0.95);
    final u = 1 - t;
    final riderX = u * u * u * startPoint.dx +
        3 * u * u * t * controlPoint1.dx +
        3 * u * t * t * controlPoint2.dx +
        t * t * t * endPoint.dx;
    final riderY = u * u * u * startPoint.dy +
        3 * u * u * t * controlPoint1.dy +
        3 * u * t * t * controlPoint2.dy +
        t * t * t * endPoint.dy;
    final riderPos = Offset(riderX, riderY);

    // Pulsing aura around rider
    final riderAuraPaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.2 + (0.2 * pulse))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(riderPos, 16 + (6 * pulse), riderAuraPaint);

    // Rider Dot
    final riderCenterPaint = Paint()..color = Colors.white;
    canvas.drawCircle(riderPos, 7, riderCenterPaint);
    final riderRimPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(riderPos, 7, riderRimPaint);
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.pulse != pulse;
  }
}
