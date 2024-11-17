import 'package:flutter/material.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/utils/constants.dart';

class AddMindSetModal extends StatefulWidget {
  const AddMindSetModal({super.key, required this.onAddNew});

  final Function(MindSetObject mindSet) onAddNew;

  @override
  State<AddMindSetModal> createState() => _AddMindSetModalState();
}

class _AddMindSetModalState extends State<AddMindSetModal> {
  String category = "";
  String feeling = "";
  String notes = "";
  bool dropHasError = false;

  final _feelingFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();

  void onFeelingChanged((String, String)? feeling) {
    setState(() {
      if (feeling == null) {
        category = "";
        this.feeling = "";
      } else {
        category = feeling.$1;
        this.feeling = feeling.$2;
      }
      dropHasError = false;
    });
  }

  void onNotesChanged(String notes) {
    setState(() {
      this.notes = notes;
    });
  }

  void onConfirm() {
    if (feeling == "" || category == "") {
      setState(() {
        dropHasError = true;
      });
    } else {
      widget.onAddNew(
          MindSetObject(category: category, feeling: feeling, notes: notes));
      Navigator.pop(context);
    }
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
                      icon: const Icon(Icons.arrow_back))),
              title: SizedBox(
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
                DropdownMenu<(String, String)>(
                  focusNode: _feelingFocusNode,
                  width: MediaQuery.sizeOf(context).width,
                  requestFocusOnTap: true,
                  menuHeight: MediaQuery.of(context).size.height / 2.5,
                  onSelected: onFeelingChanged,
                  errorText: dropHasError ? "Required" : null,
                  dropdownMenuEntries: MIND_SET_VALUES.entries
                      .map((group) => group.value.entries
                          .map((entry) => entry.key)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) => DropdownMenuEntry(
                              label: entry.value,
                              value: (group.key, entry.value),
                              labelWidget: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 60,
                                  child: entry.key == 0
                                      ? Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                              Positioned(
                                                  top: -20,
                                                  left: 0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        group.key,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Container(
                                                        height: 1,
                                                        color: const Color
                                                            .fromRGBO(
                                                            140, 140, 140, 1),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                      )
                                                    ],
                                                  )),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: Text(entry.value))
                                            ])
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(entry.value)))))
                          .toList())
                      .expand((e) => e)
                      .toList(),
                  label: const Text("Feeling"),
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
