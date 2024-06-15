class Municipio {
  final String municipio;
  final String dane_municipio;

  Municipio.fromJson(Map<String, dynamic> json)
      : municipio = json['nombre'] != null ? json['nombre'] as String : '',
        dane_municipio = json['dane'] != null ? json['dane'] as String : '';
}
