library dataJ;

import 'package:json_annotation/json_annotation.dart';

part 'dataJ.g.dart';

@JsonSerializable()
class DataJ extends Object with _$DataJSerializerMixin {

  DataJ(this.dados, this.apikey);

  String dados;
  String apikey;

  factory DataJ.fromJson(Map<String, dynamic> json) => _$DataJFromJson(json);

}