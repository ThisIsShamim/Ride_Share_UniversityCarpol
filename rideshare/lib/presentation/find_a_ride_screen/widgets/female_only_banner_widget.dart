import '../../../core/app_export.dart';

class FemaleOnlyBannerWidget extends StatelessWidget {
  final int count;

  const FemaleOnlyBannerWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.femalePinkLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.femalePink.withAlpha(64)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.femalePink.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.female_rounded,
              color: AppTheme.femalePink,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Color(0xFF880E4F),
                ),
                children: [
                  TextSpan(
                    text: '$count Female Only',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text:
                        ' rides available — exclusive safe rides just for you.',
                    style: TextStyle(fontWeight: FontWeight.w400),
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
