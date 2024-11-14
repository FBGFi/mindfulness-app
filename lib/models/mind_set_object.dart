import 'package:hive/hive.dart';

part 'mind_set_object.g.dart';

@HiveType(typeId: 0)
class MindSetObject extends HiveObject {
  @HiveField(0)
  String category;
  @HiveField(1)
  String feeling;
  @HiveField(2)
  String notes;

  MindSetObject(
      {required this.category, required this.feeling, required this.notes});
}

@HiveType(typeId: 1)
class MindSetObjectModel extends HiveObject {
  @HiveField(0)
  Map<String, MindSetObject> mindSets;

  MindSetObjectModel({required this.mindSets});
}
