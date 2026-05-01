import '../../../core/app_export.dart';

class RouteTimelineWidget extends StatelessWidget {
  final List<Map<String, String>> stops;
  final Map<String, dynamic> ride;

  const RouteTimelineWidget({
    super.key,
    required this.stops,
    required this.ride,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Icons.route_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text('Route & Stops', style: theme.textTheme.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '${ride['distance']} km',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stops.asMap().entries.map((entry) {
            final i = entry.key;
            final stop = entry.value;
            final isFirst = i == 0;
            final isLast = i == stops.length - 1;
            return _StopRow(
              stop: stop,
              isFirst: isFirst,
              isLast: isLast,
              showConnector: !isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  final Map<String, String> stop;
  final bool isFirst;
  final bool isLast;
  final bool showConnector;

  const _StopRow({
    required this.stop,
    required this.isFirst,
    required this.isLast,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    IconData dotIcon;
    String typeLabel;

    if (isFirst) {
      dotColor = const Color(0xFF4CAF50);
      dotIcon = Icons.trip_origin_rounded;
      typeLabel = 'Pickup';
    } else if (isLast) {
      dotColor = const Color(0xFFE53935);
      dotIcon = Icons.location_on_rounded;
      typeLabel = 'Dropoff';
    } else {
      dotColor = AppTheme.primary;
      dotIcon = Icons.radio_button_unchecked_rounded;
      typeLabel = 'Stop';
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: dotColor.withAlpha(31),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(dotIcon, size: 16, color: dotColor),
                ),
                if (showConnector)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.muted.withAlpha(77),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showConnector ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop['name'] ?? '',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: dotColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            typeLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: dotColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    stop['time'] ?? '',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
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
