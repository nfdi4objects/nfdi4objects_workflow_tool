import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/data/custom_component_data.dart';
import '/diagram_editor/data/custom_link_data.dart';

class DiagramData {
  List<ComponentData> components;
  List<LinkData> links;

  DiagramData({
    required this.components,
    required this.links,
  });

  // fromJson method
  factory DiagramData.fromJson(
      Map<String, dynamic> json, {
        Function(Map<String, dynamic> json)? decodeCustomComponentData,
        Function(Map<String, dynamic> json)? decodeCustomLinkData,
      }) {
    return DiagramData(
      components: (json['components'] as List)
          .map(
            (componentJson) => ComponentData.fromJson(
          componentJson,
          decodeCustomComponentData: decodeCustomComponentData,
        ),
      )
          .toList(),
      links: (json['links'] as List)
          .map(
            (linkJson) => LinkData.fromJson(
          linkJson,
          decodeCustomLinkData: decodeCustomLinkData ?? MyLinkData.fromJson,
        ),
      )
          .toList(),
    );
  }

  // Convert DiagramData to JSON
  Map<String, dynamic> toJson() => {
    'components': components.map((component) => component.toJson()).toList(),
    'links': links.map((link) => link.toJson()).toList(),
  };
}
