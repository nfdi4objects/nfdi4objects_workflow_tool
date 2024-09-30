import 'package:diagram_editor/diagram_editor.dart';
import 'canvas_policy.dart';
import 'canvas_widgets_policy.dart';
import 'component_design_policy.dart';
import 'component_policy.dart';
import 'component_widgets_policy.dart';
import 'custom_policy.dart';
import 'init_policy.dart';
import 'link_attachment_policy.dart';
import 'link_widgets_policy.dart';
import 'my_link_control_policy.dart';
import 'my_link_joint_control_policy.dart';

//class MyPolicySet extends PolicySet
class MyPolicySet extends PolicySet
    with
        MyInitPolicy,
        MyCanvasPolicy,
        MyComponentPolicy,
        MyComponentDesignPolicy,
        MyLinkControlPolicy,
        MyLinkJointControlPolicy,
        MyLinkWidgetsPolicy,
        MyLinkAttachmentPolicy,
        MyCanvasWidgetsPolicy,
        MyComponentWidgetsPolicy,
        CanvasControlPolicy,
        CustomStatePolicy,
        CustomBehaviourPolicy {

  // Method to add a component to the diagram context
  void addComponentToContext(ComponentData component) {
    canvasWriter.model.addComponent(component); // Assuming canvasWriter handles component additions
  }

  // Method to add a link to the diagram context
  void addLinkToContext(LinkData link) {
    canvasWriter.model.connectTwoComponents(data: link, sourceComponentId: '', targetComponentId: ''); // Assuming canvasWriter handles link additions
  }

  // Method to remove all components and links from the diagram
  @override
  void removeAll() {
    canvasWriter.model.removeAllComponents(); // Assuming canvasWriter provides this functionality
  }
}
