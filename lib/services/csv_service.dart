import 'dart:io';
import '../models/work_event.dart';

/// Résultat de l'import CSV avec statistiques
class CsvImportResult {
  final List<WorkEvent> events;
  final List<String> warnings;
  final int totalLines;
  final int successfulLines;
  final int multipleScheduleCount;

  const CsvImportResult({
    required this.events,
    required this.warnings,
    required this.totalLines,
    required this.successfulLines,
    required this.multipleScheduleCount,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasMultipleSchedules => multipleScheduleCount > 0;
  double get successRate => totalLines > 0 ? successfulLines / totalLines : 0.0;
}

/// Service de gestion des fichiers CSV
class CsvService {
  static const List<String> _expectedHeaders = ['date', 'horaire', 'poste', 'taches'];

  /// Importe un fichier CSV et retourne les événements
  Future<CsvImportResult> importFromFile(File file) async {
    try {
      final csvContent = await file.readAsString();
      return importFromString(csvContent);
    } catch (e) {
      throw Exception('Erreur lors de la lecture du fichier: $e');
    }
  }

  /// Importe depuis une chaîne CSV
  CsvImportResult importFromString(String csvContent) {
    // Normaliser les fins de ligne
    final normalizedContent = csvContent
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();

    final lines = normalizedContent.split('\n');

    if (lines.length < 2) {
      throw Exception('Fichier CSV invalide - pas assez de lignes (minimum 2)');
    }

    // Vérifier les en-têtes
    final headers = _parseCSVLine(lines[0])
        .map((h) => h.trim().toLowerCase())
        .toList();

    _validateHeaders(headers);

    // Parser les données
    final events = <WorkEvent>[];
    final warnings = <String>[];
    int successfulLines = 0;
    int multipleScheduleCount = 0;

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final event = _parseLine(line, i + 1);
        events.add(event);
        successfulLines++;

        if (event.hasMultipleTimeSlots) {
          multipleScheduleCount++;
          print('✓ Horaire multiple détecté ligne ${i + 1}: ${event.timeSlots.length} créneaux');
        }
      } catch (e) {
        warnings.add('Ligne ${i + 1}: $e');
        print('⚠️ Avertissement ligne ${i + 1}: $e');
      }
    }

    if (events.isEmpty) {
      throw Exception('Aucun événement valide trouvé dans le fichier');
    }

    return CsvImportResult(
      events: events,
      warnings: warnings,
      totalLines: lines.length - 1, // Exclure l'en-tête
      successfulLines: successfulLines,
      multipleScheduleCount: multipleScheduleCount,
    );
  }

  /// Valide les en-têtes du CSV
  void _validateHeaders(List<String> headers) {
    final missingHeaders = <String>[];

    for (final expectedHeader in _expectedHeaders) {
      if (!headers.contains(expectedHeader)) {
        missingHeaders.add(expectedHeader);
      }
    }

    if (missingHeaders.isNotEmpty) {
      throw Exception(
          'En-têtes manquants: ${missingHeaders.join(', ')}\n'
              'En-têtes trouvés: ${headers.join(', ')}\n'
              'En-têtes attendus: ${_expectedHeaders.join(', ')}'
      );
    }
  }

  /// Parse une ligne de données CSV
  WorkEvent _parseLine(String line, int lineNumber) {
    final values = _parseCSVLine(line);

    if (values.length < 4) {
      throw Exception('Format invalide (${values.length} colonnes trouvées, 4 attendues)');
    }

    final date = values[0].trim();
    final horaire = values[1].trim();
    final poste = values[2].trim();
    final taches = values[3].trim();

    // Validation des champs
    if (date.isEmpty || date.toLowerCase() == 'date') {
      throw Exception('Date vide ou invalide');
    }

    if (horaire.isEmpty) {
      throw Exception('Horaire vide');
    }

    if (poste.isEmpty) {
      throw Exception('Poste vide');
    }

    // Validation du format de date
    try {
      DateTime.parse(date);
    } catch (e) {
      throw Exception('Format de date invalide: $date (attendu: YYYY-MM-DD)');
    }

    return WorkEvent.fromCsv(
      date: date,
      horaire: horaire,
      poste: poste,
      taches: taches,
    );
  }

  /// Parse une ligne CSV en gérant les guillemets et virgules
  List<String> _parseCSVLine(String line) {
    final result = <String>[];
    final currentField = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        // Gestion des guillemets doublés
        if (i + 1 < line.length && line[i + 1] == '"') {
          currentField.write('"');
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        // Fin de champ
        result.add(currentField.toString());
        currentField.clear();
      } else {
        currentField.write(char);
      }
    }

    // Ajouter le dernier champ
    result.add(currentField.toString());
    return result;
  }

  /// Génère un fichier CSV exemple
  String generateSampleCsv() {
    final buffer = StringBuffer();

    // En-têtes
    buffer.writeln('date,horaire,poste,taches');

    // Données d'exemple
    final sampleData = [
      ['2025-06-16', '"08:00-12:00 | 14:00-18:00"', 'Bureau Principal', '"Réunion matin, formation après-midi"'],
      ['2025-06-17', '09:00-17:00', 'Site A', 'Formation continue'],
      ['2025-06-18', '08:30-12:30 puis 14:00-16:30', 'Bureau Principal', '"Planification matin, suivi projets après-midi"'],
      ['2025-06-19', '10:00-15:00 / 18:00-22:00', 'Site B', '"Contrôle qualité jour, audit nuit"'],
      ['2025-06-20', '08:00-16:00', 'Bureau Principal', 'Réunions clients'],
      ['2025-06-21', '09:00-13:00', 'Domicile', 'Travail à distance'],
      ['2025-06-22', 'Repos', 'Congé', 'Jour de repos'],
      ['2025-06-23', '22:00-06:00', 'Site C', 'Équipe de nuit (8h)'],
      ['2025-06-24', '07:00-11:00 + 13:00-17:00', 'Site A', 'Double vacation'],
    ];

    for (final row in sampleData) {
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  /// Exporte une liste d'événements vers CSV
  String exportToCsv(List<WorkEvent> events) {
    final buffer = StringBuffer();

    // En-têtes
    buffer.writeln('date,horaire,poste,taches');

    // Données
    for (final event in events) {
      final escapedPoste = _escapeCSVField(event.poste);
      final escapedTaches = _escapeCSVField(event.taches);
      final escapedHoraire = _escapeCSVField(event.horaire);

      buffer.writeln('${event.date},$escapedHoraire,$escapedPoste,$escapedTaches');
    }

    return buffer.toString();
  }

  /// Échappe un champ CSV si nécessaire
  String _escapeCSVField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      // Doubler les guillemets et entourer de guillemets
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }

  /// Valide un fichier CSV sans l'importer complètement
  Future<bool> validateCsvFile(File file) async {
    try {
      final csvContent = await file.readAsString();
      final lines = csvContent.split('\n');

      if (lines.length < 2) return false;

      final headers = _parseCSVLine(lines[0])
          .map((h) => h.trim().toLowerCase())
          .toList();

      _validateHeaders(headers);
      return true;
    } catch (e) {
      print('Validation échouée: $e');
      return false;
    }
  }
}