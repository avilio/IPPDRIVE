
class Slugify {

  String _slugAccents(String phrase){

    if(phrase == null) return "";

    String slug = phrase.toLowerCase().trim();

    slug = slug.replaceAll(new RegExp(r'[àáâãäå]'),'a');
    slug = slug.replaceAll(new RegExp(r'æ'),'ae');
    slug = slug.replaceAll(new RegExp(r'ç'),'c');
    slug = slug.replaceAll(new RegExp(r'[èéêë]'),'e');
    slug = slug.replaceAll(new RegExp(r'[ìíîï]'),'i');
    slug = slug.replaceAll(new RegExp(r'ñ'),'n');
    slug = slug.replaceAll(new RegExp(r'[òóôõö]'),'o');
    slug = slug.replaceAll(new RegExp(r'œ'),'oe');
    slug = slug.replaceAll(new RegExp(r'[ùúûü]'),'u');
    slug = slug.replaceAll(new RegExp(r'[ýÿ]'),'y');

    return slug;
  }

  String slugGenerator (String string){

    String slug = _slugAccents(string);

    slug = slug.replaceAll(r'-+','');
    slug = slug.replaceAll(new RegExp(r'[^a-z0-9-]'), '');
    slug = slug.replaceAll(r'_', '');
    slug = slug.replaceAll(r'\s+','-');
    slug = slug.replaceAll(r'.','');

    return slug.length > 50 ? slug.substring(0,50).toLowerCase() : slug.toLowerCase();
  }
}