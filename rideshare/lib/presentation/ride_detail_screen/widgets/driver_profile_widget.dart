import '../../../core/app_export.dart';

class DriverProfileWidget extends StatelessWidget {
  final Map<String, dynamic> ride;

  const DriverProfileWidget({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = ride['rating'] as double;
    final totalRides = ride['totalRides'] as int;

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
              Hero(
                tag: 'driver-avatar-${ride['id']}',
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryLight],
                    ),
                  ),
                  child: ride['driverAvatar'] != null
                      ? ClipOval(
                          child: CustomImageWidget(
                            imageUrl: ride['driverAvatar'] as String,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            semanticLabel:
                                ride['driverAvatarSemanticLabel'] as String,
                          ),
                        )
                      : Center(
                          child: Text(
                            ride['driverInitial'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ride['driverName'] as String,
                          style: theme.textTheme.headlineSmall,
                        ),
                        if (ride['isFemaleOnly'] == true) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.femalePinkLight,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.female_rounded,
                                  size: 12,
                                  color: AppTheme.femalePink,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Female Only',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.femalePink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            i < rating.floor()
                                ? Icons.star_rounded
                                : i < rating
                                ? Icons.star_half_rounded
                                : Icons.star_outline_rounded,
                            size: 16,
                            color: const Color(0xFFFFC107),
                          );
                        }),
                        const SizedBox(width: 6),
                        Text(
                          '$rating ($totalRides rides)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  side: BorderSide(color: AppTheme.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Message',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Rating',
                  value: '$rating',
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFFFC107),
                ),
                _Divider(),
                _StatItem(
                  label: 'Rides',
                  value: '$totalRides',
                  icon: Icons.directions_car_rounded,
                  iconColor: AppTheme.primary,
                ),
                _Divider(),
                _StatItem(
                  label: 'Member',
                  value: '2 yrs',
                  icon: Icons.verified_rounded,
                  iconColor: AppTheme.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppTheme.cardBorder);
  }
}
