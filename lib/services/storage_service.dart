import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/work_event.dart';

/// Service de gestion de la persistance des données
class StorageService {
  static const String _scheduleDataKey = 'schedule_data';

  /// Sauvegarde la liste des événements
  Future<bool> saveScheduleData(List<WorkEvent> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = events.map((event) => event.toJson()).toList();
      final jsonString = json.encode(jsonData);

      final success = await prefs.setString(_scheduleDataKey, jsonString);

      if (success) {
        print('✅ Sauvegarde réussie: ${events.length} événements');
      } else {
        print('❌ Échec de la sauvegarde');
      }

      return success;
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde: $e');
      return false;
    }
  }

  /// Charge la liste des événements sauvegardés
  Future<List<WorkEvent>?> loadScheduleData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_scheduleDataKey);

      if (jsonString == null || jsonString.isEmpty) {
        print('ℹ️ Aucune donnée sauvegardée trouvée');
        return null;
      }

      final jsonData = json.decode(jsonString) as List<dynamic>;
      final events = jsonData
          .map((item) => WorkEvent.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Chargement réussi: ${events.length} événements');
      return events;
    } catch (e) {
      print('❌ Erreur lors du chargement: $e');
      return null;
    }
  }

  /// Vérifie si des données sont sauvegardées
  Future<bool> hasScheduleData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_scheduleDataKey);
      return jsonString != null && jsonString.isNotEmpty;
    } catch (e) {
      print('❌ Erreur lors de la vérification des données: $e');
      return false;
    }
  }

  /// Efface toutes les données sauvegardées
  Future<bool> clearScheduleData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_scheduleDataKey);

      if (success) {
        print('✅ Données effacées avec succès');
      } else {
        print('❌ Échec de l\'effacement des données');
      }

      return success;
    } catch (e) {
      print('❌ Erreur lors de l\'effacement: $e');
      return false;
    }
  }

  /// Obtient la taille des données sauvegardées en octets
  Future<int> getStorageSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_scheduleDataKey);

      if (jsonString == null) return 0;

      return utf8.encode(jsonString).length;
    } catch (e) {
      print('❌ Erreur lors du calcul de la taille: $e');
      return 0;
    }
  }

  /// Sauvegarde un backup des données avec timestamp
  Future<bool> createBackup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentData = prefs.getString(_scheduleDataKey);

      if (currentData == null) {
        print('ℹ️ Aucune donnée à sauvegarder');
        return true;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupKey = '${_scheduleDataKey}_backup_$timestamp';

      final success = await prefs.setString(backupKey, currentData);

      if (success) {
        print('✅ Backup créé: $backupKey');
      }

      return success;
    } catch (e) {
      print('❌ Erreur lors de la création du backup: $e');
      return false;
    }
  }

  /// Liste tous les backups disponibles
  Future<List<String>> listBackups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final backupKeys = keys
          .where((key) => key.startsWith('${_scheduleDataKey}_backup_'))
          .toList();

      // Trier par timestamp (plus récent en premier)
      backupKeys.sort((a, b) {
        final timestampA = int.tryParse(a.split('_').last) ?? 0;
        final timestampB = int.tryParse(b.split('_').last) ?? 0;
        return timestampB.compareTo(timestampA);
      });

      print('ℹ️ ${backupKeys.length} backups trouvés');
      return backupKeys;
    } catch (e) {
      print('❌ Erreur lors de la liste des backups: $e');
      return [];
    }
  }

  /// Restaure un backup spécifique
  Future<List<WorkEvent>?> restoreBackup(String backupKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backupData = prefs.getString(backupKey);

      if (backupData == null) {
        print('❌ Backup non trouvé: $backupKey');
        return null;
      }

      final jsonData = json.decode(backupData) as List<dynamic>;
      final events = jsonData
          .map((item) => WorkEvent.fromJson(item as Map<String, dynamic>))
          .toList();

      print('✅ Backup restauré: ${events.length} événements');
      return events;
    } catch (e) {
      print('❌ Erreur lors de la restauration: $e');
      return null;
    }
  }

  /// Nettoie les anciens backups (garde les 5 plus récents)
  Future<void> cleanOldBackups({int keepCount = 5}) async {
    try {
      final backups = await listBackups();

      if (backups.length <= keepCount) {
        print('ℹ️ Aucun backup à supprimer (${backups.length} <= $keepCount)');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final toDelete = backups.skip(keepCount);

      for (final backupKey in toDelete) {
        await prefs.remove(backupKey);
        print('🗑️ Backup supprimé: $backupKey');
      }

      print('✅ Nettoyage terminé: ${toDelete.length} backups supprimés');
    } catch (e) {
      print('❌ Erreur lors du nettoyage: $e');
    }
  }
}