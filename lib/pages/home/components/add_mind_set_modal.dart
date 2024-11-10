import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindfulness_app/utils/mind_set_object.dart';

class AddMindSetModal extends StatefulWidget {
  const AddMindSetModal({super.key, required this.onAddNew});

  final Function(MindSetObject mindSet) onAddNew;

  @override
  State<AddMindSetModal> createState() => _AddMindSetModalState();
}

class _AddMindSetModalState extends State<AddMindSetModal> {
  String feeling = "";
  String notes = "";

  final _feelingFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();

  void onFeelingChanged(String feeling) {
    setState(() {
      this.feeling = feeling;
    });
  }

  void onNotesChanged(String notes) {
    setState(() {
      this.notes = notes;
    });
  }

  void onConfirm() {
    widget.onAddNew(MindSetObject(feeling: feeling, notes: notes));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _feelingFocusNode.unfocus();
          _notesFocusNode.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              toolbarHeight: 80.0,
              leading: Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back))),
              title: Container(
                  height: 60.0,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Add notes of current mindset",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )))),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  focusNode: _feelingFocusNode,
                  onChanged: onFeelingChanged,
                  decoration: const InputDecoration(label: Text("Feeling")),
                ),
                TextField(
                  focusNode: _notesFocusNode,
                  onChanged: onNotesChanged,
                  decoration: const InputDecoration(label: Text("Notes")),
                  maxLines: 30,
                  minLines: 1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: onConfirm, child: const Icon(Icons.add)),
        ));
  }
}
