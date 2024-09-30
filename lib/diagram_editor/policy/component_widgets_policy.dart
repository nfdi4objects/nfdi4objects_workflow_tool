import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/dialog/edit_component_dialog.dart';
import '/diagram_editor/policy/custom_policy.dart';
import '/diagram_editor/widget/option_icon.dart';
import 'package:flutter/material.dart';

mixin MyComponentWidgetsPolicy implements ComponentWidgetsPolicy, CustomStatePolicy {
  @override
  Widget showCustomWidgetWithComponentDataOver(BuildContext context, ComponentData componentData) {
    bool isJunction = componentData.type == 'junction';
    bool showOptions = (!isMultipleSelectionOn) && (!isReadyToConnect) && !isJunction;

    return Visibility(
      visible: componentData.data.isHighlightVisible,
      child: Stack(
        children: [
          if (showOptions) componentTopOptions(componentData, context),
          if (showOptions) componentLeftOptions(componentData, context),
          if (showOptions) componentBottomOptions(componentData),
          highlight(componentData, isMultipleSelectionOn ? Colors.cyan : Colors.red),
          if (showOptions) resizeCorner(componentData),
          if (isJunction && !isReadyToConnect) junctionOptions(componentData),
        ],
      ),
    );
  }

  Widget componentTopOptions(ComponentData componentData, context) {
    Offset componentPosition = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 40,
            onPressed: () {
              canvasWriter.model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.copy,
            tooltip: 'duplicate',
            size: 40,
            onPressed: () {
              String newId = duplicate(componentData);
              canvasWriter.model.moveComponentToTheFront(newId);
              selectedComponentId = newId;
              hideComponentHighlight(componentData.id);
              highlightComponent(newId);
            },
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.edit,
            tooltip: 'edit',
            size: 40,
            onPressed: () => showEditComponentDialog(context, componentData),
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.link_off,
            tooltip: 'remove links',
            size: 40,
            onPressed: () => canvasWriter.model.removeComponentConnections(componentData.id),
          ),
        ],
      ),
    );
  }

  Widget componentBottomOptions(ComponentData componentData) {
    Offset componentBottomLeftCorner =
        canvasReader.state.toCanvasCoordinates(componentData.position + componentData.size.bottomLeft(Offset.zero));
    return Positioned(
      left: componentBottomLeftCorner.dx - 16,
      top: componentBottomLeftCorner.dy + 8,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_upward,
            tooltip: 'bring to front',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => canvasWriter.model.moveComponentToTheFront(componentData.id),
          ),
          const SizedBox(width: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_downward,
            tooltip: 'move to back',
            size: 24,
            shape: BoxShape.rectangle,
            onPressed: () => canvasWriter.model.moveComponentToTheBack(componentData.id),
          ),
          const SizedBox(width: 40),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 40,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }

  Widget componentLeftOptions(ComponentData componentData, context) {
    Offset componentPosition = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 56,
      top: componentPosition.dy - 10,
      child: Column(
        children: [
          OptionIcon(
            color: Colors.yellowAccent.withOpacity(0.7),
            iconData: Icons.camera_alt,
            tooltip: 'photo',
            size: 40,
            onPressed: () {
              canvasWriter.model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(height: 12),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.record_voice_over_outlined,
            tooltip: 'record',
            size: 40,
            onPressed: () {
              String newId = duplicate(componentData);
              canvasWriter.model.moveComponentToTheFront(newId);
              selectedComponentId = newId;
              hideComponentHighlight(componentData.id);
              highlightComponent(newId);
            },
          ),
        ],
      ),
    );
  }

  Widget highlight(ComponentData componentData, Color color) {
    return Positioned(
      left: canvasReader.state.toCanvasCoordinates(componentData.position - const Offset(2, 2)).dx,
      top: canvasReader.state.toCanvasCoordinates(componentData.position - const Offset(2, 2)).dy,
      child: CustomPaint(
        painter: ComponentHighlightPainter(
          width: (componentData.size.width + 4) * canvasReader.state.scale,
          height: (componentData.size.height + 4) * canvasReader.state.scale,
          color: color,
        ),
      ),
    );
  }

  resizeCorner(ComponentData componentData) {
    Offset componentBottomRightCorner =
        canvasReader.state.toCanvasCoordinates(componentData.position + componentData.size.bottomRight(Offset.zero));
    return Positioned(
      left: componentBottomRightCorner.dx - 12,
      top: componentBottomRightCorner.dy - 12,
      child: GestureDetector(
        onPanUpdate: (details) {
          canvasWriter.model.resizeComponent(componentData.id, details.delta / canvasReader.state.scale);
          canvasWriter.model.updateComponentLinks(componentData.id);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeDownRight,
          child: Container(
            width: 24,
            height: 24,
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget junctionOptions(ComponentData componentData) {
    Offset componentPosition = canvasReader.state.toCanvasCoordinates(componentData.position);
    return Positioned(
      left: componentPosition.dx - 24,
      top: componentPosition.dy - 48,
      child: Row(
        children: [
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.delete_forever,
            tooltip: 'delete',
            size: 32,
            onPressed: () {
              canvasWriter.model.removeComponent(componentData.id);
              selectedComponentId = null;
            },
          ),
          const SizedBox(width: 8),
          OptionIcon(
            color: Colors.grey.withOpacity(0.7),
            iconData: Icons.arrow_right_alt,
            tooltip: 'connect',
            size: 32,
            onPressed: () {
              isReadyToConnect = true;
              componentData.updateComponent();
            },
          ),
        ],
      ),
    );
  }
}
