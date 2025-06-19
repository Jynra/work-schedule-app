import 'package:intl/intl.dart';

/// Utilitaires pour la gestion des dates
class DateUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _weekRangeFormat = DateFormat('d MMM', 'fr_FR');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'fr_FR');
  static final DateFormat _dayNameFormat = DateFormat('EEEE', 'fr_FR');
  static final DateFormat monthFormat = DateFormat('MMM', 'fr_FR'); // Public maintenant

  /// Retourne le début de la semaine (lundi) pour une date donnée
  static DateTime getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  /// Retourne la fin de la semaine (dimanche) pour une date donnée
  static DateTime getWeekEnd(DateTime date) {
    final weekStart = getWeekStart(date);
    return weekStart.add(const Duration(days: 6));
  }

  /// Formate une date au format YYYY-MM-DD
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Parse une date depuis le format YYYY-MM-DD
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si une date correspond à aujourd'hui
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  /// Vérifie si une date est dans la semaine courante
  static bool isCurrentWeek(DateTime date) {
    final now = DateTime.now();
    final currentWeekStart = getWeekStart(now);
    final currentWeekEnd = getWeekEnd(now);

    return date.isAfter(currentWeekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(currentWeekEnd.add(const Duration(days: 1)));
  }

  /// Retourne le nom du jour en français
  static String getDayName(DateTime date) {
    return _dayNameFormat.format(date);
  }

  /// Retourne le mois et l'année en français
  static String getMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Génère une plage de dates pour l'affichage de semaine
  static String getWeekRange(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));

    if (weekStart.month == weekEnd.month) {
      // Même mois: "16 - 22 juin"
      return '${weekStart.day} - ${weekEnd.day} ${_weekRangeFormat.format(weekStart)}';
    } else {
      // Mois différents: "26 mai - 1 juin"
      final startMonth = DateFormat('MMM', 'fr_FR').format(weekStart);
      final endMonth = DateFormat('MMM', 'fr_FR').format(weekEnd);
      return '${weekStart.day} $startMonth - ${weekEnd.day} $endMonth';
    }
  }

  /// Génère toutes les dates d'une semaine (lundi à dimanche)
  static List<DateTime> getWeekDates(DateTime weekStart) {
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  /// Trouve la semaine contenant une date spécifique dans une liste de dates
  static int findWeekIndex(List<DateTime> dates, DateTime targetDate) {
    final targetWeekStart = getWeekStart(targetDate);

    for (int i = 0; i < dates.length; i++) {
      final dateWeekStart = getWeekStart(dates[i]);
      if (dateWeekStart.isAtSameMomentAs(targetWeekStart)) {
        return i ~/ 7; // Diviser par 7 pour obtenir l'index de la semaine
      }
    }

    return 0; // Semaine par défaut
  }

  /// Groupe une liste de dates par semaine
  static Map<DateTime, List<DateTime>> groupByWeek(List<DateTime> dates) {
    final Map<DateTime, List<DateTime>> weeks = {};

    for (final date in dates) {
      final weekStart = getWeekStart(date);
      weeks[weekStart] ??= [];
      weeks[weekStart]!.add(date);
    }

    // Trier les dates dans chaque semaine
    for (final weekDates in weeks.values) {
      weekDates.sort();
    }

    return weeks;
  }

  /// Retourne le nombre de jours entre deux dates
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  /// Retourne le nombre de semaines entre deux dates
  static int weeksBetween(DateTime start, DateTime end) {
    return daysBetween(start, end) ~/ 7;
  }

  /// Ajoute un nombre de semaines à une date
  static DateTime addWeeks(DateTime date, int weeks) {
    return date.add(Duration(days: weeks * 7));
  }

  /// Soustrait un nombre de semaines à une date
  static DateTime subtractWeeks(DateTime date, int weeks) {
    return date.subtract(Duration(days: weeks * 7));
  }

  /// Retourne la première date du mois
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retourne la dernière date du mois
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Vérifie si une année est bissextile
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
  }

  /// Retourne le nombre de jours dans un mois
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Formate une durée en heures et minutes
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return '${minutes}min';
    } else if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    }
  }

  /// Parse une heure au format HH:MM
  static DateTime? parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return DateTime(2024, 1, 1, hour, minute);
    } catch (e) {
      return null;
    }
  }

  /// Formate une heure au format HH:MM
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  /// Retourne une liste de dates pour un mois donné
  static List<DateTime> getDatesInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    return List.generate(
      lastDay.day,
          (index) => DateTime(year, month, index + 1),
    );
  }

  /// Trouve l'index de la semaine actuelle dans une liste de semaines
  static int findCurrentWeekIndex(List<DateTime> weekStarts) {
    final now = DateTime.now();
    final currentWeekStart = getWeekStart(now);

    for (int i = 0; i < weekStarts.length; i++) {
      if (weekStarts[i].isAtSameMomentAs(currentWeekStart)) {
        return i;
      }
    }

    return 0; // Première semaine par défaut
  }
}