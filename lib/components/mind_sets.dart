import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/models/mind_set_object.dart';
import 'package:mindfulness_app/utils/utils.dart';

class MindSet extends StatefulWidget {
  const MindSet({super.key, required this.mindSet, this.onDelete});

  final MindSetObject mindSet;
  final Function(MindSetObject mindSet)? onDelete;

  @override
  State<MindSet> createState() => _MindSetState();
}

class _MindSetState extends State<MindSet> {
  bool _displayNotes = false;

  String _formatDateTime() {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.mindSet.date);
    return DateFormat("HH:mm").format(dateTime);
  }

  void _onPressed() {
    setState(() {
      _displayNotes = !_displayNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: getMindSetColor(widget.mindSet), width: 3),
          color: Theme.of(context).colorScheme.primary.withAlpha(200),
        ),
        child: InkWell(
            onTap: _onPressed,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(direction: Axis.vertical, children: [
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      FractionallySizedBox(
                          widthFactor: 0.15,
                          child: Text(_formatDateTime(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.fontSize))),
                      const FractionallySizedBox(
                        widthFactor: 0.05,
                      ),
                      FractionallySizedBox(
                          widthFactor: widget.onDelete == null ? 0.8 : 0.7,
                          child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Text(
                                  '${widget.mindSet.category} - ${widget.mindSet.feeling}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ])),
                      widget.onDelete != null
                          ? FractionallySizedBox(
                              widthFactor: 0.1,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () =>
                                          widget.onDelete!(widget.mindSet),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      icon: const Icon(Icons.delete))))
                          : const FractionallySizedBox(widthFactor: 0)
                    ],
                  ),
                  Visibility(visible: _displayNotes, child: const Divider()),
                  Visibility(
                      visible: _displayNotes,
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.mindSet.notes,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize,
                              ))))
                ]))));
  }
}

class MindSets extends StatefulWidget {
  const MindSets({super.key, required this.mindSets, this.onDeleteMindSet});

  final List<MindSetObject> mindSets;
  final Function(MindSetObject mindSet)? onDeleteMindSet;

  @override
  State<MindSets> createState() => _MindSetsState();
}

class _MindSetsState extends State<MindSets> {
  @override
  Widget build(BuildContext context) {
    if (widget.mindSets.isEmpty) {
      return const Center(child: Text("No recorded mindsets for this day"));
    }
    return ListView(
        children: widget.mindSets
            .map((entry) => Center(
                    child: MindSet(
                  mindSet: entry,
                  onDelete: widget.onDeleteMindSet,
                )))
            .toList());
  }
}
