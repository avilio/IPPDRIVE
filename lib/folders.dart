class Folders {

int id;
String title, pathParent, path;
bool directory;
Map<String,bool> clearances;

Folders(this.id, this.title, this.pathParent, this.path, this.directory,
    this.clearances);

Folders.fromJson(Map json)
    : id = json['id'],
      title = json['title'],
      pathParent = json['pathParent'],
      path = json['path'],
      directory = json['directory'],
      clearances = json['clearances'];


}