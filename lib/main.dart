import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const WorkScheduleApp());
}

class WorkScheduleApp extends StatelessWidget {
  const WorkScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planning de Travail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WorkScheduleHomePage(),
    );
  }
}

class WorkScheduleHomePage extends StatefulWidget {
  const WorkScheduleHomePage({super.key});

  @override
  State<WorkScheduleHomePage> createState() => _WorkScheduleHomePageState();
}

class _WorkScheduleHomePageState extends State<WorkScheduleHomePage> {
  List<WorkEvent> scheduleData = [];
  List<List<WorkEvent>> weeks = [];
  int currentWeek = 0;
  int todayWeek = 0; // Index de la semaine contenant aujourd'hui
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Charger les données sauvegardées ou les données d'exemple
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('schedule_data');

      if (savedData != null && savedData.isNotEmpty) {
        // Charger les données sauvegardées
        List<dynamic> jsonData = json.decode(savedData);
        List<WorkEvent> loadedEvents = jsonData.map((item) =>
            WorkEvent.fromJson(item as Map<String, dynamic>)
        ).toList();

        setState(() {
          scheduleData = loadedEvents;
          _organizeWeeks();
        });

        print("Loaded ${loadedEvents.length} events from saved data");
      } else {
        // Charger les données d'exemple si aucune donnée sauvegardée
        _loadSampleData();
      }
    } catch (e) {
      print("Error loading saved data: $e");
      // En cas d'erreur, charger les données d'exemple
      _loadSampleData();
    }
  }

  // Sauvegarder les données
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> jsonData = scheduleData.map((event) => event.toJson()).toList();
      await prefs.setString('schedule_data', json.encode(jsonData));
      print("Saved ${scheduleData.length} events to storage");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  // Effacer les données sauvegardées
  Future<void> _clearSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('schedule_data');
      print("Cleared saved data");
    } catch (e) {
      print("Error clearing saved data: $e");
    }
  }

  void _loadSampleData() {
    // Données d'exemple
    final sampleData = [
      WorkEvent('2025-06-16', '08:00-16:00', 'Bureau Principal', 'Réunion équipe, Rapports'),
      WorkEvent('2025-06-17', '09:00-17:00', 'Site A', 'Formation, Supervision'),
      WorkEvent('2025-06-18', '08:30-16:30', 'Bureau Principal', 'Planification, Suivi projets'),
      WorkEvent('2025-06-19', '10:00-18:00', 'Site B', 'Contrôle qualité, Audit'),
      WorkEvent('2025-06-20', '08:00-16:00', 'Bureau Principal', 'Réunions clients, Documentation'),
      WorkEvent('2025-06-21', '09:00-13:00', 'Domicile', 'Travail à distance, Rapports'),
      WorkEvent('2025-06-22', 'Repos', 'Congé', 'Jour de repos'),
      WorkEvent('2025-06-23', '09:00-17:00', 'Site A', 'Maintenance, Inspection'),
      WorkEvent('2025-06-24', '08:00-16:00', 'Bureau Principal', 'Analyse données, Présentation'),
      WorkEvent('2025-06-25', '14:00-22:00', 'Site C', 'Équipe de nuit, Surveillance'),
      WorkEvent('2025-06-26', '08:30-16:30', 'Bureau Principal', 'Formation nouveaux employés'),
      WorkEvent('2025-06-27', '07:00-15:00', 'Site A', 'Ouverture, Coordination équipes'),
      WorkEvent('2025-06-28', '10:00-14:00', 'Site B', 'Maintenance weekend, Garde'),
      WorkEvent('2025-06-29', 'Repos', 'Congé', 'Jour de repos'),
    ];

    setState(() {
      scheduleData = sampleData;
      _organizeWeeks();
    });
  }

  void _organizeWeeks() {
    print("_organizeWeeks called with ${scheduleData.length} events");

    Map<String, List<WorkEvent>> weekMap = {};

    for (var event in scheduleData) {
      try {
        DateTime date = DateTime.parse(event.date);
        DateTime weekStart = _getWeekStart(date);
        String weekKey = DateFormat('yyyy-MM-dd').format(weekStart);

        print("Event date: ${event.date} -> Week start: $weekStart -> Week key: $weekKey");

        weekMap[weekKey] ??= [];
        weekMap[weekKey]!.add(event);
      } catch (e) {
        print("Error parsing date ${event.date}: $e");
      }
    }

    print("Week map: $weekMap");

    // Trier les semaines et les jours
    List<String> sortedWeeks = weekMap.keys.toList()..sort();
    weeks = sortedWeeks.map((weekKey) {
      List<WorkEvent> weekEvents = weekMap[weekKey]!;
      weekEvents.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      return weekEvents;
    }).toList();

    print("Organized weeks: ${weeks.length}");
    for (int i = 0; i < weeks.length; i++) {
      print("Week $i: ${weeks[i].length} events");
    }

    // Trouver la semaine courante (aujourd'hui)
    _findTodayWeek();

    print("Current week set to: $currentWeek");
    print("Today week set to: $todayWeek");

    if (mounted) {
      setState(() {});
    }
  }

  void _findTodayWeek() {
    DateTime today = DateTime.now();
    todayWeek = 0; // Par défaut, première semaine
    currentWeek = 0;

    for (int i = 0; i < weeks.length; i++) {
      if (weeks[i].any((event) {
        DateTime eventDate = DateTime.parse(event.date);
        DateTime weekStart = _getWeekStart(eventDate);
        DateTime weekEnd = weekStart.add(const Duration(days: 6));
        return today.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            today.isBefore(weekEnd.add(const Duration(days: 1)));
      })) {
        todayWeek = i;
        currentWeek = i;
        break;
      }
    }
  }

  void _goToToday() {
    setState(() {
      currentWeek = todayWeek;
    });
  }

  // Dialogue de confirmation pour réinitialiser
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Réinitialiser le planning'),
          content: const Text(
            'Voulez-vous effacer le planning actuel et revenir aux données d\'exemple ?\n\nCette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearSavedData();
                _loadSampleData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Planning réinitialisé avec les données d\'exemple')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Réinitialiser'),
            ),
          ],
        );
      },
    );
  }

  DateTime _getWeekStart(DateTime date) {
    int weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  Future<void> _pickAndLoadCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String csvContent = await file.readAsString();

        print("Raw CSV Content: '$csvContent'");
        print("CSV Content length: ${csvContent.length}");

        // Normaliser les fins de ligne
        csvContent = csvContent.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

        print("Normalized CSV: '$csvContent'");

        // Parser manuel ligne par ligne
        List<String> lines = csvContent.split('\n');
        print("Split lines: $lines");
        print("Number of lines: ${lines.length}");

        if (lines.length < 2) {
          throw Exception('Fichier CSV invalide - pas assez de lignes');
        }

        // En-têtes
        List<String> headers = lines[0].split(',').map((h) => h.trim().toLowerCase()).toList();
        print("Parsed headers: $headers");

        List<WorkEvent> events = [];
        for (int i = 1; i < lines.length; i++) {
          String line = lines[i].trim();
          if (line.isEmpty) continue;

          List<String> values = line.split(',').map((v) => v.trim()).toList();
          print("Line $i: '$line' -> Values: $values");

          if (values.length >= 4) { // Au moins 4 colonnes attendues
            String date = values[0];
            String horaire = values[1];
            String poste = values[2];
            String taches = values[3];

            print("Creating event: date='$date', horaire='$horaire', poste='$poste', taches='$taches'");

            if (date.isNotEmpty && date != 'date') { // Éviter la ligne d'en-tête
              events.add(WorkEvent(date, horaire, poste, taches));
            }
          } else {
            print("Skipping line $i: not enough values (${values.length})");
          }
        }

        print("Total events created: ${events.length}");

        setState(() {
          scheduleData = events;
          _organizeWeeks();
        });

        // Sauvegarder automatiquement les nouvelles données
        await _saveData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${events.length} événements chargés avec succès!')),
          );
        }
      }
    } catch (e) {
      print("Error loading CSV: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Planning de Travail',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('MMMM yyyy', 'fr_FR').format(currentDate),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Boutons d'actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Bouton import CSV
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickAndLoadCSV,
                            icon: const Icon(Icons.upload_file, size: 18),
                            label: const Text('Importer CSV'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              foregroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Bouton Aujourd'hui
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: weeks.isNotEmpty && currentWeek != todayWeek ? _goToToday : null,
                            icon: const Icon(Icons.today, size: 18),
                            label: const Text("Aujourd'hui"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentWeek == todayWeek ? Colors.grey[300] : Colors.orange[100],
                              foregroundColor: currentWeek == todayWeek ? Colors.grey[600] : Colors.orange[700],
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Bouton reset (afficher seulement s'il y a des données sauvegardées)
                        if (scheduleData.isNotEmpty)
                          IconButton(
                            onPressed: () => _showResetDialog(),
                            icon: const Icon(Icons.refresh, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red[100],
                              foregroundColor: Colors.red[700],
                            ),
                            tooltip: 'Réinitialiser',
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Navigation semaines
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: currentWeek > 0 ? () {
                            setState(() {
                              currentWeek--;
                            });
                          } : null,
                          icon: const Icon(Icons.chevron_left),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[700],
                          ),
                        ),

                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Semaine', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                if (currentWeek == todayWeek) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Actuelle',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              weeks.isNotEmpty && currentWeek < weeks.length
                                  ? _getWeekRange(weeks[currentWeek])
                                  : 'Aucune donnée',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        IconButton(
                          onPressed: currentWeek < weeks.length - 1 ? () {
                            setState(() {
                              currentWeek++;
                            });
                          } : null,
                          icon: const Icon(Icons.chevron_right),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Contenu principal
              Expanded(
                child: weeks.isNotEmpty && currentWeek < weeks.length
                    ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: weeks[currentWeek].length,
                  itemBuilder: (context, index) {
                    WorkEvent event = weeks[currentWeek][index];
                    return _buildEventCard(event);
                  },
                )
                    : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Aucune donnée disponible'),
                      Text('Importez un fichier CSV pour commencer'),
                    ],
                  ),
                ),
              ),

              // Footer avec informations
              if (weeks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Semaine ${currentWeek + 1} sur ${weeks.length}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (scheduleData.isNotEmpty)
                        Text(
                          '${scheduleData.length} événements chargés',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(WorkEvent event) {
    DateTime date = DateTime.parse(event.date);
    bool isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == event.date;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE', 'fr_FR').format(date),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Aujourd'hui",
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          _buildInfoRow(Icons.access_time, event.horaire, Colors.blue),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, event.poste, Colors.red),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.task_alt, event.taches, Colors.green),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  String _getWeekRange(List<WorkEvent> weekEvents) {
    if (weekEvents.isEmpty) return '';

    DateTime firstDate = DateTime.parse(weekEvents.first.date);
    DateTime lastDate = DateTime.parse(weekEvents.last.date);

    return '${firstDate.day} - ${lastDate.day} ${DateFormat('MMM', 'fr_FR').format(lastDate)}';
  }
}

class WorkEvent {
  final String date;
  final String horaire;
  final String poste;
  final String taches;

  WorkEvent(this.date, this.horaire, this.poste, this.taches);

  // Conversion vers JSON pour la sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'horaire': horaire,
      'poste': poste,
      'taches': taches,
    };
  }

  // Création depuis JSON pour le chargement
  factory WorkEvent.fromJson(Map<String, dynamic> json) {
    return WorkEvent(
      json['date'] as String,
      json['horaire'] as String,
      json['poste'] as String,
      json['taches'] as String,
    );
  }
}