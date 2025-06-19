import 'package:flutter/material.dart';

/// Constantes de l'application
class AppConstants {
  // Informations de l'application
  static const String appName = 'Planning de Travail';
  static const String appVersion = '1.4.0';
  static const String appDescription = 'Gestion des plannings de travail avec horaires multiples';

  // Clés de stockage
  static const String scheduleDataKey = 'schedule_data';
  static const String themeKey = 'is_dark_mode';
  static const String backupPrefix = 'schedule_data_backup_';

  // Formats de fichiers
  static const List<String> supportedFileExtensions = ['csv'];
  static const String csvMimeType = 'text/csv';

  // Colonnes CSV
  static const List<String> csvHeaders = ['date', 'horaire', 'poste', 'taches'];
  static const String dateHeader = 'date';
  static const String horaireHeader = 'horaire';
  static const String posteHeader = 'poste';
  static const String tachesHeader = 'taches';

  // Séparateurs pour horaires multiples
  static const List<String> timeSeparators = [' | ', ' + ', ' puis ', ' et ', ' / '];

  // Messages d'erreur
  static const String fileNotFoundError = 'Fichier non trouvé';
  static const String invalidFileFormatError = 'Format de fichier invalide';
  static const String csvParsingError = 'Erreur lors de l\'analyse du fichier CSV';
  static const String storageError = 'Erreur de sauvegarde des données';
  static const String networkError = 'Erreur de connexion réseau';

  // Messages de succès
  static const String dataLoadedSuccess = 'Données chargées avec succès';
  static const String dataSavedSuccess = 'Données sauvegardées avec succès';
  static const String csvImportedSuccess = 'Fichier CSV importé avec succès';
  static const String themeChangedSuccess = 'Thème modifié';

  // Paramètres par défaut
  static const int maxBackupsCount = 5;
  static const int autoSaveIntervalSeconds = 30;
  static const Duration splashScreenDuration = Duration(seconds: 2);

  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Interface utilisateur
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 16.0;

  // Limites
  static const int maxEventsPerDay = 10;
  static const int maxTimeSlots = 5;
  static const int maxCsvFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxEventTitleLength = 100;
  static const int maxEventDescriptionLength = 500;
}

/// Couleurs personnalisées de l'application
class AppColors {
  // Couleurs principales - Mode clair
  static const Color primaryLight = Color(0xFF1976D2);
  static const Color primaryLightVariant = Color(0xFF1565C0);
  static const Color secondaryLight = Color(0xFF03DAC6);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Couleurs principales - Mode sombre
  static const Color primaryDark = Color(0xFF90CAF9);
  static const Color primaryDarkVariant = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF03DAC6);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Couleurs fonctionnelles
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Couleurs des badges
  static const Color todayBadgeLight = Color(0xFFE8F5E8);
  static const Color todayBadgeDark = Color(0xFF1B5E20);
  static const Color currentWeekBadgeLight = Color(0xFFE3F2FD);
  static const Color currentWeekBadgeDark = Color(0xFF0D47A1);
  static const Color multipleBadgeLight = Color(0xFFFFF3E0);
  static const Color multipleBadgeDark = Color(0xFFE65100);

  // Dégradés
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
  );
}

/// Styles de texte de l'application
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );
}

/// Icônes personnalisées de l'application
class AppIcons {
  // Icônes principales
  static const IconData schedule = Icons.schedule;
  static const IconData calendar = Icons.calendar_today;
  static const IconData time = Icons.access_time;
  static const IconData location = Icons.location_on;
  static const IconData tasks = Icons.task_alt;

  // Actions
  static const IconData import = Icons.upload_file;
  static const IconData export = Icons.download;
  static const IconData save = Icons.save;
  static const IconData delete = Icons.delete;
  static const IconData edit = Icons.edit;

  // Navigation
  static const IconData previous = Icons.chevron_left;
  static const IconData next = Icons.chevron_right;
  static const IconData today = Icons.today;
  static const IconData refresh = Icons.refresh;

  // Thèmes
  static const IconData lightMode = Icons.light_mode;
  static const IconData darkMode = Icons.dark_mode;

  // États
  static const IconData success = Icons.check_circle;
  static const IconData warning = Icons.warning;
  static const IconData error = Icons.error;
  static const IconData info = Icons.info;
}

/// Dimensions de l'interface utilisateur
class AppDimensions {
  // Espacements
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Rayons de bordure
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Tailles d'icônes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;

