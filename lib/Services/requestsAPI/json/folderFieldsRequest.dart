import 'package:json_annotation/json_annotation.dart';

part 'folderFieldsRequest.g.dart';

@JsonSerializable()
class CourseUnits extends Object with _$CourseUnitsSerializerMixin {


  @JsonKey(name: 'childs')
  final List<ApiSavedFields> courseFolders;

  CourseUnits(this.courseFolders);


  factory CourseUnits.fromJson(Map<String,dynamic> json) => _$CourseUnitsFromJson(json);
}

@JsonSerializable()
class ApiSavedFields extends Object with _$ApiSavedFieldsSerializerMixin {

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

  ApiSavedFields(this.vfsWebAddress, this.dateSaveDate, this.indexInParent,
      this.aclList, this.courseCodeAuxiliary, this.dateUpdateDate,
      this.directory, this.path, this.courseUnitsList, this.id,
      this.countChilds, this.unitIdAuxiliary, this.clearances);



  factory ApiSavedFields.fromJson(Map<String,dynamic> json) => _$ApiSavedFieldsFromJson(json);
}