import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'app_scaffold.dart';

class AgregarCiudadesPage extends StatefulWidget {
  const AgregarCiudadesPage({super.key});
  @override
  State<AgregarCiudadesPage> createState() => _AgregarCiudadesPageState();
}

class _AgregarCiudadesPageState extends State<AgregarCiudadesPage> {
  final TextEditingController _cityController = TextEditingController();
  final MapController _mapController = MapController();
  List ciudadData = [];
  double dLat = 29.0948207;
  double dLon = -110.9692202;
  double selectedLat = 29.0948207;
  double selectedLon = -110.9692202;
  int? selectedIndex;
  Future<List<Map<String, dynamic>>> ciudadesGuardadas =
      Future<List<Map<String, dynamic>>>.value([]);

  @override
  void initState() {
    super.initState();
    ciudadesGuardadas = _ciudadesGuardadas();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Agregar Ciudades",
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

            // ⬇️ Aquí va tu Column tal cual
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Busca una ciudad para agregarla a tu lista",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white, // se recomienda para contraste
                  ),
                ),

                const SizedBox(height: 20),
                const Text("Ciudad", style: TextStyle(color: Colors.white)),

                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingresa el nombre de la ciudad',
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              40,
                            ), // forma MUY redondeada
                          ),
                          elevation: 6,
                          shadowColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          final ciudad = _cityController.text;
                          if (ciudad.isNotEmpty) {
                            final resultados = await _buscarCiudad(ciudad);
                            if (!mounted) return;
                            setState(() => ciudadData = resultados);
                            debugPrint(ciudadData.toString());
                          }
                        },
                        child: const Text("Buscar Ciudad"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 6,
                          shadowColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          _agregarCiudad(
                            _cityController.text,
                            selectedLat,
                            selectedLon,
                          );
                        },
                        child: const Text("Agregar ciudad"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Lista de resultados
                SizedBox(
                  height: 200,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ciudades Encontradas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ← Para que la lista no cause overflow
                        Expanded(
                          child: ListView.builder(
                            itemCount: ciudadData.length,
                            itemBuilder: (context, index) {
                              final ciudadInfo = ciudadData[index];
                              return ListTile(
                                title: Text(
                                  ciudadInfo['display_name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Lat: ${ciudadInfo['lat']}  Lon: ${ciudadInfo['lon']}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                selected: selectedIndex == index,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    _cityController.text =
                                        ciudadInfo['display_name'];
                                    selectedLat = double.parse(
                                      ciudadInfo['lat'],
                                    );
                                    selectedLon = double.parse(
                                      ciudadInfo['lon'],
                                    );
                                    _mapController.move(
                                      LatLng(selectedLat, selectedLon),
                                      10,
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ciudades guardadas
                SizedBox(
                  height: 200,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: ciudadesGuardadas,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Error ${snapshot.error}');
                      }
                      final data = snapshot.data ?? [];
                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_city,
                                color: Colors.white,
                                size: 120,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No hay ciudades guardadas.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ciudades Guardadas",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // El ListView original
                            Expanded(
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final ciudad = data[index];
                                  return ListTile(
                                    title: Text(
                                      ciudad['nombre'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Lat: ${ciudad["latitud"] ?? "?"}  '
                                      'Lon: ${ciudad["longitud"] ?? "?"}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => _eliminarCiudad(index),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mapa de Ciudades",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // El mapa necesita Expanded dentro de la columna
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: LatLng(selectedLat, selectedLon),
                                initialZoom: 10,
                                maxZoom: 18,
                                minZoom: 3,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.weather_app',
                                  subdomains: const ['a', 'b', 'c'],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List> _buscarCiudad(String nombreCiudad) async {
    try {
      // Construimos el URI de forma segura
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': nombreCiudad,
        'format': 'json',
        'addressdetails': '1',
      });

      debugPrint('URL de búsqueda: $uri');

      final response = await http.get(
        uri,
        headers: {
          // Nominatim recomienda poner un User-Agent identificable
          'User-Agent': 'weather_app_flutter/1.0 (tu-correo@ejemplo.com)',
          'Accept': 'application/json',
        },
      );

      debugPrint('Status code búsqueda: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        debugPrint('Resultados Nominatim: ${data.length} elementos');
        if (data.isNotEmpty) {
          return data;
        } else {
          debugPrint('Nominatim respondió 200 pero sin resultados.');
          return [];
        }
      } else {
        debugPrint(
          'Error en Nominatim. Status: ${response.statusCode}, body: ${response.body}',
        );
        // opcional: mostrar SnackBar en pantalla
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al buscar ciudad (${response.statusCode}). Intenta con otro nombre.',
              ),
            ),
          );
        }
        return [];
      }
    } catch (e, st) {
      debugPrint('Excepción buscando ciudad: $e');
      debugPrint('Stacktrace: $st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión al buscar ciudad.')),
        );
      }
      return [];
    }
  }

  void _agregarCiudad(String nombre, double lat, double lon) async {
    debugPrint('=== Iniciando _agregarCiudad ===');
    debugPrint('Nombre: $nombre, Lat: $lat, Lon: $lon');

    final prefs = await SharedPreferences.getInstance();
    List<String> listaciudadesGuardadas = prefs.getStringList('ciudades') ?? [];
    debugPrint('Ciudades antes de agregar: ${listaciudadesGuardadas.length}');

    String ciudadString = json.encode({
      'nombre': nombre,
      'latitud': lat,
      'longitud': lon,
    });
    debugPrint('Ciudad a agregar (JSON): $ciudadString');

    listaciudadesGuardadas.add(ciudadString);
    await prefs.setStringList('ciudades', listaciudadesGuardadas);
    debugPrint('Ciudades después de agregar: ${listaciudadesGuardadas.length}');

    // Verificamos que se guardó correctamente
    final verificacion = prefs.getStringList('ciudades') ?? [];
    debugPrint(
      'Verificación - Total ciudades guardadas: ${verificacion.length}',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ciudad agregada: $nombre')));
    // Forzamos la reconstrucción
    setState(() {
      ciudadesGuardadas = _ciudadesGuardadas();
    });
    debugPrint('=== Fin _agregarCiudad ===');
  }

  void _eliminarCiudad(int index) async {
    debugPrint('=== Iniciando _eliminarCiudad ===');

    final prefs = await SharedPreferences.getInstance();
    List<String> lista = prefs.getStringList('ciudades') ?? [];

    debugPrint('Ciudades antes de eliminar: ${lista.length}');

    if (index >= 0 && index < lista.length) {
      lista.removeAt(index);
      await prefs.setStringList('ciudades', lista);
      debugPrint('Ciudad eliminada. Total ahora: ${lista.length}');
    }

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Ciudad eliminada')));

    setState(() {
      ciudadesGuardadas = _ciudadesGuardadas();
    });

    debugPrint('=== Fin _eliminarCiudad ===');
  }

  Future<List<Map<String, dynamic>>> _ciudadesGuardadas() async {
    debugPrint('=== Cargando ciudades guardadas ===');
    final prefs = await SharedPreferences.getInstance();
    final ciudadesString = prefs.getStringList('ciudades') ?? [];
    debugPrint('Total ciudades en SharedPreferences: ${ciudadesString.length}');

    if (ciudadesString.isNotEmpty) {
      debugPrint('Primera ciudad: ${ciudadesString.first}');
    }

    final resultado = ciudadesString
        .map((ciudadStr) => json.decode(ciudadStr) as Map<String, dynamic>)
        .toList();
    debugPrint('=== Fin carga ciudades ===');
    return resultado;
  }
}
