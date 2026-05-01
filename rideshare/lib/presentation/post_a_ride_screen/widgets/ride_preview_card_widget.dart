import '../../../core/app_export.dart';

class RidePreviewCardWidget extends StatelessWidget {
  final String fromLocation;
  final String toLocation;
  final List<String> stops;
  final DateTime departureDate;
  final TimeOfDay departureTime;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final int totalSeats;
  final int pricePerSeat;
  final bool isFemaleOnly;

  const RidePreviewCardWidget({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.stops,
    required this.departureDate,
    required this.departureTime,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.totalSeats,
    required this.pricePerSeat,
    required this.isFemaleOnly,
  });

  String _monthName(int month) {
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
    return months[month - 1];
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
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
                  Icons.preview_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Ride Preview',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Live Preview',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PreviewRow(
            label: 'From',
            value: fromLocation.isEmpty ? '—' : fromLocation,
          ),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'To',
            value: toLocation.isEmpty ? '—' : toLocation,
          ),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Stops',
            value: stops.isEmpty ? '0' : '${stops.length}',
          ),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Date',
            value:
                '${departureDate.day.toString().padLeft(2, '0')} ${_monthName(departureDate.month)}',
          ),
          const SizedBox(height: 8),
          _PreviewRow(label: 'Time', value: _formatTime(departureTime)),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Vehicle',
            value: vehicleModel.isEmpty
                ? vehicleType
                : '$vehicleColor $vehicleModel',
          ),
          const SizedBox(height: 8),
          _PreviewRow(label: 'Seats', value: '$totalSeats available'),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Price',
            value: '₦$pricePerSeat/seat',
            valueColor: AppTheme.priceGreen,
          ),
          if (isFemaleOnly) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.femalePinkLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.female_rounded,
                    size: 14,
                    color: AppTheme.femalePink,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Female Only Ride',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.femalePink,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withAlpha(20),
                    AppTheme.primary.withAlpha(8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withAlpha(38)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is how your ride will appear to other riders.',
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
          ),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PreviewRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppTheme.textPrimary,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
