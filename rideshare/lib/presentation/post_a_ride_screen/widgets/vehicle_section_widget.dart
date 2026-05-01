
import '../../../core/app_export.dart';
import './section_header_widget.dart';

class VehicleSectionWidget extends StatefulWidget {
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final bool hasAC;
  final Function(String) onTypeChanged;
  final Function(String) onModelChanged;
  final Function(String) onColorChanged;
  final Function(bool) onACChanged;

  const VehicleSectionWidget({
    super.key,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.hasAC,
    required this.onTypeChanged,
    required this.onModelChanged,
    required this.onColorChanged,
    required this.onACChanged,
  });

  @override
  State<VehicleSectionWidget> createState() => _VehicleSectionWidgetState();
}

class _VehicleSectionWidgetState extends State<VehicleSectionWidget> {
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();

  static const _vehicleTypes = [
    {'label': 'Car', 'icon': Icons.directions_car_rounded},
    {'label': 'Bike', 'icon': Icons.two_wheeler_rounded},
    {'label': 'CNG', 'icon': Icons.local_taxi_rounded},
    {'label': 'Rickshaw', 'icon': Icons.electric_rickshaw_rounded},
  ];

  static const _popularModels = [
    'Honda CB',
    'Yamaha FZS',
    'Toyota Axio',
    'Honda City',
    'Suzuki Alto',
    'Bajaj Pulsar',
  ];

  static const _vehicleColors = [
    'Black',
    'White',
    'Silver',
    'Blue',
    'Red',
    'Grey',
  ];

  @override
  void initState() {
    super.initState();
    _modelController.text = widget.vehicleModel;
    _colorController.text = widget.vehicleColor;
  }

  @override
  void dispose() {
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          icon: Icons.directions_car_rounded,
          title: 'Vehicle Information',
          subtitle: 'Tell riders about your vehicle',
        ),
        const SizedBox(height: 16),
        Text('Vehicle Type', style: theme.textTheme.titleSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _vehicleTypes.map((type) {
            final label = type['label'] as String;
            final icon = type['icon'] as IconData;
            final isSelected = widget.vehicleType == label;
            return InkWell(
              onTap: () => widget.onTypeChanged(label),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withAlpha(64),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected ? Colors.white : AppTheme.muted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text('Vehicle Model', style: theme.textTheme.titleSmall),
        const SizedBox(height: 10),
        TextFormField(
          controller: _modelController,
          onChanged: widget.onModelChanged,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Vehicle Model',
            hintText: 'e.g. Honda CB 150R',
            prefixIcon: Icon(
              Icons.directions_car_outlined,
              color: AppTheme.primary,
              size: 20,
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
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularModels.map((model) {
            return InkWell(
              onTap: () {
                _modelController.text = model;
                widget.onModelChanged(model);
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.vehicleModel == model
                      ? AppTheme.primaryContainer
                      : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: widget.vehicleModel == model
                        ? AppTheme.primary.withAlpha(77)
                        : AppTheme.cardBorder,
                  ),
                ),
                child: Text(
                  model,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.vehicleModel == model
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text('Vehicle Color', style: theme.textTheme.titleSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _vehicleColors.map((color) {
            final isSelected = widget.vehicleColor == color;
            return InkWell(
              onTap: () {
                _colorController.text = color;
                widget.onColorChanged(color);
              },
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary
                      : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                  ),
                ),
                child: Text(
                  color,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.muted,
                  ),
                ),
              ),
            );
          }).toList(),
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
                  color: const Color(0xFFE1F5FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.ac_unit_rounded,
                  size: 18,
                  color: Color(0xFF0288D1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Air Conditioning',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Riders will see AC badge on your listing',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.hasAC,
                onChanged: widget.onACChanged,
                activeThumbColor: const Color(0xFF0288D1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
