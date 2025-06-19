import 'dart:convert';

/// Représente un créneau horaire individuel
class TimeSlot {
  final String timeRange;
  final bool isRest;

  const TimeSlot(this.timeRange, this.isRest);

  /// Calcule la durée du créneau
  Duration? get duration {
    if (isRest) return null;

    try {
      final parts = timeRange.split('-');
      if (parts.length == 2) {
        final start = _parseTime(parts[0].trim());
        final end = _parseTime(parts[1].trim());

        // Gestion des horaires de nuit (ex: 22:00-06:00)
        if (end.isBefore(start)) {
          // Ajouter 24h à l'heure de fin
          return end.add(const Duration(days: 1)).difference(start);
        }

        return end.difference(start);
      }
    } catch (e) {
      print('Erreur lors du parsing de la durée: $timeRange - $e');
    }
    return null;
  }

  /// Parse une chaîne de temps au format HH:MM
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2024, 1, 1, hour, minute);
  }

  /// Texte formaté pour l'affichage avec durée
  String get displayText {
    if (isRest) return timeRange;

    final dur = duration;
    if (dur != null) {
      final hours = dur.inMinutes / 60.0;
      return '$timeRange (${hours.toStringAsFixed(1)}h)';
    }
    return timeRange;
  }

  /// Durée en heures sous forme de double
  double get hoursAsDouble {
    final dur = duration;
    return dur != null ? dur.inMinutes / 60.0 : 0.0;
  }

  /// Vérifie si le créneau est valide
  bool get isValid {
    if (isRest) return true;
    return _isValidTimeRange(timeRange);
  }

  /// Valide un créneau horaire au format HH:MM-HH:MM
  static bool _isValidTimeRange(String timeRange) {
    final timePattern = RegExp(r'^\d{1,2}:\d{2}-\d{1,2}:\d{2}$');
    return timePattern.hasMatch(timeRange.trim());
  }

  /// Crée un TimeSlot pour une période de repos
  static TimeSlot rest([String label = 'Repos']) {
    return TimeSlot(label, true);
  }

  /// Parse une chaîne d'horaires pour créer une liste de TimeSlots
  static List<TimeSlot> parseHoraires(String horaire) {
    final slots = <TimeSlot>[];

    // Gestion du repos
    if (horaire.toLowerCase().contains('repos')) {
      slots.add(TimeSlot.rest());
      return slots;
    }

    // Séparateurs possibles pour horaires multiples
    const separators = [' | ', ' + ', ' puis ', ' et ', ' / '];

    // Chercher un séparateur
    for (final sep in separators) {
      if (horaire.contains(sep)) {
        final parts = horaire.split(sep);
        for (final part in parts) {
          final trimmed = part.trim();
          if (trimmed.isNotEmpty && _isValidTimeRange(trimmed)) {
            slots.add(TimeSlot(trimmed, false));
          }
        }
        return slots;
      }
    }

    // Horaire simple
    if (_isValidTimeRange(horaire.trim())) {
      slots.add(TimeSlot(horaire.trim(), false));
    }

    return slots;
  }

  /// Calcule le temps total de travail pour une liste de créneaux
  static Duration calculateTotalWorkTime(List<TimeSlot> slots) {
    Duration total = Duration.zero;

    for (final slot in slots) {
      if (!slot.isRest && slot.duration != null) {
        total += slot.duration!;
      }
    }

    return total;
  }

  /// Formate une durée en heures avec décimales
  static String formatDuration(Duration duration) {
    final hours = duration.inMinutes / 60.0;
    return '${hours.toStringAsFixed(1)}h';
  }

  // Sérialisation JSON
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

  @override
  String toString() {
    return 'TimeSlot(timeRange: $timeRange, isRest: $isRest, duration: ${duration?.inMinutes}min)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.timeRange == timeRange &&
        other.isRest == isRest;
  }

  @override
  int get hashCode => timeRange.hashCode ^ isRest.hashCode;
}