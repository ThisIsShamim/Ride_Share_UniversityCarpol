import '../../../core/app_export.dart';

class BookingSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> ride;
  final int selectedSeats;
  final Function(int) onSeatsChanged;

  const BookingSummaryWidget({
    super.key,
    required this.ride,
    required this.selectedSeats,
    required this.onSeatsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pricePerSeat = ride['pricePerSeat'] as int;
    final seatsLeft = ride['seatsLeft'] as int;
    final totalPrice = pricePerSeat * selectedSeats;

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
                  Icons.receipt_long_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text('Booking Summary', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Route',
            value: '${ride['fromLocation']} → ${ride['toLocation']}',
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Departure',
            value: '${ride['departureDate']}, ${ride['departureTime']}',
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Price per seat',
            value: '${ride['currency']}$pricePerSeat',
            valueColor: AppTheme.priceGreen,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Number of Seats', style: theme.textTheme.titleSmall),
              Row(
                children: [
                  _SeatCountButton(
                    icon: Icons.remove_rounded,
                    onTap: selectedSeats > 1
                        ? () => onSeatsChanged(selectedSeats - 1)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$selectedSeats',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  _SeatCountButton(
                    icon: Icons.add_rounded,
                    onTap: selectedSeats < seatsLeft
                        ? () => onSeatsChanged(selectedSeats + 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppTheme.cardBorder),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: theme.textTheme.titleMedium),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${ride['currency']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.priceGreen,
                      ),
                    ),
                    TextSpan(
                      text: '$totalPrice',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.priceGreen,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
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
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SeatCountButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SeatCountButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppTheme.primaryContainer
              : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppTheme.primary : AppTheme.muted,
        ),
      ),
    );
  }
}
