import 'package:ippdrive/RequestsAPI/json/folderFieldsRequest.dart';

class UCModel{

  final String vfsWebAddress;
  final int dateSaveDate;
  final int indexInParent;
 // final List aclList;
  final int courseCodeAuxiliary;
  final int dateUpdateDate;
  final bool directory;
  final String path;
  final String courseUnitsListName;
  final int id;
  final int countChilds;
  final int unitIdAuxiliary;
  final Map clearances;

  UCModel({this.vfsWebAddress, this.dateSaveDate, this.indexInParent,
      this.courseCodeAuxiliary, this.dateUpdateDate,
      this.directory, this.path, this.courseUnitsListName, this.id,
      this.countChilds, this.unitIdAuxiliary, this.clearances});


  UCModel.fromResponse(Fields fields)
      : vfsWebAddress = fields.vfsWebAddress,
        dateSaveDate = fields.dateSaveDate,
  indexInParent = fields.indexInParent,
  courseCodeAuxiliary = fields.courseCodeAuxiliary,
  dateUpdateDate = fields.dateUpdateDate,
  directory = fields.directory,
  path = fields.path,
  courseUnitsListName = fields.courseUnitsList[0]['name'],
  id = fields.id,
  countChilds = fields.countChilds,
  unitIdAuxiliary = fields.unitIdAuxiliary,
  clearances = fields.clearances;


}

