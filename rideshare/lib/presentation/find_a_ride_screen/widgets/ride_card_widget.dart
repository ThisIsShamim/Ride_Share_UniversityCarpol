import '../../../core/app_export.dart';

class RideCardWidget extends StatelessWidget {
  final Map<String, dynamic> rideData;
  final VoidCallback onDetailsPressed;
  final VoidCallback onBookPressed;

  const RideCardWidget({
    super.key,
    required this.rideData,
    required this.onDetailsPressed,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ride = rideData;
    final seatsLeft = ride['seatsLeft'] as int;
    final isUrgent = seatsLeft == 1;
    final isFemaleOnly = ride['isFemaleOnly'] as bool;
    final isTopRated = ride['isTopRated'] as bool;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: isFemaleOnly
                  ? AppTheme.femalePink
                  : isTopRated
                  ? AppTheme.primary
                  : AppTheme.cardBorder,
              width: 3,
            ),
            top: BorderSide(color: AppTheme.cardBorder),
            right: BorderSide(color: AppTheme.cardBorder),
            bottom: BorderSide(color: AppTheme.cardBorder),
          ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDriverRow(theme, ride, isFemaleOnly, isTopRated),
                  const SizedBox(height: 14),
                  _buildRouteSection(theme, ride),
                  const SizedBox(height: 12),
                  _buildMetaRow(theme, ride, isUrgent),
                  const SizedBox(height: 10),
                  _buildVehicleRow(theme, ride),
                  const SizedBox(height: 8),
                  if (ride['notes'] != null) _buildNotesRow(theme, ride),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildActionRow(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverRow(
    ThemeData theme,
    Map<String, dynamic> ride,
    bool isFemaleOnly,
    bool isTopRated,
  ) {
    return Row(
      children: [
        Hero(
          tag: 'driver-avatar-${ride['id']}',
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ride['driverAvatar'] != null
                ? ClipOval(
                    child: CustomImageWidget(
                      imageUrl: ride['driverAvatar'] as String,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      semanticLabel:
                          ride['driverAvatarSemanticLabel'] as String,
                    ),
                  )
                : Center(
                    child: Text(
                      ride['driverInitial'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    ride['driverName'] as String,
                    style: theme.textTheme.titleLarge,
                  ),
                  if (isFemaleOnly) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.femalePinkLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.female_rounded,
                        size: 12,
                        color: AppTheme.femalePink,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: Color(0xFFFFC107),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${ride['rating']}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    ' · ${ride['totalRides']} rides',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: ride['currency'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.priceGreen,
                    ),
                  ),
                  TextSpan(
                    text: '${ride['pricePerSeat']}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.priceGreen,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'per seat',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteSection(ThemeData theme, Map<String, dynamic> ride) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 20,
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.muted.withAlpha(102),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride['fromLocation'] as String,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  ride['toLocation'] as String,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 12,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 3),
                Text(
                  '${ride['stops']} stops',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(
    ThemeData theme,
    Map<String, dynamic> ride,
    bool isUrgent,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        _MetaChip(
          icon: Icons.calendar_today_rounded,
          label: '${ride['departureDate']} · ${ride['departureTime']}',
          color: AppTheme.textSecondary,
        ),
        _MetaChip(
          icon: Icons.event_seat_rounded,
          label:
              '${ride['seatsLeft']} seat${ride['seatsLeft'] > 1 ? 's' : ''} left',
          color: isUrgent ? AppTheme.warning : AppTheme.textSecondary,
          isHighlighted: isUrgent,
        ),
      ],
    );
  }

  Widget _buildVehicleRow(ThemeData theme, Map<String, dynamic> ride) {
    return Row(
      children: [
        _MetaChip(
          icon: ride['vehicleType'] == 'Bike'
              ? Icons.two_wheeler_rounded
              : Icons.directions_car_rounded,
          label: ride['vehicleModel'] as String,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 12),
        _MetaChip(
          icon: Icons.near_me_rounded,
          label: '${ride['distance']} km',
          color: AppTheme.textSecondary,
        ),
      ],
    );
  }

  Widget _buildNotesRow(ThemeData theme, Map<String, dynamic> ride) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 14,
          color: Color(0xFFF57C00),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            ride['notes'] as String,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onDetailsPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 11),
                side: BorderSide(color: AppTheme.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: AppTheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Details',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onBookPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark_add_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Book Now',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isHighlighted;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isHighlighted ? 8 : 0,
        vertical: 2,
      ),
      decoration: isHighlighted
          ? BoxDecoration(
              color: AppTheme.warningLight,
              borderRadius: BorderRadius.circular(6),
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isHighlighted ? AppTheme.warning : color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              color: isHighlighted ? AppTheme.warning : color,
            ),
          ),
        ],
      ),
    );
  }
}
