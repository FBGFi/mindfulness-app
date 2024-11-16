import 'package:hive/hive.dart';

part 'mind_set_object.g.dart';

@HiveType(typeId: 0)
class MindSetObject extends HiveObject {
  @HiveField(0)
  late int date;
  @HiveField(1)
  String category;
  @HiveField(2)
  String feeling;
  @HiveField(3)
  late String notes;

  MindSetObject({
    int? date,
    this.notes = "No notes",
    required this.category,
    required this.feeling,
  }) {
    this.date = date ?? DateTime.now().millisecondsSinceEpoch;
  }
}
