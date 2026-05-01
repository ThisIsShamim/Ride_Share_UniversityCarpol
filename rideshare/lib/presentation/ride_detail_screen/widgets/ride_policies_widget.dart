import '../../../core/app_export.dart';

class RidePoliciesWidget extends StatelessWidget {
  final Map<String, dynamic> ride;

  const RidePoliciesWidget({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBike = ride['vehicleType'] == 'Bike';

    final policies = [
      if (isBike)
        _Policy(
          icon: Icons.sports_motorsports_rounded,
          title: 'Helmet Provided',
          description: 'Driver provides a helmet for each passenger.',
          color: AppTheme.success,
        ),
      _Policy(
        icon: Icons.location_on_rounded,
        title: 'Flexible Boarding',
        description: 'You can board or exit at any stop along the route.',
        color: AppTheme.primary,
      ),
      _Policy(
        icon: Icons.cancel_rounded,
        title: 'Cancellation Policy',
        description: 'Free cancellation up to 30 minutes before departure.',
        color: AppTheme.warning,
      ),
      _Policy(
        icon: Icons.smoke_free_rounded,
        title: 'No Smoking',
        description: 'Smoking is not allowed during the ride.',
        color: const Color(0xFFC62828),
      ),
    ];

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
                  Icons.policy_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text('Ride Policies', style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          ...policies.map((policy) => _PolicyRow(policy: policy)),
        ],
      ),
    );
  }
}

class _Policy {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _Policy({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _PolicyRow extends StatelessWidget {
  final _Policy policy;

  const _PolicyRow({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: policy.color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(policy.icon, size: 16, color: policy.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  policy.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
