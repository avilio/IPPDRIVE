import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SaveLocally extends Object{

  void saveListLocally(String key, List listConvert, SharedPreferences preferences){

    List<String> jsonList = new List();

    listConvert.forEach((value) {
      jsonList.add(jsonEncode(value));
    });

    preferences.setStringList(key, jsonList);
    
    print("SAVE LOCALLY");
    print(preferences.getStringList(key));

  }

}