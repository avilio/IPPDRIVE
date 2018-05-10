library dataJ;

import 'package:json_annotation/json_annotation.dart';

part 'dataJ.g.dart';

@JsonSerializable(includeIfNull: false)
class DataJ extends Object with _$DataJSerializerMixin {

  DataJ(this.dados);

  String dados;

  factory DataJ.fromJson(Map<String, dynamic> json) => _$DataJFromJson(json);

}

@JsonSerializable(includeIfNull: false )
class AppKey extends Object with _$AppKeySerializerMixin {

  AppKey(this.apikey);

  String apikey;

  factory AppKey.fromJson(Map<String, dynamic> json) => _$AppKeyFromJson(json);

}
@JsonLiteral('data.json')
Map get glossaryData => _$glossaryDataJsonLiteral;