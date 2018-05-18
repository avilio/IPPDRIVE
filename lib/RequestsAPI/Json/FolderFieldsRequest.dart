import 'package:json_annotation/json_annotation.dart';

part 'FolderFieldsRequest.g.dart';

@JsonSerializable()
class CourseUnits extends Object with _$CourseUnitsSerializerMixin {


  @JsonKey(name: 'childs')
  final List<Fields> courseFolders;

  CourseUnits(this.courseFolders);


  factory CourseUnits.fromJson(Map<String,dynamic> json) => _$CourseUnitsFromJson(json);
}

@JsonSerializable()
class Fields extends Object with _$FieldsSerializerMixin {

  final String vfsWebAddress;
  final int dateSaveDate;
  final int indexInParent;
  final List aclList;
  final int courseCodeAuxiliary;
  final int dateUpdateDate;
  final bool directory;
  final String path;
  final List courseUnitsList;
  final int id;
  final int countChilds;
  final int unitIdAuxiliary;
  final Map clearances;

  Fields(this.vfsWebAddress, this.dateSaveDate, this.indexInParent,
      this.aclList, this.courseCodeAuxiliary, this.dateUpdateDate,
      this.directory, this.path, this.courseUnitsList, this.id,
      this.countChilds, this.unitIdAuxiliary, this.clearances);



  factory Fields.fromJson(Map<String,dynamic> json) => _$FieldsFromJson(json);
}