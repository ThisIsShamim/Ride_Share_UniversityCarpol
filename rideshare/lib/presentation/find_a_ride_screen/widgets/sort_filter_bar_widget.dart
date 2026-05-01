import '../../../core/app_export.dart';

class SortFilterBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSortSelected;

  const SortFilterBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onSortSelected,
  });

  static const _sortOptions = [
    {'label': 'Soonest', 'icon': Icons.access_time_rounded},
    {'label': 'Cheapest', 'icon': Icons.savings_rounded},
    {'label': 'Top Rated', 'icon': Icons.star_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.fromLTRB(16, 12, 0, 0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _sortOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final option = _sortOptions[i];
          final isSelected = selectedIndex == i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: InkWell(
              onTap: () => onSortSelected(i),
              borderRadius: BorderRadius.circular(100),
              splashColor: AppTheme.primary.withAlpha(26),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(100),
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
                      option['icon'] as IconData,
                      size: 14,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      option['label'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
