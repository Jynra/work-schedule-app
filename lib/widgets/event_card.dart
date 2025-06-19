import 'package:flutter/material.dart';
import '../models/work_event.dart';
import '../models/time_slot.dart';
import '../utils/date_utils.dart' as date_utils;
import '../utils/constants.dart';
import 'time_slots_widget.dart';

class EventCard extends StatelessWidget {
  final WorkEvent event;
  final bool isDarkMode;

  const EventCard({
    super.key,
    required this.event,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final eventDate = event.parsedDate;
    if (eventDate == null) {
      return _buildErrorCard('Date invalide: ${event.date}');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(eventDate),
          const SizedBox(height: AppDimensions.spacing16),
          TimeSlotsWidget(
            timeSlots: event.timeSlots,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildInfoRow(
            AppIcons.location,
            event.poste,
            isDarkMode ? Colors.red[300]! : Colors.red,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildInfoRow(
            AppIcons.tasks,
            event.taches,
            isDarkMode ? Colors.green[300]! : Colors.green,
          ),
        ],
      ),
    );
  }

  /// Construit la décoration de la carte
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      border: isDarkMode
          ? Border.all(color: Colors.grey[700]!, width: 1)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Construit l'en-tête avec la date et les badges
  Widget _buildHeader(DateTime eventDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateSection(eventDate),
        _buildBadgesSection(),
      ],
    );
  }

  /// Section de la date
  Widget _buildDateSection(DateTime eventDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date_utils.DateUtils.getDayName(eventDate),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          '${eventDate.day}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.blue[300] : Colors.blue,
          ),
        ),
      ],
    );
  }

  /// Section des badges (Aujourd'hui, Coupure)
  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Badge "Aujourd'hui"
        if (event.isToday)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.green[800] : Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Aujourd'hui",
              style: TextStyle(
                color: isDarkMode ? Colors.green[200] : Colors.green[800],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),

        // Badge "Coupure" pour horaires multiples
        if (event.hasMultipleTimeSlots) ...[
          if (event.isToday) const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.orange[800] : Colors.orange[100],
              borderRadius: BorderRadius.circular(AppDimensions.spacing12),
            ),
            child: Text(
              'Coupure',
              style: TextStyle(
                color: isDarkMode ? Colors.orange[200] : Colors.orange[800],
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Construit une ligne d'information avec icône
  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppDimensions.spacing12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[200] : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// Construit une carte d'erreur
  Widget _buildErrorCard(String errorMessage) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
      padding: const EdgeInsets.all(AppDimensions.spacing20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.red[900] : Colors.red[50],
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: isDarkMode ? Colors.red[700]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.error,
            color: isDarkMode ? Colors.red[300] : Colors.red[600],
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: isDarkMode ? Colors.red[200] : Colors.red[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}