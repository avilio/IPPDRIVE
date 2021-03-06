class Folders {

int id,repositoryId;
String title, pathParent, path;
bool directory, isFav, isOff;
Map<String,dynamic> clearances, repositoryFile4JsonView;

Folders(this.id, this.title, this.pathParent, this.path, this.directory,this.isFav,
    this.clearances,int repositoryId ,Map repositoryFile4JsonView, bool isOff)
    : repositoryFile4JsonView = repositoryFile4JsonView ?? Map(),
      repositoryId = repositoryId ?? -1,
      isOff = isOff ?? false;

Map toMap()=> {
  "id" : id,
  "title" :title,
  "pathParent" : pathParent,
  "path" : path,
  "directory" :directory,
  "favorite" : isFav,
  "clearances" : clearances,
  "repositoryId" : repositoryId,
  "repositoryFile4JsonView" : repositoryFile4JsonView,
  "offline" : isOff
};

Folders.fromJson(Map json)
    : id = json['id'],
      title = json['title'],
      pathParent = json['pathParent'],
      path = json['path'],
      directory = json['directory'],
      isFav = json['favorite'],
      clearances = json['clearances'],
      isOff = json['offline'];
}