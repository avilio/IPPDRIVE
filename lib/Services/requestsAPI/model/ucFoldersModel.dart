import 'package:ippdrive/Services/requestsAPI/json/folderFieldsRequest.dart';

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
  final String title;

  UCModel(this.title, {this.vfsWebAddress, this.dateSaveDate, this.indexInParent,
      this.courseCodeAuxiliary, this.dateUpdateDate,
      this.directory, this.path, this.courseUnitsListName, this.id,
      this.countChilds, this.unitIdAuxiliary, this.clearances});


  UCModel.fromResponse(ApiSavedFields fields)
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
  clearances = fields.clearances,
  title = fields.title;
//todo nao foi a melhor maneira de resolver o promblema de nao ter lista no courserunitslisname
  UCModel.fromRecursiveResponse(ApiSavedFields fields)
      : vfsWebAddress = fields.vfsWebAddress,
        dateSaveDate = fields.dateSaveDate,
        indexInParent = fields.indexInParent,
        courseCodeAuxiliary = fields.courseCodeAuxiliary,
        dateUpdateDate = fields.dateUpdateDate,
        directory = fields.directory,
        path = fields.path,
        courseUnitsListName = null,
        id = fields.id,
        countChilds = fields.countChilds,
        unitIdAuxiliary = fields.unitIdAuxiliary,
        clearances = fields.clearances,
        title = fields.title;


}

