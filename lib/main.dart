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

class WorkScheduleApp extends StatefulWidget {
  const WorkScheduleApp({super.key});

  @override
  State<WorkScheduleApp> createState() => _WorkScheduleAppState();
}

class _WorkScheduleAppState extends State<WorkScheduleApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
  }

  void _toggleTheme() {
    final isDark = _themeMode == ThemeMode.dark;
    setState(() {
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
    _saveThemeMode(!isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planning de Travail',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),
      ),
      home: WorkScheduleHomePage(onThemeToggle: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}

class WorkScheduleHomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const WorkScheduleHomePage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<WorkScheduleHomePage> createState() => _WorkScheduleHomePageState();
}

class _WorkScheduleHomePageState extends State<WorkScheduleHomePage> {
  List<WorkEvent> scheduleData = [];
  List<List<WorkEvent>> weeks = [];
  int currentWeek = 0;
  int todayWeek = 0;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('schedule_data');

      if (savedData != null && savedData.isNotEmpty) {
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
        _loadSampleData();
      }
    } catch (e) {
      print("Error loading saved data: $e");
      _loadSampleData();
    }
  }

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
    final sampleData = [
      WorkEvent.fromCsv('2025-06-16', '08:00-12:00 | 14:00-18:00', 'Bureau Principal', 'Réunion matin, formation après-midi'),
      WorkEvent.fromCsv('2025-06-17', '09:00-17:00', 'Site A', 'Formation, Supervision'),
      WorkEvent.fromCsv('2025-06-18', '08:30-12:30 puis 14:00-16:30', 'Bureau Principal', 'Planification matin, suivi projets après-midi'),
      WorkEvent.fromCsv('2025-06-19', '10:00-15:00 / 18:00-22:00', 'Site B', 'Contrôle qualité jour, audit nuit'),
      WorkEvent.fromCsv('2025-06-20', '08:00-16:00', 'Bureau Principal', 'Réunions clients, Documentation'),
      WorkEvent.fromCsv('2025-06-21', '09:00-13:00', 'Domicile', 'Travail à distance, Rapports'),
      WorkEvent.fromCsv('2025-06-22', 'Repos', 'Congé', 'Jour de repos'),
      WorkEvent.fromCsv('2025-06-23', '09:00-17:00', 'Site A', 'Maintenance, Inspection'),
      WorkEvent.fromCsv('2025-06-24', '08:00-16:00', 'Bureau Principal', 'Analyse données, Présentation'),
      WorkEvent.fromCsv('2025-06-25', '14:00-22:00', 'Site C', 'Équipe de nuit, Surveillance'),
      WorkEvent.fromCsv('2025-06-26', '08:30-16:30', 'Bureau Principal', 'Formation nouveaux employés'),
      WorkEvent.fromCsv('2025-06-27', '07:00-15:00', 'Site A', 'Ouverture, Coordination équipes'),
      WorkEvent.fromCsv('2025-06-28', '10:00-14:00', 'Site B', 'Maintenance weekend, Garde'),
      WorkEvent.fromCsv('2025-06-29', 'Repos', 'Congé', 'Jour de repos'),
    ];

    setState(() {
      scheduleData = sampleData;
      _organizeWeeks();
    });
  }

  void _organizeWeeks() {
    Map<String, List<WorkEvent>> weekMap = {};

    for (var event in scheduleData) {
      try {
        DateTime date = DateTime.parse(event.date);
        DateTime weekStart = _getWeekStart(date);
        String weekKey = DateFormat('yyyy-MM-dd').format(weekStart);

        weekMap[weekKey] ??= [];
        weekMap[weekKey]!.add(event);
      } catch (e) {
        print("Error parsing date ${event.date}: $e");
      }
    }

    List<String> sortedWeeks = weekMap.keys.toList()..sort();
    weeks = sortedWeeks.map((weekKey) {
      List<WorkEvent> weekEvents = weekMap[weekKey]!;
      weekEvents.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      return weekEvents;
    }).toList();

    _findTodayWeek();

    if (mounted) {
      setState(() {});
    }
  }

  void _findTodayWeek() {
    DateTime today = DateTime.now();
    todayWeek = 0;
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

        csvContent = csvContent.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

        List<String> lines = csvContent.split('\n');

        if (lines.length < 2) {
          throw Exception('Fichier CSV invalide - pas assez de lignes');
        }

        List<String> headers = lines[0].split(',').map((h) => h.trim().toLowerCase()).toList();

        List<WorkEvent> events = [];
        List<String> parseWarnings = [];

        for (int i = 1; i < lines.length; i++) {
          String line = lines[i].trim();
          if (line.isEmpty) continue;

          List<String> values = _parseCSVLine(line);

          if (values.length >= 4) {
            String date = values[0].trim();
            String horaire = values[1].trim();
            String poste = values[2].trim();
            String taches = values[3].trim();

            if (date.isNotEmpty && date != 'date') {
              try {
                WorkEvent event = WorkEvent.fromCsv(date, horaire, poste, taches);

                if (event.hasMultipleTimeSlots) {
                  print('✓ Horaire multiple détecté pour ${date}: ${event.timeSlots?.length} créneaux');
                }

                events.add(event);
              } catch (e) {
                parseWarnings.add('Ligne ${i + 1}: ${e.toString()}');
                print('Warning parsing line ${i + 1}: $e');
              }
            }
          } else {
            parseWarnings.add('Ligne ${i + 1}: Format invalide (${values.length} colonnes trouvées, 4 attendues)');
          }
        }

        setState(() {
          scheduleData = events;
          _organizeWeeks();
        });

        await _saveData();

        if (mounted) {
          String message = '${events.length} événements chargés avec succès!';
          int multipleSchedules = events.where((e) => e.hasMultipleTimeSlots).length;

          if (multipleSchedules > 0) {
            message += '\n$multipleSchedules journées avec horaires multiples détectées.';
          }

          if (parseWarnings.isNotEmpty && parseWarnings.length <= 3) {
            message += '\n\nAvertissements:\n${parseWarnings.join('\n')}';
          } else if (parseWarnings.length > 3) {
            message += '\n\n${parseWarnings.length} avertissements (voir console)';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: Duration(seconds: parseWarnings.isNotEmpty ? 6 : 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<String> _parseCSVLine(String line) {
    List<String> result = [];
    StringBuffer currentField = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      String char = line[i];

      if (char == '"') {
        if (i + 1 < line.length && line[i + 1] == '"') {
          currentField.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(currentField.toString());
        currentField.clear();
      } else {
        currentField.write(char);
      }
    }

    result.add(currentField.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)]
                : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
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
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Planning de Travail',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('MMMM yyyy', 'fr_FR').format(currentDate),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[700] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: IconButton(
                              onPressed: widget.onThemeToggle,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  isDark ? Icons.light_mode : Icons.dark_mode,
                                  key: ValueKey(isDark),
                                  color: isDark ? Colors.yellow[600] : Colors.indigo[600],
                                  size: 14,
                                ),
                              ),
                              tooltip: isDark ? 'Mode clair' : 'Mode sombre',
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickAndLoadCSV,
                            icon: const Icon(Icons.upload_file, size: 18),
                            label: const Text('Importer CSV'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.blue[800] : Colors.blue[100],
                              foregroundColor: isDark ? Colors.blue[200] : Colors.blue[700],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: weeks.isNotEmpty && currentWeek != todayWeek ? _goToToday : null,
                            icon: const Icon(Icons.today, size: 18),
                            label: const Text("Aujourd'hui"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentWeek == todayWeek
                                  ? (isDark ? Colors.grey[700] : Colors.grey[300])
                                  : (isDark ? Colors.orange[800] : Colors.orange[100]),
                              foregroundColor: currentWeek == todayWeek
                                  ? (isDark ? Colors.grey[400] : Colors.grey[600])
                                  : (isDark ? Colors.orange[200] : Colors.orange[700]),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        if (scheduleData.isNotEmpty)
                          IconButton(
                            onPressed: () => _showResetDialog(),
                            icon: const Icon(Icons.refresh, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: isDark ? Colors.red[800] : Colors.red[100],
                              foregroundColor: isDark ? Colors.red[200] : Colors.red[700],
                            ),
                            tooltip: 'Réinitialiser',
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

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
                            backgroundColor: isDark ? Colors.blue[800] : Colors.blue[100],
                            foregroundColor: isDark ? Colors.blue[200] : Colors.blue[700],
                          ),
                        ),

                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Semaine',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    )
                                ),
                                if (currentWeek == todayWeek) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.green[800] : Colors.green[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Actuelle',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? Colors.green[200] : Colors.green[700],
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
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
                            backgroundColor: isDark ? Colors.blue[800] : Colors.blue[100],
                            foregroundColor: isDark ? Colors.blue[200] : Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: weeks.isNotEmpty && currentWeek < weeks.length
                    ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: weeks[currentWeek].length,
                  itemBuilder: (context, index) {
                    WorkEvent event = weeks[currentWeek][index];
                    return _buildEventCard(event, isDark);
                  },
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 64,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune donnée disponible',
                        style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
                      ),
                      Text(
                        'Importez un fichier CSV pour commencer',
                        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),

              if (weeks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Page ${currentWeek + 1} sur ${weeks.length}',
                        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      ),
                      if (scheduleData.isNotEmpty)
                        Text(
                          '${scheduleData.length} événements chargés',
                          style: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                            fontSize: 12,
                          ),
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

  Widget _buildEventCard(WorkEvent event, bool isDark) {
    DateTime date = DateTime.parse(event.date);
    bool isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == event.date;
    List<TimeSlot> timeSlots = event.parsedTimeSlots;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.grey[700]!, width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec date et badge "Aujourd'hui"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE', 'fr_FR').format(date),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.blue[300] : Colors.blue,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green[800] : Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Aujourd'hui",
                        style: TextStyle(
                          color: isDark ? Colors.green[200] : Colors.green[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  // Badge pour horaires multiples
                  if (event.hasMultipleTimeSlots) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.orange[800] : Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Coupure',
                        style: TextStyle(
                          color: isDark ? Colors.orange[200] : Colors.orange[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Affichage des créneaux horaires
          _buildTimeSlotsSection(timeSlots, isDark),

          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, event.poste, isDark ? Colors.red[300]! : Colors.red, isDark),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.task_alt, event.taches, isDark ? Colors.green[300]! : Colors.green, isDark),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSection(List<TimeSlot> timeSlots, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: isDark ? Colors.blue[300] : Colors.blue),
            const SizedBox(width: 12),
            Text(
              timeSlots.length == 1 ? 'Horaire :' : 'Horaires de la journée :',
              style: TextStyle(
                color: isDark ? Colors.grey[200] : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...timeSlots.map((slot) {
          return Container(
            margin: EdgeInsets.only(left: 28, bottom: timeSlots.length == 1 ? 0 : 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: slot.isRest
                  ? (isDark ? Colors.grey[700] : Colors.grey[100])
                  : (isDark ? Colors.blue[900]?.withValues(alpha: 0.3) : Colors.blue[50]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: slot.isRest
                    ? (isDark ? Colors.grey[600]! : Colors.grey[300]!)
                    : (isDark ? Colors.blue[600]! : Colors.blue[200]!),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: slot.isRest
                        ? (isDark ? Colors.grey[400] : Colors.grey[600])
                        : (isDark ? Colors.blue[300] : Colors.blue[600]),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    slot.displayText,
                    style: TextStyle(
                      color: isDark ? Colors.grey[200] : Colors.black87,
                      fontSize: 14,
                      fontWeight: slot.isRest ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        // Affichage du temps total travaillé (pour tous les créneaux)
        if (timeSlots.any((slot) => !slot.isRest))
          Container(
            margin: EdgeInsets.only(
                left: 28,
                top: timeSlots.length == 1 ? 6 : 8
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? Colors.green[900]?.withValues(alpha: 0.3) : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.green[700]! : Colors.green[200]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 14,
                  color: isDark ? Colors.green[300] : Colors.green[700],
                ),
                const SizedBox(width: 6),
                Text(
                  'Total: ${_calculateTotalHours(timeSlots)}h',
                  style: TextStyle(
                    color: isDark ? Colors.green[300] : Colors.green[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _calculateTotalHours(List<TimeSlot> timeSlots) {
    Duration totalDuration = Duration.zero;

    for (TimeSlot slot in timeSlots) {
      if (!slot.isRest && slot.duration != null) {
        totalDuration += slot.duration!;
      }
    }

    double hours = totalDuration.inMinutes / 60.0;
    return hours.toStringAsFixed(1);
  }

  Widget _buildInfoRow(IconData icon, String text, Color color, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.grey[200] : Colors.black87,
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
  final List<TimeSlot>? timeSlots;

  WorkEvent(this.date, this.horaire, this.poste, this.taches, {this.timeSlots});

  // Getter pour savoir si c'est un horaire multiple
  bool get hasMultipleTimeSlots => timeSlots != null && timeSlots!.length > 1;

  // Getter pour récupérer les créneaux formatés
  List<TimeSlot> get parsedTimeSlots {
    if (timeSlots != null) return timeSlots!;
    return _parseHoraire(horaire);
  }

  // Parser les horaires multiples
  static List<TimeSlot> _parseHoraire(String horaire) {
    List<TimeSlot> slots = [];

    // Gestion du repos
    if (horaire.toLowerCase().contains('repos')) {
      slots.add(TimeSlot('Repos', true));
      return slots;
    }

    // Séparateurs possibles: |, +, puis, et
    List<String> separators = [' | ', ' + ', ' puis ', ' et ', ' / '];

    for (String sep in separators) {
      if (horaire.contains(sep)) {
        List<String> parts = horaire.split(sep);
        for (String part in parts) {
          String trimmed = part.trim();
          if (trimmed.isNotEmpty && _isValidTimeRange(trimmed)) {
            slots.add(TimeSlot(trimmed, false));
          }
        }
        return slots;
      }
    }

    // Horaire simple
    if (_isValidTimeRange(horaire)) {
      slots.add(TimeSlot(horaire, false));
    }

    return slots;
  }

  // Valider un créneau horaire
  static bool _isValidTimeRange(String timeRange) {
    RegExp timePattern = RegExp(r'^\d{1,2}:\d{2}-\d{1,2}:\d{2}');
    return timePattern.hasMatch(timeRange.trim());
  }

  // Factory pour créer depuis CSV avec parsing automatique
  factory WorkEvent.fromCsv(String date, String horaire, String poste, String taches) {
    List<TimeSlot> timeSlots = _parseHoraire(horaire);
    return WorkEvent(date, horaire, poste, taches, timeSlots: timeSlots);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'horaire': horaire,
      'poste': poste,
      'taches': taches,
      'timeSlots': timeSlots?.map((slot) => slot.toJson()).toList(),
    };
  }

  factory WorkEvent.fromJson(Map<String, dynamic> json) {
    List<TimeSlot>? slots;
    if (json['timeSlots'] != null) {
      slots = (json['timeSlots'] as List)
          .map((slot) => TimeSlot.fromJson(slot))
          .toList();
    }

    return WorkEvent(
      json['date'] as String,
      json['horaire'] as String,
      json['poste'] as String,
      json['taches'] as String,
      timeSlots: slots,
    );
  }
}

// Classe pour représenter un créneau horaire
class TimeSlot {
  final String timeRange;
  final bool isRest;

  TimeSlot(this.timeRange, this.isRest);

  // Calculer la durée du créneau
  Duration? get duration {
    if (isRest) return null;

    try {
      List<String> parts = timeRange.split('-');
      if (parts.length == 2) {
        DateTime start = _parseTime(parts[0].trim());
        DateTime end = _parseTime(parts[1].trim());

        // Gestion des horaires de nuit (ex: 22:00-06:00)
        if (end.isBefore(start)) {
          // Ajouter 24h à l'heure de fin
          end = end.add(const Duration(days: 1));
        }

        return end.difference(start);
      }
    } catch (e) {
      print('Error parsing time range: $timeRange');
    }
    return null;
  }

  DateTime _parseTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(2024, 1, 1, hour, minute);
  }

  // Formater pour l'affichage
  String get displayText {
    if (isRest) return timeRange;

    Duration? dur = duration;
    if (dur != null) {
      double hours = dur.inMinutes / 60.0;
      return '$timeRange (${hours.toStringAsFixed(1)}h)';
    }
    return timeRange;
  }

  Map<String, dynamic> toJson() {
    return {
      'timeRange': timeRange,
      'isRest': isRest,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      json['timeRange'] as String,
      json['isRest'] as bool,
    );
  }
}