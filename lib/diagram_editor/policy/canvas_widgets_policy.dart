import 'package:diagram_editor/diagram_editor.dart';
import '/diagram_editor/data/custom_component_data.dart';
import '/diagram_editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';

mixin MyCanvasWidgetsPolicy implements CanvasWidgetsPolicy, CustomStatePolicy {
  @override
  List<Widget> showCustomWidgetsOnCanvasBackground(BuildContext context) {
    return [
      Visibility(
        visible: isGridVisible,
        child: CustomPaint(
          size: Size.infinite,
          painter: GridPainter(
            offset: canvasReader.state.position / canvasReader.state.scale,
            scale: canvasReader.state.scale,
            lineWidth: (canvasReader.state.scale < 1.0) ? canvasReader.state.scale : 1.0,
            matchParentSize: false,
            lineColor: const Color(0xFF0D47A1), // Grid line color
          ),
        ),
      ),
      DragTarget<ComponentData>(
        builder: (_, __, ___) => const SizedBox.shrink(),
        onWillAcceptWithDetails: (DragTargetDetails<ComponentData>? data) => true,
        onAcceptWithDetails: (DragTargetDetails<ComponentData> details) => _onAcceptWithDetails(details, context),
      ),
    ];
  }

  void _onAcceptWithDetails(
      DragTargetDetails<ComponentData> details,
      BuildContext context,
      ) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;

    // Convert global drop position to canvas-local position
    final Offset localOffset = renderObject.globalToLocal(details.offset);
    Offset componentPosition = canvasReader.state.fromCanvasCoordinates(localOffset);

    // Get the dragged component's data
    ComponentData draggedComponentData = details.data;

    // Create a new instance of MyComponentData by copying dragged component's data
    MyComponentData myComponentData = draggedComponentData.data.copy();

    // Add the component to the canvas with correct position and data
    String componentId = canvasWriter.model.addComponent(
      ComponentData(
        id: 'unique_id',  // Use a unique id for the new component
        position: componentPosition,  // The position where it's dropped
        size: draggedComponentData.size,  // Size from the dragged component
        minSize: draggedComponentData.minSize,  // Min size from the dragged component
        type: draggedComponentData.type,  // Type from the dragged component
        data: myComponentData,  // Pass copied data
      ),
    );

    // Optionally bring the component to the front
    canvasWriter.model.moveComponentToTheFrontWithChildren(componentId);

    // Ensure the canvas is redrawn after adding the component
//    canvasWriter.model.updateCanvas();
  }
}
