import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prueba_tecnica_sun_colombia/globals.dart';
import 'package:prueba_tecnica_sun_colombia/models/municipio.dart';

import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_sun_colombia/pages/InstitucionesPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Future<List<Municipio>> getMunicipios() async {
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'User': user,
          'Password': Password,
          'option': option_municipios,
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['login'] == 'Success') {
        final municipiosData = data['data'] as List<dynamic>;
        return municipiosData.map((municipioData) => Municipio.fromJson(municipioData)).toList();
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
    getMunicipios();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sun Colombia',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Instituciones del Tolima'),
        ),
        body: Center(
          child: Container(
            child: FutureBuilder<List<Municipio>>(
              future: getMunicipios(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final municipios = snapshot.data!;
                  return ListView.builder(
                    itemCount: municipios.length,
                    itemBuilder: (context, index) {
                      final municipio = municipios[index];
                      return ListTile(
                        title: Text(municipio.municipio),
                        subtitle: Text('DANE: ${municipio.dane_municipio}'),
                        onTap: () async{
                          final dane = municipio.dane_municipio;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InstitucionesPage(CodMun: dane),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ),
        ),
      ),
    );
  }
}
