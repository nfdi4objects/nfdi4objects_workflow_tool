import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/widget/component/base_component_body.dart';
import 'package:flutter/material.dart';
import '/diagram_editor/widget/menutools.dart';

class OvalBody extends StatelessWidget {
  final ComponentData componentData; // Change to ToolComponentData

  const OvalBody({super.key,
    required this.componentData,
  });

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      componentData: componentData,
      componentPainter: OvalPainter(
        color: componentData.data.color, // Access color directly
        borderColor: componentData.data.borderColor, // Access borderColor directly
        borderWidth: componentData.data.borderWidth, // Access borderWidth directly
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize = const Size(0, 0);

  OvalPainter({
    this.color = Colors.grey,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    componentSize = size;

    Path path = componentPath();

    canvas.drawPath(path, paint);

    if (borderWidth > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..color = borderColor
        ..strokeWidth = borderWidth;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = componentPath();
    return path.contains(position);
  }

  Path componentPath() {
    Path path = Path();
    path.addOval(
      Rect.fromLTWH(
        0,
        0,
        componentSize.width,
        componentSize.height,
      ),
    );
    return path;
  }
}
