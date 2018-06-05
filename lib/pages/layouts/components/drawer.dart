import 'package:flutter/material.dart';
import 'package:ippdrive/pages/themes/colorsThemes.dart';


class MyDrawer extends StatelessWidget{


// final BuildContext context;

 final String user;
 final String school;
 final String course;


 MyDrawer(this.school,this.course, this.user,);

 Widget myDrawerHeader(String school, String user, [String course]) {
   //todo arranjar forma de fazer display so do nome do curso

   var imgSchool;
   switch (school) {
     case 'estg':
       imgSchool = AssetImage("assets/images/estg.png");
       break;
     case 'esecs':
       imgSchool = AssetImage("assets/images/esecs.png");
       break;
     case 'ess':
       imgSchool = AssetImage("assets/images/ess.png");
       break;
     case 'esae':
       imgSchool = AssetImage("assets/images/esae.png");
       break;
   }

   return new UserAccountsDrawerHeader(
     accountName: new Text(
       user,
       textScaleFactor: 1.5,
       style: new TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
     ),
     accountEmail: new Text(
       course,
       style: new TextStyle(fontWeight: FontWeight.bold),
     ),
     currentAccountPicture: new CircleAvatar(
       backgroundImage: imgSchool,
       backgroundColor: Colors.transparent,
     ),
     decoration: BoxDecoration(
       /*  image: new DecorationImage(
                    image: AssetImage("assets/images/ipp.png"),
                  fit: BoxFit.fill
                ),*/
         shape: BoxShape.rectangle,
         // borderRadius: new BorderRadius.only(topRight:Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
         border: Border.all(style: BorderStyle.solid, color: cAppBlackish),
         color: cAppYellowish),
   );
 }



  @override
  Widget build(BuildContext context) {

   /* String school = list[0]['path'].split('/')[3];
    String course = list[0]['path'].split('/')[5];*/

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          myDrawerHeader(school, user, course),
          new ListTile(
            title: new Text(
              "Logout",
              textScaleFactor: 1.5,
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed("/login"),
            trailing: new Icon(Icons.exit_to_app),
          )
        ],
      ),
    );

  }


}