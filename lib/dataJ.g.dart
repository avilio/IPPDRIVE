// GENERATED CODE - DO NOT MODIFY BY HAND

part of dataJ;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

DataJ _$DataJFromJson(Map<String, dynamic> json) =>
    new DataJ(json['dados'] as String);

abstract class _$DataJSerializerMixin {
  String get dados;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('dados', dados);
    return val;
  }
}

AppKey _$AppKeyFromJson(Map<String, dynamic> json) =>
    new AppKey(json['apikey'] as String);

abstract class _$AppKeySerializerMixin {
  String get apikey;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('apikey', apikey);
    return val;
  }
}

// **************************************************************************
// Generator: JsonLiteralGenerator
// **************************************************************************

final _$glossaryDataJsonLiteral = {
  'data': {'apikey': '12345678901234567890'}
};
