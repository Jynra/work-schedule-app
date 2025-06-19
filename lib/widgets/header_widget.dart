import 'package:flutter/material.dart';
import '../utils/date_utils.dart' as date_utils;
import '../utils/constants.dart';

class HeaderWidget extends StatelessWidget {
  final DateTime currentDate;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onImportCsv;
  final VoidCallback? onGoToToday;
  final VoidCallback? onReset;
  final VoidCallback? onPreviousWeek;
  final VoidCallback? onNextWeek;
  final String weekRange;
  final bool isCurrentWeek;

  const HeaderWidget({
    super.key,
    required this.currentDate,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onImportCsv,
    this.onGoToToday,
    this.onReset,
    this.onPreviousWeek,
    this.onNextWeek,
    required this.weekRange,
    required this.isCurrentWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacing16),
      padding: const EdgeInsets.all(AppDimensions.spacing24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTitleSection(),
          const SizedBox(height: AppDimensions.spacing16),
          _buildActionButtons(),
          const SizedBox(height: AppDimensions.spacing16),
          _buildNavigationSection(),
        ],
      ),
    );
  }

  /// Section du titre principal
  Widget _buildTitleSection() {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                date_utils.DateUtils.getMonthYear(currentDate),
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: _buildThemeToggleButton(),
        ),
      ],
    );
  }

  /// Bouton de basculement de thème
  Widget _buildThemeToggleButton() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        onPressed: onThemeToggle,
        icon: AnimatedSwitcher(
          duration: AppConstants.defaultAnimationDuration,
          child: Icon(
            isDarkMode ? AppIcons.lightMode : AppIcons.darkMode,
            key: ValueKey(isDarkMode),
            color: isDarkMode ? Colors.yellow[600] : Colors.indigo[600],
            size: 14,
          ),
        ),
        tooltip: isDarkMode ? 'Mode clair' : 'Mode sombre',
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Section des boutons d'action
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Bouton d'importation CSV
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onImportCsv,
            icon: const Icon(AppIcons.import, size: 18),
            label: const Text('Importer CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.blue[800] : Colors.blue[100],
              foregroundColor: isDarkMode ? Colors.blue[200] : Colors.blue[700],
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
                vertical: AppDimensions.spacing12,
              ),
            ),
          ),
        ),

        const SizedBox(width: AppDimensions.spacing8),

        // Bouton "Aujourd'hui"
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onGoToToday,
            icon: const Icon(AppIcons.today, size: 18),
            label: const Text("Aujourd'hui"),
            style: ElevatedButton.styleFrom(
              backgroundColor: onGoToToday == null
                  ? (isDarkMode ? Colors.grey[700] : Colors.grey[300])
                  : (isDarkMode ? Colors.orange[800] : Colors.orange[100]),
              foregroundColor: onGoToToday == null
                  ? (isDarkMode ? Colors.grey[400] : Colors.grey[600])
                  : (isDarkMode ? Colors.orange[200] : Colors.orange[700]),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacing12,
              ),
            ),
          ),
        ),

        const SizedBox(width: AppDimensions.spacing8),

        // Bouton de réinitialisation
        if (onReset != null)
          IconButton(
            onPressed: onReset,
            icon: const Icon(AppIcons.refresh, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.red[800] : Colors.red[100],
              foregroundColor: isDarkMode ? Colors.red[200] : Colors.red[700],
            ),
            tooltip: 'Réinitialiser',
          ),
      ],
    );
  }

  /// Section de navigation entre semaines
  Widget _buildNavigationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton précédent
        IconButton(
          onPressed: onPreviousWeek,
          icon: const Icon(AppIcons.previous),
          style: IconButton.styleFrom(
            backgroundColor: onPreviousWeek != null
                ? (isDarkMode ? Colors.blue[800] : Colors.blue[100])
                : (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
            foregroundColor: onPreviousWeek != null
                ? (isDarkMode ? Colors.blue[200] : Colors.blue[700])
                : (isDarkMode ? Colors.grey[500] : Colors.grey[500]),
          ),
          tooltip: 'Semaine précédente',
        ),

        // Informations de la semaine
        _buildWeekInfo(),

        // Bouton suivant
        IconButton(
          onPressed: onNextWeek,
          icon: const Icon(AppIcons.next),
          style: IconButton.styleFrom(
            backgroundColor: onNextWeek != null
                ? (isDarkMode ? Colors.blue[800] : Colors.blue[100])
                : (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
            foregroundColor: onNextWeek != null
                ? (isDarkMode ? Colors.blue[200] : Colors.blue[700])
                : (isDarkMode ? Colors.grey[500] : Colors.grey[500]),
          ),
          tooltip: 'Semaine suivante',
        ),
      ],
    );
  }

  /// Informations sur la semaine actuelle
  Widget _buildWeekInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label avec badge "Actuelle"
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Semaine',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            if (isCurrentWeek) ...[
              const SizedBox(width: AppDimensions.spacing8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.green[800] : Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Actuelle',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.green[200] : Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppDimensions.spacing4),
        // Plage de dates
        Text(
          weekRange,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}