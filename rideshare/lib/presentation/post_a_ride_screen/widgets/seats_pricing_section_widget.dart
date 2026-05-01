
import '../../../core/app_export.dart';
import './section_header_widget.dart';

class SeatsPricingSectionWidget extends StatefulWidget {
  final int totalSeats;
  final int pricePerSeat;
  final bool isFemaleOnly;
  final Function(int) onSeatsChanged;
  final Function(int) onPriceChanged;
  final Function(bool) onFemaleOnlyChanged;

  const SeatsPricingSectionWidget({
    super.key,
    required this.totalSeats,
    required this.pricePerSeat,
    required this.isFemaleOnly,
    required this.onSeatsChanged,
    required this.onPriceChanged,
    required this.onFemaleOnlyChanged,
  });

  @override
  State<SeatsPricingSectionWidget> createState() =>
      _SeatsPricingSectionWidgetState();
}

class _SeatsPricingSectionWidgetState extends State<SeatsPricingSectionWidget> {
  late TextEditingController _priceController;

  final List<int> _suggestedPrices = [40, 60, 80, 100, 120, 150];

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: '${widget.pricePerSeat}');
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          icon: Icons.event_seat_rounded,
          title: 'Seats & Pricing',
          subtitle: 'Set how many seats and your price',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Seats', style: theme.textTheme.titleSmall),
              const SizedBox(height: 14),
              Row(
                children: List.generate(6, (i) {
                  final seatCount = i + 1;
                  final isSelected = widget.totalSeats == seatCount;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 5 ? 8 : 0),
                      child: InkWell(
                        onTap: () => widget.onSeatsChanged(seatCount),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 52,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.cardBorder,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_seat_rounded,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.muted,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$seatCount',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Price per Seat', style: theme.textTheme.titleSmall),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.priceGreenLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'in ₦',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.priceGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  InkWell(
                    onTap: widget.pricePerSeat > 20
                        ? () {
                            final newPrice = widget.pricePerSeat - 10;
                            widget.onPriceChanged(newPrice);
                            _priceController.text = '$newPrice';
                          }
                        : null,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: widget.pricePerSeat > 20
                            ? AppTheme.primaryContainer
                            : AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.remove_rounded,
                        color: widget.pricePerSeat > 20
                            ? AppTheme.primary
                            : AppTheme.muted,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.priceGreen,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                        onChanged: (v) {
                          final parsed = int.tryParse(v);
                          if (parsed != null && parsed > 0) {
                            widget.onPriceChanged(parsed);
                          }
                        },
                        decoration: InputDecoration(
                          prefixText: '₦',
                          prefixStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.priceGreen,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.priceGreen,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppTheme.priceGreenLight,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final newPrice = widget.pricePerSeat + 10;
                      widget.onPriceChanged(newPrice);
                      _priceController.text = '$newPrice';
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Suggested prices',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedPrices.map((price) {
                  final isSelected = widget.pricePerSeat == price;
                  return InkWell(
                    onTap: () {
                      widget.onPriceChanged(price);
                      _priceController.text = '$price';
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.priceGreen
                            : AppTheme.priceGreenLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.priceGreen
                              : AppTheme.priceGreen.withAlpha(51),
                        ),
                      ),
                      child: Text(
                        '₦$price',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.priceGreen,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isFemaleOnly
                ? AppTheme.femalePinkLight
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isFemaleOnly
                  ? AppTheme.femalePink.withAlpha(77)
                  : AppTheme.cardBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isFemaleOnly
                      ? AppTheme.femalePink.withAlpha(38)
                      : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.female_rounded,
                  size: 18,
                  color: widget.isFemaleOnly
                      ? AppTheme.femalePink
                      : AppTheme.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Female Passengers Only',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isFemaleOnly
                            ? Color(0xFF880E4F)
                            : AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Only female riders can book this ride',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: widget.isFemaleOnly
                            ? AppTheme.femalePink
                            : AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.isFemaleOnly,
                onChanged: widget.onFemaleOnlyChanged,
                activeThumbColor: AppTheme.femalePink,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Set a fair price to attract more riders. Average rides in this area cost ₦60–₦100 per seat.',
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
    );
  }
}
