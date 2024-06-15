import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prueba_tecnica_sun_colombia/globals.dart';
import 'package:prueba_tecnica_sun_colombia/models/institucion.dart';

import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_sun_colombia/pages/SedesPage.dart';

class InstitucionesPage extends StatefulWidget {
  final String? CodMun;

  InstitucionesPage({required this.CodMun});

  @override
  InstitucionesPageState createState() => InstitucionesPageState();
}

class InstitucionesPageState extends State<InstitucionesPage> {

  Future<List<Institucion>> getInstitucion() async {
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'User': user,
          'Password': Password,
          'option': option_instituciones,
          'CodMun': widget.CodMun
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['login'] == 'Success') {
        final institucionData = data['data'] as List<dynamic>;
        return institucionData
            .map((institucionData) => Institucion.fromJson(institucionData))
            .toList();
      } else {
        throw Exception('Error al obtener municipios: ${data['data']}');
      }
    } else {
      throw Exception('Error de red: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getInstitucion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instituciones"),
      ),
      body: Center(
        child: Container(
          child: FutureBuilder<List<Institucion>>(
            future: getInstitucion(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final instituciones = snapshot.data!;
                return ListView.builder(
                    itemCount: instituciones.length,
                    itemBuilder: (context, index) {
                      final institucion = instituciones[index];
                      return ListTile(
                        title: Text(institucion.institucion),
                        subtitle: Text('DANE: ${institucion.dane_institucion}'),
                        onTap: () async{
                          final dane = institucion.dane_institucion;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SedesPage(CodInst: dane),
                            ),
                          );
                        },
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
      ),
    );
  }
}
