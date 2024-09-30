import 'package:flutter/material.dart';
import 'package:sheet/sheet.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange[50],
      child: SheetMediaQuery(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top:10, left:10, right:10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                FormBuilderChoiceChip<String>(
                  alignment: WrapAlignment.spaceEvenly,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'What is your level of experience?',
                    labelStyle: TextStyle(fontSize: 24),
                  ),
                  name: 'person_experience',
                  initialValue: 'None',
                  labelStyle: const TextStyle(fontSize: 24),
                  selectedColor: Colors.red,
                  elevation: 5,
                  options: const [

                    FormBuilderChipOption(
                      value: 'None',
                      avatar: CircleAvatar(child: Text('1')),
                    ),
                    FormBuilderChipOption(
                      value: 'Beginner',
                      avatar: CircleAvatar(child: Text('2')),
                    ),
                    FormBuilderChipOption(
                      value: 'Experienced',
                      avatar: CircleAvatar(child: Text('3')),
                    ),
                    FormBuilderChipOption(
                      value: 'Expert',
                      avatar: CircleAvatar(child: Text('4')),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('BACK'),
                      onPressed: () {

                        Navigator.of(context).pop();
                      },
                    ),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('SAVE'),

                      onPressed: () async {
//                            // Save new tool
//                            if (id == null) {
//                              await _addItem();
//                            }
//
//                            if (id != null) {
//                              await _updateItem(id);
//                            }
//
//                            // Clear the text fields
//                            _toolNameController.text = '';
//                            _toolTypeController.text = '';
//                            _toolActivityAreaController.text = '';
//                            _toolFunctionController.text = '';
//                            _toolCommentController.text = '';
//                            // Close the bottom sheet
//                            if (!mounted) return;
//                            Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

              ],
              // ],
            ),

          ),
        ),
      ),
    );
  }
}