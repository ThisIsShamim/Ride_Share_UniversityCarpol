import '../../../core/app_export.dart';

class VehicleInfoWidget extends StatelessWidget {
  final Map<String, dynamic> ride;

  const VehicleInfoWidget({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBike = ride['vehicleType'] == 'Bike';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isBike
                      ? Icons.two_wheeler_rounded
                      : Icons.directions_car_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text('Vehicle Info', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isBike
                        ? Icons.two_wheeler_rounded
                        : Icons.directions_car_filled_rounded,
                    size: 30,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['vehicleModel'] as String,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _VehicleTag(
                            label: ride['vehicleType'] as String,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 6),
                          if (ride['hasAC'] == true)
                            _VehicleTag(
                              label: 'AC',
                              color: const Color(0xFF0288D1),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.event_seat_rounded,
                  label: 'Total Seats',
                  value: '${ride['totalSeats']}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  icon: Icons.chair_alt_rounded,
                  label: 'Seats Left',
                  value: '${ride['seatsLeft']}',
                  valueColor: ride['seatsLeft'] == 1
                      ? AppTheme.warning
                      : AppTheme.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  icon: Icons.near_me_rounded,
                  label: 'Distance',
                  value: '${ride['distance']}km',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleTag extends StatelessWidget {
  final String label;
  final Color color;

  const _VehicleTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.muted,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
