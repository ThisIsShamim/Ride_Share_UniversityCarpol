import '../../../core/app_export.dart';

class RouteSectionWidget extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final List<String> stops;
  final Function(String) onFromChanged;
  final Function(String) onToChanged;
  final Function(String) onStopAdded;
  final Function(int) onStopRemoved;

  const RouteSectionWidget({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.stops,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onStopAdded,
    required this.onStopRemoved,
  });

  @override
  State<RouteSectionWidget> createState() => _RouteSectionWidgetState();
}

class _RouteSectionWidgetState extends State<RouteSectionWidget> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _stopController = TextEditingController();

  final List<String> _popularLocations = [
    'Mirpur 10',
    'BUET',
    'Dhanmondi',
    'Gulshan',
    'Banani',
    'Uttara',
    'Motijheel',
    'Farmgate',
    'Shahbag',
    'TSC',
  ];

  @override
  void initState() {
    super.initState();
    _fromController.text = widget.fromLocation;
    _toController.text = widget.toLocation;
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _stopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.route_rounded,
          title: 'Route Details',
          subtitle: 'Set your pickup and dropoff locations',
        ),
        const SizedBox(height: 16),
        _buildLocationField(
          controller: _fromController,
          label: 'From (Pickup Location)',
          hint: 'e.g. Mirpur 10 Circle',
          prefixColor: const Color(0xFF4CAF50),
          onChanged: widget.onFromChanged,
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withAlpha(77)),
            ),
            child: Icon(
              Icons.swap_vert_rounded,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLocationField(
          controller: _toController,
          label: 'To (Dropoff Location)',
          hint: 'e.g. BUET Gate',
          prefixColor: const Color(0xFFE53935),
          onChanged: widget.onToChanged,
        ),
        const SizedBox(height: 20),
        Text(
          'Popular Locations',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularLocations.map((loc) {
            return InkWell(
              onTap: () {
                if (_fromController.text.isEmpty) {
                  _fromController.text = loc;
                  widget.onFromChanged(loc);
                } else if (_toController.text.isEmpty) {
                  _toController.text = loc;
                  widget.onToChanged(loc);
                }
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppTheme.primary.withAlpha(51)),
                ),
                child: Text(
                  loc,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text('Intermediate Stops', style: theme.textTheme.titleSmall),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${widget.stops.length}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _stopController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Add a stop',
                  hintText: 'e.g. Farmgate',
                  prefixIcon: Icon(
                    Icons.add_location_alt_rounded,
                    color: AppTheme.primary,
                    size: 20,
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
                    borderSide: BorderSide(color: AppTheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                if (_stopController.text.trim().isNotEmpty) {
                  widget.onStopAdded(_stopController.text.trim());
                  _stopController.clear();
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        if (widget.stops.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...widget.stops.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => widget.onStopRemoved(entry.key),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Color(0xFFC62828),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Color prefixColor,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'This field is required' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: prefixColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.cardBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.cardBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.error, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 22),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
