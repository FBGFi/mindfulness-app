import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/utils/mind_set_object.dart';

class MindSet extends StatefulWidget {
  const MindSet({super.key, required this.dateTime, required this.mindSet});

  final String dateTime;
  final MindSetObject mindSet;

  @override
  State<MindSet> createState() => _MindSetState();
}

class _MindSetState extends State<MindSet> {
  bool _displayNotes = false;

  String _formatDateTime(String key) {
    DateTime dateTime = DateTime.parse(key);
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
                          child: Text(_formatDateTime(widget.dateTime),
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
                          widthFactor: 0.8,
                          child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Text(
                                  widget.mindSet.feeling,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ]))
                    ],
                  ),
                  Visibility(
                      visible: _displayNotes,
                      child: Text(widget.mindSet.notes,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize:
                                Theme.of(context).textTheme.bodySmall?.fontSize,
                          )))
                ]))));
  }
}

class MindSets extends StatefulWidget {
  const MindSets({super.key, required this.mindSets});

  final Map<String, MindSetObject> mindSets;

  @override
  State<MindSets> createState() => _MindSetsState();
}

class _MindSetsState extends State<MindSets> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: widget.mindSets.entries
            .map((entry) => Center(
                    child: MindSet(
                  dateTime: entry.key,
                  mindSet: entry.value,
                )))
            .toList());
  }
}
