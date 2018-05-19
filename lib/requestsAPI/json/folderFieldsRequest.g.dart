// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folderFieldsRequest.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

CourseUnits _$CourseUnitsFromJson(Map<String, dynamic> json) =>
    new CourseUnits((json['childs'] as List)
        ?.map((e) =>
            e == null ? null : new Fields.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$CourseUnitsSerializerMixin {
  List<Fields> get courseFolders;
  Map<String, dynamic> toJson() => <String, dynamic>{'childs': courseFolders};
}

Fields _$FieldsFromJson(Map<String, dynamic> json) => new Fields(
    json['vfsWebAddress'] as String,
    json['dateSaveDate'] as int,
    json['indexInParent'] as int,
    json['aclList'] as List,
    json['courseCodeAuxiliary'] as int,
    json['dateUpdateDate'] as int,
    json['directory'] as bool,
    json['path'] as String,
    json['courseUnitsList'] as List,
    json['id'] as int,
    json['countChilds'] as int,
    json['unitIdAuxiliary'] as int,
    json['clearances'] as Map<String, dynamic>);

abstract class _$FieldsSerializerMixin {
  String get vfsWebAddress;
  int get dateSaveDate;
  int get indexInParent;
  List<dynamic> get aclList;
  int get courseCodeAuxiliary;
  int get dateUpdateDate;
  bool get directory;
  String get path;
  List<dynamic> get courseUnitsList;
  int get id;
  int get countChilds;
  int get unitIdAuxiliary;
  Map<dynamic, dynamic> get clearances;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'vfsWebAddress': vfsWebAddress,
        'dateSaveDate': dateSaveDate,
        'indexInParent': indexInParent,
        'aclList': aclList,
        'courseCodeAuxiliary': courseCodeAuxiliary,
        'dateUpdateDate': dateUpdateDate,
        'directory': directory,
        'path': path,
        'courseUnitsList': courseUnitsList,
        'id': id,
        'countChilds': countChilds,
        'unitIdAuxiliary': unitIdAuxiliary,
        'clearances': clearances
      };
}
