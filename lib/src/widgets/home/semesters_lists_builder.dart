
class SemestersBuilder{
 //List response;
 List semester1,semester2;

 SemestersBuilder(this.semester1, this.semester2);

 SemestersBuilder.fromList2List(List list){
   semester1 = List();
   semester2 = List();
   list.map((item) {
     if (item['courseUnitsList'][0]['semestre'] == "S1")
       this.semester1.add(item);
     else if (item['courseUnitsList'][0]['semestre'] == "S2")
       this.semester2.add(item);
   }).toList();
 }
}