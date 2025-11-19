import 'package:flutter/material.dart';
import 'app_scaffold.dart';

class Creditos extends StatelessWidget {
  const Creditos({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Créditos',
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade400, Colors.blue.shade700],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Agradecimientos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Agradecemos al profesor por su guía, paciencia y enseñanza durante el desarrollo de este proyecto.\n'
                    'También agradecemos el apoyo de las herramientas y APIs utilizadas que hicieron posible esta aplicación.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'App del Clima',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const ListTile(
                    leading: Icon(Icons.school, color: Colors.white, size: 36),
                    title: Text(
                      'Profesor:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Federico Miguel Cirett Galan',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'Integrantes del equipo:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text(
                          'Marian Adamari Amador Leyva',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text(
                          'Zihary Leticia Barajas Miranda',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text(
                          'Luisa Gabriela Villalobos Ramírez',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title: Text(
                          'Angel Gabriel Zazueta Galaz',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'APIs Utilizadas:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.cloud, color: Colors.white),
                        title: Text(
                          'Meteomatics Weather API',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Proporciona datos meteorológicos en tiempo real.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.map, color: Colors.white),
                        title: Text(
                          'OpenStreetMap / Nominatim API',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Permite obtener coordenadas geográficas y mapas.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
