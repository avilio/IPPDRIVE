import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveLocally extends Object{

  void saveListLocally(String key, List listConvert, SharedPreferences preferences)async {

    print("INICIO ${preferences.getKeys()}");

    if (await preferences.get(key)!= null) {

      List localList = await preferences.get(key);
      List<String> jsonList = new List();

      listConvert.forEach((value) {

        jsonList.add(jsonEncode(value));
      });
      if(!DeepCollectionEquality.unordered().equals(localList, jsonList)) {
        await preferences.remove(key);
        await preferences.setStringList(key, jsonList);
        print("CHANGES TO LOCAL");
      }
    }else{

      List<String> jsonList = new List();

      listConvert.forEach((value) {

          jsonList.add(jsonEncode(value));
      });

      await preferences.setStringList(key, jsonList);
      print("SAVED LOCALLY");
    }
    print("FIM ${preferences.getKeys()}");
  }

}