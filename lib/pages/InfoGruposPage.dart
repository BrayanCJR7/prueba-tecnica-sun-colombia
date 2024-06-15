import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_sun_colombia/globals.dart';
import 'package:prueba_tecnica_sun_colombia/models/infoGrupo.dart';

class InfoGruposPage extends StatefulWidget {
  final String? IdGrupo;

  const InfoGruposPage({super.key, required this.IdGrupo});

  @override
  State<InfoGruposPage> createState() => _InfoGruposPageState();
}

class _InfoGruposPageState extends State<InfoGruposPage> {
  Future<List<InfoGrupo>> getInfoGrupo() async {
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'User': user,
          'Password': Password,
          'option': option_info_grupos,
          'IdGrupo': widget.IdGrupo
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['login'] == 'Success') {
        final gruposData = data['data'] as List<dynamic>;
        return gruposData
            .map((gruposData) => InfoGrupo.fromJson(gruposData))
            .toList();
      } else {
        throw Exception('Error al obtener los grupos: ${data['data']}');
      }
    } else {
      throw Exception('Error de red: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getInfoGrupo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info Grupo"),
      ),
      body: Center(
        child: FutureBuilder<List<InfoGrupo>>(
          future: getInfoGrupo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final infoGrupos = snapshot.data!;
              return ListView.builder(
                  itemCount: infoGrupos.length,
                  itemBuilder: (context, index) {
                    final info = infoGrupos[index];
                    return Card(
                      child: ListTile(
                        /*leading: Icon(Icons.group),*/ // Example icon
                        title: Center(
                          child: Text(
                            info.grupo,
                            style: TextStyle(
                                fontWeight: FontWeight.bold), // Emphasis
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.corporate_fare),
                                // Example icon for Institución (optional)
                                Text(
                                  info.sede.isEmpty // Handle empty strings
                                      ? ""
                                      : "  ${info.sede}" /*"  ${info.institucion.substring(0, 10)}..."*/,
                                  // Truncation (optional)
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_pin),
                                // Example icon for Municipio
                                Text(
                                  " ${info.municipio}",
                                  style: TextStyle(fontSize: 12), // Body text
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.school),
                                // Example icon for Institución (optional)
                                Text(
                                  info.institucion.isEmpty // Handle empty strings
                                      ? ""
                                      : "  ${info.institucion}" /*"  ${info.institucion.substring(0, 10)}..."*/,
                                  // Truncation (optional)
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
