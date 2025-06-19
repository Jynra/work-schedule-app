import 'time_slot.dart';

/// Représente un événement de travail avec ses détails
class WorkEvent {
  final String date;
  final String horaire;
  final String poste;
  final String taches;
  final List<TimeSlot>? _timeSlots;

  const WorkEvent({
    required this.date,
    required this.horaire,
    required this.poste,
    required this.taches,
    List<TimeSlot>? timeSlots,
  }) : _timeSlots = timeSlots;

  /// Factory pour créer un WorkEvent depuis des données CSV
  factory WorkEvent.fromCsv({
    required String date,
    required String horaire,
    required String poste,
    required String taches,
  }) {
    final timeSlots = TimeSlot.parseHoraires(horaire);
    return WorkEvent(
      date: date,
      horaire: horaire,
      poste: poste,
      taches: taches,
      timeSlots: timeSlots,
    );
  }

  /// Récupère les créneaux horaires (parsés à la demande si nécessaire)
  List<TimeSlot> get timeSlots {
    return _timeSlots ?? TimeSlot.parseHoraires(horaire);
  }

  /// Vérifie si l'événement a plusieurs créneaux horaires
  bool get hasMultipleTimeSlots {
    return timeSlots.length > 1;
  }

  /// Vérifie si c'est un jour de repos
  bool get isRestDay {
    return timeSlots.any((slot) => slot.isRest);
  }

  /// Calcule le temps total de travail pour cet événement
  Duration get totalWorkTime {
    return TimeSlot.calculateTotalWorkTime(timeSlots);
  }

  /// Retourne le temps total formaté en heures
  String get formattedTotalTime {
    return TimeSlot.formatDuration(totalWorkTime);
  }

  /// Vérifie si l'événement correspond à aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    final eventDate = DateTime.tryParse(date);
    if (eventDate == null) return false;

    return now.year == eventDate.year &&
        now.month == eventDate.month &&
        now.day == eventDate.day;
  }

  /// Parse la date de l'événement
  DateTime? get parsedDate {
    try {
      return DateTime.parse(date);
    } catch (e) {
      print('Erreur lors du parsing de la date: $date - $e');
      return null;
    }
  }

  /// Valide les données de l'événement
  bool get isValid {
    // Vérifier la date
    if (parsedDate == null) return false;

    // Vérifier les champs obligatoires
    if (date.isEmpty || horaire.isEmpty || poste.isEmpty) return false;

    // Vérifier que les créneaux sont valides
    return timeSlots.every((slot) => slot.isValid);
  }

  /// Crée une copie de l'événement avec des modifications
  WorkEvent copyWith({
    String? date,
    String? horaire,
    String? poste,
    String? taches,
    List<TimeSlot>? timeSlots,
  }) {
    return WorkEvent(
      date: date ?? this.date,
      horaire: horaire ?? this.horaire,
      poste: poste ?? this.poste,
      taches: taches ?? this.taches,
      timeSlots: timeSlots ?? _timeSlots,
    );
  }

  // Sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'horaire': horaire,
      'poste': poste,
      'taches': taches,
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  factory WorkEvent.fromJson(Map<String, dynamic> json) {
    List<TimeSlot>? slots;
    if (json['timeSlots'] != null) {
      slots = (json['timeSlots'] as List)
          .map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>))
          .toList();
    }

    return WorkEvent(
      date: json['date'] as String,
      horaire: json['horaire'] as String,
      poste: json['poste'] as String,
      taches: json['taches'] as String,
      timeSlots: slots,
    );
  }

  @override
  String toString() {
    return 'WorkEvent(date: $date, horaire: $horaire, poste: $poste, '
        'hasMultiple: $hasMultipleTimeSlots, totalTime: $formattedTotalTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkEvent &&
        other.date == date &&
        other.horaire == horaire &&
        other.poste == poste &&
        other.taches == taches;
  }

  @override
  int get hashCode {
    return date.hashCode ^
    horaire.hashCode ^
    poste.hashCode ^
    taches.hashCode;
  }
}