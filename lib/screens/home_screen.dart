import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../models/work_event.dart';
import '../services/storage_service.dart';
import '../services/csv_service.dart';
import '../utils/date_utils.dart' as date_utils;
import '../utils/constants.dart';
import '../widgets/header_widget.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  final CsvService _csvService = CsvService();

  List<WorkEvent> _scheduleData = [];
  List<List<WorkEvent>> _weeks = [];
  int _currentWeek = 0;
  int _todayWeek = 0;
  DateTime _currentDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Charge les données sauvegardées ou les données d'exemple
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final savedEvents = await _storageService.loadScheduleData();

      if (savedEvents != null && savedEvents.isNotEmpty) {
        setState(() {
          _scheduleData = savedEvents;
          _organizeWeeks();
          _isLoading = false;
        });

        _showSnackBar('${savedEvents.length} événements chargés');
      } else {
        _loadSampleData();
      }
    } catch (e) {
      print('Erreur lors du chargement: $e');
      _loadSampleData();
    }
  }

  /// Charge les données d'exemple
  void _loadSampleData() {
    final sampleEvents = SampleData.sampleEvents.map((data) =>
        WorkEvent.fromCsv(
          date: data['date']!,
          horaire: data['horaire']!,
          poste: data['poste']!,
          taches: data['taches']!,
        )
    ).toList();

    setState(() {
      _scheduleData = sampleEvents;
      _organizeWeeks();
      _isLoading = false;
    });
  }

  /// Organise les événements par semaines
  void _organizeWeeks() {
    final Map<String, List<WorkEvent>> weekMap = {};

    for (final event in _scheduleData) {
      final eventDate = event.parsedDate;
      if (eventDate == null) continue;

      final weekStart = date_utils.DateUtils.getWeekStart(eventDate);
      final weekKey = date_utils.DateUtils.formatDate(weekStart);

      weekMap[weekKey] ??= [];
      weekMap[weekKey]!.add(event);
    }

    final sortedWeeks = weekMap.keys.toList()..sort();
    _weeks = sortedWeeks.map((weekKey) {
      final weekEvents = weekMap[weekKey]!;
      weekEvents.sort((a, b) {
        final dateA = a.parsedDate ?? DateTime.now();
        final dateB = b.parsedDate ?? DateTime.now();
        return dateA.compareTo(dateB);
      });
      return weekEvents;
    }).toList();

    _findTodayWeek();
  }

  /// Trouve la semaine actuelle
  void _findTodayWeek() {
    final today = DateTime.now();
    _todayWeek = 0;
    _currentWeek = 0;

    for (int i = 0; i < _weeks.length; i++) {
      final weekEvents = _weeks[i];
      if (weekEvents.isEmpty) continue;

      final firstEventDate = weekEvents.first.parsedDate;
      if (firstEventDate == null) continue;

      if (date_utils.DateUtils.isCurrentWeek(firstEventDate)) {
        _todayWeek = i;
        _currentWeek = i;
        break;
      }
    }
  }

  /// Navigue vers la semaine courante
  void _goToToday() {
    setState(() {
      _currentWeek = _todayWeek;
    });
  }

  /// Navigue vers la semaine précédente
  void _previousWeek() {
    if (_currentWeek > 0) {
      setState(() {
        _currentWeek--;
      });
    }
  }

  /// Navigue vers la semaine suivante
  void _nextWeek() {
    if (_currentWeek < _weeks.length - 1) {
      setState(() {
        _currentWeek++;
      });
    }
  }

  /// Affiche le dialogue de confirmation pour la réinitialisation
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser le planning'),
        content: const Text(
          'Voulez-vous effacer le planning actuel et revenir aux données d\'exemple ?\n\n'
              'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _resetData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
  }

  /// Réinitialise les données avec les données d'exemple
  Future<void> _resetData() async {
    try {
      await _storageService.clearScheduleData();
      _loadSampleData();
      _showSnackBar('Planning réinitialisé avec les données d\'exemple');
    } catch (e) {
      _showSnackBar('Erreur lors de la réinitialisation: $e', isError: true);
    }
  }

  /// Importe un fichier CSV
  Future<void> _importCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.supportedFileExtensions,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final importResult = await _csvService.importFromFile(file);

        setState(() {
          _scheduleData = importResult.events;
          _organizeWeeks();
        });

        await _storageService.saveScheduleData(importResult.events);
        _showImportSuccess(importResult);
      }
    } catch (e) {
      _showSnackBar('Erreur lors de l\'importation: $e', isError: true);
    }
  }

  /// Affiche le message de succès d'importation
  void _showImportSuccess(CsvImportResult result) {
    String message = '${result.events.length} événements importés avec succès!';

    if (result.hasMultipleSchedules) {
      message += '\n${result.multipleScheduleCount} journées avec horaires multiples détectées.';
    }

    if (result.hasWarnings && result.warnings.length <= 3) {
      message += '\n\nAvertissements:\n${result.warnings.join('\n')}';
    } else if (result.warnings.length > 3) {
      message += '\n\n${result.warnings.length} avertissements (voir console)';
    }

    _showSnackBar(
      message,
      duration: Duration(seconds: result.hasWarnings ? 6 : 3),
    );
  }

  /// Affiche un message SnackBar
  void _showSnackBar(String message, {bool isError = false, Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Obtient la plage de dates de la semaine actuelle
  String _getCurrentWeekRange() {
    if (_weeks.isEmpty || _currentWeek >= _weeks.length) {
      return 'Aucune donnée';
    }

    final weekEvents = _weeks[_currentWeek];
    if (weekEvents.isEmpty) return 'Semaine vide';

    // Récupérer toutes les dates des événements de cette semaine
    final dates = weekEvents
        .map((event) => event.parsedDate)
        .where((date) => date != null)
        .cast<DateTime>()
        .toList();

    if (dates.isEmpty) return 'Dates invalides';

    // Trier les dates
    dates.sort();
    final firstDate = dates.first;
    final lastDate = dates.last;

    // Si c'est le même jour
    if (date_utils.DateUtils.formatDate(firstDate) ==
        date_utils.DateUtils.formatDate(lastDate)) {
      return '${firstDate.day} ${date_utils.DateUtils.monthFormat.format(firstDate)}';
    }

    // Si c'est le même mois
    if (firstDate.month == lastDate.month) {
      return '${firstDate.day} - ${lastDate.day} ${date_utils.DateUtils.monthFormat.format(firstDate)}';
    }

    // Mois différents
    return '${firstDate.day} ${date_utils.DateUtils.monthFormat.format(firstDate)} - '
        '${lastDate.day} ${date_utils.DateUtils.monthFormat.format(lastDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: widget.isDarkMode
              ? AppColors.darkGradient
              : AppColors.lightGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec navigation
              HeaderWidget(
                currentDate: _currentDate,
                isDarkMode: widget.isDarkMode,
                onThemeToggle: widget.onThemeToggle,
                onImportCsv: _importCsv,
                onGoToToday: _weeks.isNotEmpty && _currentWeek != _todayWeek
                    ? _goToToday
                    : null,
                onReset: _scheduleData.isNotEmpty ? _showResetDialog : null,
                onPreviousWeek: _currentWeek > 0 ? _previousWeek : null,
                onNextWeek: _currentWeek < _weeks.length - 1 ? _nextWeek : null,
                weekRange: _getCurrentWeekRange(),
                isCurrentWeek: _currentWeek == _todayWeek,
              ),

              // Contenu principal
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildContent(),
              ),

              // Footer avec informations
              if (_weeks.isNotEmpty) _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit le contenu principal
  Widget _buildContent() {
    if (_weeks.isEmpty) {
      return _buildEmptyState();
    }

    if (_currentWeek >= _weeks.length) {
      return _buildErrorState('Index de semaine invalide');
    }

    final currentWeekEvents = _weeks[_currentWeek];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      itemCount: currentWeekEvents.length,
      itemBuilder: (context, index) {
        return EventCard(
          event: currentWeekEvents[index],
          isDarkMode: widget.isDarkMode,
        );
      },
    );
  }

  /// Construit l'état vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.calendar,
            size: 64,
            color: widget.isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Text(
            'Aucune donnée disponible',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.grey[300] : Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'Importez un fichier CSV pour commencer',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'état d'erreur
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.error,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Text(
            'Erreur',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            error,
            style: TextStyle(
              color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construit le footer avec les informations
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Page ${_currentWeek + 1} sur ${_weeks.length}',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          if (_scheduleData.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              '${_scheduleData.length} événements chargés',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.grey[500] : Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}