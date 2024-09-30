import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyComponentData {
  Color color;
  Color borderColor;
  double borderWidth;
  String text;
  Alignment textAlignment;
  double textSize;
  bool isHighlightVisible;
  Size size;
  Size minSize;
  String type;

  // Constructor with default values to avoid null issues
  MyComponentData({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 15.0,
    this.isHighlightVisible = false,
    this.size = const Size(0, 0),
    this.minSize = const Size(0, 0),
    this.type = '',
  });

  // Copy method
  MyComponentData copy() {
    return MyComponentData(
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      text: text,
      textAlignment: textAlignment,
      textSize: textSize,
      isHighlightVisible: isHighlightVisible,
      size: size,
      minSize: minSize,
      type: type,
    );
  }


  // CopyWith method for selective copying
  MyComponentData copyWith({
    Color? color,
    Color? borderColor,
    double? borderWidth,
    String? text,
    Alignment? textAlignment,
    double? textSize,
    bool? isHighlightVisible,
    Size? size,
    Size? minSize,
    String? type,
  }) {
    return MyComponentData(
      color: color ?? this.color,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      text: text ?? this.text,
      textAlignment: textAlignment ?? this.textAlignment,
      textSize: textSize ?? this.textSize,
      isHighlightVisible: isHighlightVisible ?? this.isHighlightVisible,
      size: size ?? this.size,
      minSize: minSize ?? this.minSize,
      type: type ?? this.type,
    );
  }

  // Serialization to JSON
  Map<String, dynamic> toJson() {
    return {
      'color': color.value.toRadixString(16),  // Convert Color to hex string
      'borderColor': borderColor.value.toRadixString(16),  // Convert borderColor to hex
      'borderWidth': borderWidth,
      'text': text,
      'textAlignment': _alignmentToString(textAlignment),
      'textSize': textSize,
      'isHighlightVisible': isHighlightVisible,
      'size': [size.width, size.height],
      'minSize': [minSize.width, minSize.height],
      'type': type,
    };
  }

  // Deserialization from JSON
  factory MyComponentData.fromJson(Map<String, dynamic> json) {
    return MyComponentData(
      color: json['color'] != null ? _colorFromHex(json['color']) : Colors.white,
      borderColor: json['borderColor'] != null ? _colorFromHex(json['borderColor']) : Colors.black,
      borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 1.0,
      text: json['text'] ?? '',
      textAlignment: _alignmentFromString(json['textAlignment'] ?? 'center'),
      textSize: (json['textSize'] as num?)?.toDouble() ?? 15.0,
      isHighlightVisible: json['isHighlightVisible'] ?? false,
      size: json['size'] != null ? Size(json['size'][0].toDouble(), json['size'][1].toDouble()) : const Size(0, 0),
      minSize: json['minSize'] != null ? Size(json['minSize'][0].toDouble(), json['minSize'][1].toDouble()) : const Size(0, 0),
      type: json['type'] ?? '',
    );
  }

  // Helper method to convert hex color string to Color
  static Color _colorFromHex(String hexString) {
    hexString = hexString.replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF$hexString';  // Add alpha if missing
    }
    return Color(int.parse(hexString, radix: 16));
  }

  // Helper method to convert alignment string to Alignment object
  static Alignment _alignmentFromString(String alignment) {
    switch (alignment) {
      case 'topLeft':
        return Alignment.topLeft;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topRight':
        return Alignment.topRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  // Helper method to convert Alignment object to string
  static String _alignmentToString(Alignment alignment) {
    if (alignment == Alignment.topLeft) return 'topLeft';
    if (alignment == Alignment.topCenter) return 'topCenter';
    if (alignment == Alignment.topRight) return 'topRight';
    if (alignment == Alignment.centerLeft) return 'centerLeft';
    if (alignment == Alignment.centerRight) return 'centerRight';
    if (alignment == Alignment.bottomLeft) return 'bottomLeft';
    if (alignment == Alignment.bottomCenter) return 'bottomCenter';
    if (alignment == Alignment.bottomRight) return 'bottomRight';
    return 'center';
  }

  // Methods for highlight
  void switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  void showHighlight() {
    isHighlightVisible = true;
  }

  void hideHighlight() {
    isHighlightVisible = false;
  }
}
