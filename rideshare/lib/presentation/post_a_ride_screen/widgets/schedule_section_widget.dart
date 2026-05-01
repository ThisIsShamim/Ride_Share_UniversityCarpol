
import '../../../core/app_export.dart';
import './section_header_widget.dart';

class ScheduleSectionWidget extends StatelessWidget {
  final DateTime departureDate;
  final TimeOfDay departureTime;
  final bool isRecurring;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final Function(bool) onRecurringChanged;

  const ScheduleSectionWidget({
    super.key,
    required this.departureDate,
    required this.departureTime,
    required this.isRecurring,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onRecurringChanged,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          icon: Icons.schedule_rounded,
          title: 'Departure Schedule',
          subtitle: 'Set when your ride departs',
        ),
        const SizedBox(height: 16),
        _buildPickerCard(
          context: context,
          icon: Icons.calendar_today_rounded,
          label: 'Departure Date',
          value: _formatDate(departureDate),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: departureDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              builder: (ctx, child) => Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    primary: AppTheme.primary,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) onDateChanged(picked);
          },
        ),
        const SizedBox(height: 12),
        _buildPickerCard(
          context: context,
          icon: Icons.access_time_rounded,
          label: 'Departure Time',
          value: departureTime.format(context),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: departureTime,
              builder: (ctx, child) => Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    primary: AppTheme.primary,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) onTimeChanged(picked);
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.repeat_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recurring Ride',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Post this ride for weekdays automatically',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isRecurring,
                onChanged: onRecurringChanged,
                activeThumbColor: AppTheme.primary,
              ),
            ],
          ),
        ),
        if (isRecurring) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This ride will be posted automatically every weekday at the selected time.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text('Estimated Arrival', style: theme.textTheme.titleSmall),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.timer_rounded, size: 18, color: AppTheme.muted),
              const SizedBox(width: 10),
              Text(
                'Typically 30–45 mins based on your route',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickerCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.cardBorder, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.muted, size: 20),
          ],
        ),
      ),
    );
  }
}
