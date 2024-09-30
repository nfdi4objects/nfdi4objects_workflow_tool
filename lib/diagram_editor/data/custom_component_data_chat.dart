import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyComponentData {
  // Fields
  Color color;
  Color borderColor;
  double borderWidth;
  String text;
  Alignment textAlignment;
  double textSize;
  bool isHighlightVisible;

  // Constructor with default values
  MyComponentData({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 15,
    this.isHighlightVisible = false,
  });

  // Copy Constructor
  MyComponentData.copy(MyComponentData customData)
      : this(
    color: customData.color,
    borderColor: customData.borderColor,
    borderWidth: customData.borderWidth,
    text: customData.text,
    textAlignment: customData.textAlignment,
    textSize: customData.textSize,
    isHighlightVisible: customData.isHighlightVisible,
  );

  // Deserialization from JSON
  factory MyComponentData.fromJson(Map<String, dynamic> json) {
    return MyComponentData(
      color: Color(int.parse(json['color'], radix: 16)),  // Convert hex string to Color
      borderColor: Color(int.parse(json['borderColor'], radix: 16)),
      borderWidth: json['borderWidth']?.toDouble() ?? 0.0,
      text: json['text'] ?? '',
      textAlignment: _alignmentFromString(json['textAlignment'] ?? 'center'),
      textSize: json['textSize']?.toDouble() ?? 15.0,
    )..isHighlightVisible = json['isHighlightVisible'] ?? false;
  }


  // Serialization to JSON
  Map<String, dynamic> toJson() => {
    'color': color.toString().split('(0x')[1].split(')')[0],
    'borderColor': borderColor.toString().split('(0x')[1].split(')')[0],
    'borderWidth': borderWidth,
    'text': text,
    'textAlignment': _alignmentToString(textAlignment),
    'textSize': textSize,
    'isHighlightVisible': isHighlightVisible,
  };

  // Helper method for text alignment from string
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

  // Helper method to convert alignment to string
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