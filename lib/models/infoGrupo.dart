class InfoGrupo {
  final String id;
  final String grupo;
  final String sede;
  final String institucion;
  final String municipio;
  final String numGrupo;

  InfoGrupo.fromJson(Map<String, dynamic> json)
      : id = json['id'] != null ? json['id'] as String : '',
        grupo = json['nombre'] != null ? json['nombre'] as String : '',
        sede = json['sede'] != null ? json['sede'] as String : '',
        institucion = json['institución'] != null ? json['institución'] as String : '',
        municipio = json['municipio'] != null ? json['municipio'] as String : '',
        numGrupo = json['numGrupo'] != null ? json['numGrupo'] as String : '';
}