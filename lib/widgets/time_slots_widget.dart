import 'package:flutter/material.dart';
import '../models/time_slot.dart';
import '../utils/constants.dart';

class TimeSlotsWidget extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final bool isDarkMode;

  const TimeSlotsWidget({
    super.key,
    required this.timeSlots,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppDimensions.spacing8),
        ...timeSlots.map((slot) => _buildTimeSlot(slot)),
        _buildTotalTime(),
      ],
    );
  }

  /// Construit l'en-tête de la section horaires
  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          AppIcons.time,
          size: 16,
          color: isDarkMode ? Colors.blue[300] : Colors.blue,
        ),
        const SizedBox(width: AppDimensions.spacing12),
        Text(
          timeSlots.length == 1 ? 'Horaire :' : 'Horaires de la journée :',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[200] : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Construit un créneau horaire individuel
  Widget _buildTimeSlot(TimeSlot slot) {
    return Container(
      margin: EdgeInsets.only(
        left: 28,
        bottom: timeSlots.length == 1 ? 0 : 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: _buildSlotDecoration(slot),
      child: Row(
        children: [
          _buildSlotIndicator(slot),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              slot.displayText,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[200] : Colors.black87,
                fontSize: 14,
                fontWeight: slot.isRest ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la décoration d'un créneau
  BoxDecoration _buildSlotDecoration(TimeSlot slot) {
    final backgroundColor = slot.isRest
        ? (isDarkMode ? Colors.grey[700] : Colors.grey[100])
        : (isDarkMode
        ? Colors.blue[900]?.withValues(alpha: 0.3)
        : Colors.blue[50]);

    final borderColor = slot.isRest
        ? (isDarkMode ? Colors.grey[600]! : Colors.grey[300]!)
        : (isDarkMode ? Colors.blue[600]! : Colors.blue[200]!);

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall + 2),
      border: Border.all(color: borderColor, width: 1),
    );
  }

  /// Construit l'indicateur visuel du créneau
  Widget _buildSlotIndicator(TimeSlot slot) {
    final color = slot.isRest
        ? (isDarkMode ? Colors.grey[400] : Colors.grey[600])
        : (isDarkMode ? Colors.blue[300] : Colors.blue[600]);

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Construit l'affichage du temps total
  Widget _buildTotalTime() {
    final workSlots = timeSlots.where((slot) => !slot.isRest).toList();

    if (workSlots.isEmpty) return const SizedBox.shrink();

    final totalTime = TimeSlot.calculateTotalWorkTime(timeSlots);
    final formattedTime = TimeSlot.formatDuration(totalTime);

    return Container(
      margin: EdgeInsets.only(
        left: 28,
        top: timeSlots.length == 1 ? 6 : 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing8 + 2,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.green[900]?.withValues(alpha: 0.3)
            : Colors.green[50],
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(
          color: isDarkMode ? Colors.green[700]! : Colors.green[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 14,
            color: isDarkMode ? Colors.green[300] : Colors.green[700],
          ),
          const SizedBox(width: 6),
          Text(
            'Total: $formattedTime',
            style: TextStyle(
              color: isDarkMode ? Colors.green[300] : Colors.green[700],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}