class Sede {
  final String sede;
  final String dane_sede;

  Sede.fromJson(Map<String, dynamic> json)
      : sede = json['nombre'] != null ? json['nombre'] as String : '',
        dane_sede = json['dane'] != null ? json['dane'] as String : '';
}