  // Hauteurs des widgets
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double cardMinHeight = 120.0;
  static const double headerHeight = 200.0;

  // Largeurs
  static const double maxContentWidth = 600.0;
  static const double minButtonWidth = 120.0;
  static const double badgeMinWidth = 60.0;
}

/// Regex patterns utilisés dans l'application
class AppPatterns {
  // Format de date YYYY-MM-DD
  static final RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  // Format d'heure HH:MM
  static final RegExp timePattern = RegExp(r'^\d{1,2}:\d{2}');

  // Format de plage horaire HH:MM-HH:MM
  static final RegExp timeRangePattern = RegExp(r'^\d{1,2}:\d{2}-\d{1,2}:\d{2}');

  // Email simple
  static final RegExp emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  // Numéro de téléphone français
  static final RegExp phonePattern = RegExp(r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}');
}

/// Données d'exemple pour les tests et démo
class SampleData {
  static const List<Map<String, String>> sampleEvents = [
    {
      'date': '2025-06-16',
      'horaire': '08:00-12:00 | 14:00-18:00',
      'poste': 'Bureau Principal',
      'taches': 'Réunion matin, formation après-midi'
    },
    {
      'date': '2025-06-17',
      'horaire': '09:00-17:00',
      'poste': 'Site A',
      'taches': 'Formation, Supervision'
    },
    {
      'date': '2025-06-18',
      'horaire': '08:30-12:30 puis 14:00-16:30',
      'poste': 'Bureau Principal',
      'taches': 'Planification matin, suivi projets après-midi'
    },
    {
      'date': '2025-06-19',
      'horaire': '10:00-15:00 / 18:00-22:00',
      'poste': 'Site B',
      'taches': 'Contrôle qualité jour, audit nuit'
    },
    {
      'date': '2025-06-20',
      'horaire': '08:00-16:00',
      'poste': 'Bureau Principal',
      'taches': 'Réunions clients, Documentation'
    },
    {
      'date': '2025-06-21',
      'horaire': '09:00-13:00',
      'poste': 'Domicile',
      'taches': 'Travail à distance, Rapports'
    },
    {
      'date': '2025-06-22',
      'horaire': 'Repos',
      'poste': 'Congé',
      'taches': 'Jour de repos'
    },
    {
      'date': '2025-06-23',
      'horaire': '22:00-06:00',
      'poste': 'Site C',
      'taches': 'Équipe de nuit (8h)'
    },
    {
      'date': '2025-06-24',
      'horaire': '07:00-11:00 + 13:00-17:00',
      'poste': 'Site A',
      'taches': 'Double vacation'
    },
  ];

  static const String sampleCsvContent = '''date,horaire,poste,taches
2025-06-16,"08:00-12:00 | 14:00-18:00",Bureau Principal,"Réunion matin, formation après-midi"
2025-06-17,09:00-17:00,Site A,Formation continue
2025-06-18,08:30-12:30 puis 14:00-16:30,Bureau Principal,"Planification matin, suivi projets après-midi"
2025-06-19,10:00-15:00 / 18:00-22:00,Site B,"Contrôle qualité jour, audit nuit"
2025-06-20,08:00-16:00,Bureau Principal,Réunions clients
2025-06-21,09:00-13:00,Domicile,Travail à distance
2025-06-22,Repos,Congé,Jour de repos
2025-06-23,22:00-06:00,Site C,Équipe de nuit (8h)
2025-06-24,07:00-11:00 + 13:00-17:00,Site A,Double vacation''';
}

/// URLs et liens utiles
class AppUrls {
  static const String githubRepo = 'https://github.com/Jynra/work-schedule-app';
  static const String documentation = 'https://github.com/Jynra/work-schedule-app/blob/main/README.md';
  static const String bugReport = 'https://github.com/Jynra/work-schedule-app/issues';
  static const String flutterDocs = 'https://flutter.dev/docs';
  static const String materialDesign = 'https://material.io/design';
}

/// Configuration de l'environnement
class AppConfig {
  static const bool isDebugMode = true; // À modifier selon l'environnement
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  // URLs d'API (pour futures fonctionnalités)
  static const String apiBaseUrl = 'https://api.example.com';
  static const String syncEndpoint = '/sync';
  static const String backupEndpoint = '/backup';

  // Limites de performance
  static const int maxConcurrentOperations = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration cacheExpiration = Duration(hours: 24);
}