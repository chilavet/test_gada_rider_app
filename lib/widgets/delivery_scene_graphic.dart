import 'package:flutter/material.dart';

/// Vector delivery scene graphic matching the Figma design (node 1009:16794).
/// Depicts a Gada delivery rider handing an order parcel to a customer at the doorstep.
class DeliverySceneGraphic extends StatelessWidget {
  final double width;
  final double height;

  const DeliverySceneGraphic({
    super.key,
    this.width = 320,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DeliveryScenePainter(),
        size: Size(width, height),
      ),
    );
  }
}

class _DeliveryScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Soft Background Arch / Circle
    final bgPaint = Paint()
      ..color = const Color(0xFFE0E7FF).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.48, h * 0.58), w * 0.46, bgPaint);

    // 2. Background foliage / green leaves (left & right)
    final leafPaint = Paint()
      ..color = const Color(0xFF0F766E).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    final leafPath = Path();
    // Left big leaf
    leafPath.moveTo(w * 0.05, h * 0.75);
    leafPath.quadraticBezierTo(w * -0.02, h * 0.65, w * 0.12, h * 0.58);
    leafPath.quadraticBezierTo(w * 0.18, h * 0.70, w * 0.05, h * 0.75);
    // Right leaf
    leafPath.moveTo(w * 0.78, h * 0.55);
    leafPath.quadraticBezierTo(w * 0.95, h * 0.48, w * 0.92, h * 0.65);
    leafPath.quadraticBezierTo(w * 0.82, h * 0.68, w * 0.78, h * 0.55);
    canvas.drawPath(leafPath, leafPaint);

    // 3. Open Doorway Frame (Yellow / Gold)
    final doorFramePaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;
    final doorRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.38, w * 0.36, h * 0.52),
      const Radius.circular(10),
    );
    canvas.drawRRect(doorRRect, doorFramePaint);

    // Doorway opening (Dark navy interior)
    final doorInteriorPaint = Paint()
      ..color = const Color(0xFF1E1B4B)
      ..style = PaintingStyle.fill;
    final doorInnerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.19, h * 0.41, w * 0.28, h * 0.49),
      const Radius.circular(6),
    );
    canvas.drawRRect(doorInnerRRect, doorInteriorPaint);

    // Open Door Leaf (Magenta/Rose interior door swinging open)
    final openDoorPaint = Paint()
      ..color = const Color(0xFFBE185D)
      ..style = PaintingStyle.fill;
    final openDoorPath = Path()
      ..moveTo(w * 0.20, h * 0.42)
      ..lineTo(w * 0.38, h * 0.44)
      ..lineTo(w * 0.36, h * 0.88)
      ..lineTo(w * 0.20, h * 0.88)
      ..close();
    canvas.drawPath(openDoorPath, openDoorPaint);

    // 4. Customer inside doorway
    // Head & Hair
    final skinPaint = Paint()..color = const Color(0xFFD97706);
    final hairPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(Offset(w * 0.28, h * 0.49), 16, skinPaint);
    final customerHair = Path()
      ..addArc(Rect.fromCircle(center: Offset(w * 0.28, h * 0.49), radius: 18), 3.14, 3.14);
    canvas.drawPath(customerHair, hairPaint);

    // Customer Yellow Jacket
    final jacketPaint = Paint()..color = const Color(0xFFFBBF24);
    final customerBody = Path()
      ..moveTo(w * 0.23, h * 0.54)
      ..lineTo(w * 0.33, h * 0.54)
      ..lineTo(w * 0.35, h * 0.68)
      ..lineTo(w * 0.21, h * 0.68)
      ..close();
    canvas.drawPath(customerBody, jacketPaint);

    // Customer Jeans (Cyan)
    final jeansPaint = Paint()..color = const Color(0xFF38BDF8);
    final customerLegs = Path()
      ..moveTo(w * 0.22, h * 0.68)
      ..lineTo(w * 0.34, h * 0.68)
      ..lineTo(w * 0.32, h * 0.86)
      ..lineTo(w * 0.29, h * 0.86)
      ..lineTo(w * 0.28, h * 0.74)
      ..lineTo(w * 0.27, h * 0.86)
      ..lineTo(w * 0.24, h * 0.86)
      ..close();
    canvas.drawPath(customerLegs, jeansPaint);

    // Customer hands holding cash/token
    final cashPaint = Paint()..color = const Color(0xFF10B981);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.32, h * 0.60, 22, 12),
        const Radius.circular(3),
      ),
      cashPaint,
    );

    // 5. Stacked Delivery Boxes (Bottom Right)
    final boxPaint = Paint()..color = const Color(0xFFF59E0B);
    final ribbonPaint = Paint()..color = const Color(0xFFDC2626);
    // Base Box
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.60, h * 0.72, w * 0.34, h * 0.17),
        const Radius.circular(6),
      ),
      boxPaint,
    );
    // Base Box Red Ribbon
    canvas.drawRect(Rect.fromLTWH(w * 0.75, h * 0.72, 8, h * 0.17), ribbonPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.60, h * 0.80, w * 0.34, 6), ribbonPaint);

    // Upper Box
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.68, h * 0.58, w * 0.24, h * 0.15),
        const Radius.circular(6),
      ),
      boxPaint,
    );
    canvas.drawRect(Rect.fromLTWH(w * 0.79, h * 0.58, 6, h * 0.15), ribbonPaint);

    // 6. Delivery Rider (Standing Right, Facing Customer)
    // Rider Head & Orange Cap
    final riderSkinPaint = Paint()..color = const Color(0xFF9A3412);
    final capPaint = Paint()..color = const Color(0xFFEA580C);
    canvas.drawCircle(Offset(w * 0.66, h * 0.48), 16, riderSkinPaint);
    // Cap
    final capPath = Path()
      ..moveTo(w * 0.60, h * 0.47)
      ..lineTo(w * 0.72, h * 0.45)
      ..lineTo(w * 0.68, h * 0.42)
      ..lineTo(w * 0.58, h * 0.45)
      ..close();
    canvas.drawPath(capPath, capPaint);

    // Rider Cyan Shirt/Jacket
    final riderShirtPaint = Paint()..color = const Color(0xFF67E8F9);
    final riderTorso = Path()
      ..moveTo(w * 0.60, h * 0.53)
      ..lineTo(w * 0.71, h * 0.53)
      ..lineTo(w * 0.72, h * 0.67)
      ..lineTo(w * 0.61, h * 0.67)
      ..close();
    canvas.drawPath(riderTorso, riderShirtPaint);

    // Rider Orange Cargo Trousers
    final trousersPaint = Paint()..color = const Color(0xFFF97316);
    final riderLegs = Path()
      ..moveTo(w * 0.61, h * 0.67)
      ..lineTo(w * 0.72, h * 0.67)
      ..lineTo(w * 0.76, h * 0.86)
      ..lineTo(w * 0.71, h * 0.86)
      ..lineTo(w * 0.67, h * 0.75)
      ..lineTo(w * 0.56, h * 0.86)
      ..lineTo(w * 0.51, h * 0.86)
      ..close();
    canvas.drawPath(riderLegs, trousersPaint);

    // Rider Blue Shoes
    final shoePaint = Paint()..color = const Color(0xFF2563EB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.49, h * 0.85, 24, 9), const Radius.circular(4)),
      shoePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.70, h * 0.85, 24, 9), const Radius.circular(4)),
      shoePaint,
    );

    // 7. Active Parcel being handed over (in the middle between Customer & Rider)
    final parcelPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.53, w * 0.22, h * 0.14),
        const Radius.circular(6),
      ),
      parcelPaint,
    );
    // Parcel red cross ribbons
    canvas.drawRect(Rect.fromLTWH(w * 0.48, h * 0.53, 6, h * 0.14), ribbonPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.38, h * 0.59, w * 0.22, 6), ribbonPaint);

    // 8. Joyful Confetti / Sparkles
    final confettiPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(Offset(w * 0.52, h * 0.46), 4, confettiPaint);
    canvas.drawCircle(Offset(w * 0.58, h * 0.48), 3, confettiPaint);
    canvas.drawCircle(Offset(w * 0.08, h * 0.60), 4, confettiPaint);
    canvas.drawCircle(Offset(w * 0.88, h * 0.50), 3, confettiPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
