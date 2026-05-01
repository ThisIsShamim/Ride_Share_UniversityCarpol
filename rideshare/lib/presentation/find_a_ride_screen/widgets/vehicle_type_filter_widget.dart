import '../../../core/app_export.dart';

class VehicleTypeFilterWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const VehicleTypeFilterWidget({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  static const _vehicleTypes = [
    {'label': 'All', 'icon': Icons.directions_rounded},
    {'label': 'Car', 'icon': Icons.directions_car_rounded},
    {'label': 'Bike', 'icon': Icons.two_wheeler_rounded},
    {'label': 'AC', 'icon': Icons.ac_unit_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(16, 10, 0, 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _vehicleTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final type = _vehicleTypes[i];
          final label = type['label'] as String;
          final isSelected = selectedType == label;
          return InkWell(
            onTap: () => onTypeSelected(label),
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryContainer
                    : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    type['icon'] as IconData,
                    size: 14,
                    color: isSelected ? AppTheme.primary : AppTheme.muted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primary : AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
