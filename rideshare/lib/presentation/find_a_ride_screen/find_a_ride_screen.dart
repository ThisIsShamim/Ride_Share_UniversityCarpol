import '../../core/app_export.dart';
import './widgets/female_only_banner_widget.dart';
import './widgets/ride_card_widget.dart';
import './widgets/sort_filter_bar_widget.dart';
import './widgets/vehicle_type_filter_widget.dart';

class FindARideScreen extends StatefulWidget {
  const FindARideScreen({super.key});

  @override
  State<FindARideScreen> createState() => _FindARideScreenState();
}

// TODO: Replace with Riverpod/Bloc for production
class _FindARideScreenState extends State<FindARideScreen>
    with TickerProviderStateMixin {
  int _selectedNavIndex = 0;
  int _selectedSortIndex = 0;
  String _selectedVehicleType = 'All';

  late List<AnimationController> _cardAnimControllers;
  late List<Animation<Offset>> _cardSlideAnimations;
  late List<Animation<double>> _cardFadeAnimations;

  final List<Map<String, dynamic>> _rideMaps = [
    {
      'id': 'ride_001',
      'driverName': 'Rahim Ahmed',
      'driverAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1d126af2f-1763293474375.png',
      'driverAvatarSemanticLabel':
          'Professional headshot of Bangladeshi man with short black hair wearing casual blue shirt',
      'driverInitial': 'R',
      'rating': 4.6,
      'totalRides': 32,
      'pricePerSeat': 80,
      'currency': '₦',
      'fromLocation': 'Mirpur',
      'toLocation': 'BUET',
      'stops': 6,
      'departureDate': '09 Apr',
      'departureTime': '7:30 AM',
      'seatsLeft': 1,
      'totalSeats': 3,
      'distance': 12.3,
      'vehicleModel': 'Black Honda CB',
      'vehicleType': 'Bike',
      'hasAC': false,
      'notes': 'Bike ride, helmet provided. You can board/exit at any stop.',
      'isFemaleOnly': false,
      'isTopRated': true,
    },
    {
      'id': 'ride_002',
      'driverName': 'Nadia Islam',
      'driverAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1228adf75-1763298678714.png',
      'driverAvatarSemanticLabel':
          'Young Bangladeshi woman with long dark hair smiling in professional attire',
      'driverInitial': 'N',
      'rating': 4.9,
      'totalRides': 87,
      'pricePerSeat': 60,
      'currency': '₦',
      'fromLocation': 'Dhanmondi',
      'toLocation': 'Gulshan',
      'stops': 3,
      'departureDate': '09 Apr',
      'departureTime': '8:00 AM',
      'seatsLeft': 2,
      'totalSeats': 3,
      'distance': 8.5,
      'vehicleModel': 'White Toyota Axio',
      'vehicleType': 'Car',
      'hasAC': true,
      'notes': 'AC car ride. Female passengers only. Door-to-door available.',
      'isFemaleOnly': true,
      'isTopRated': true,
    },
    {
      'id': 'ride_003',
      'driverName': 'Karim Hossain',
      'driverAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1bae56d9d-1772244976512.png',
      'driverAvatarSemanticLabel':
          'Middle-aged Bangladeshi man with beard wearing grey polo shirt',
      'driverInitial': 'K',
      'rating': 4.3,
      'totalRides': 156,
      'pricePerSeat': 50,
      'currency': '₦',
      'fromLocation': 'Uttara',
      'toLocation': 'Motijheel',
      'stops': 8,
      'departureDate': '09 Apr',
      'departureTime': '7:00 AM',
      'seatsLeft': 3,
      'totalSeats': 4,
      'distance': 18.7,
      'vehicleModel': 'Silver Honda City',
      'vehicleType': 'Car',
      'hasAC': false,
      'notes': 'Regular commute. Flexible pickup points along the main road.',
      'isFemaleOnly': false,
      'isTopRated': false,
    },
    {
      'id': 'ride_004',
      'driverName': 'Tasnim Sultana',
      'driverAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1d662602c-1772476802747.png',
      'driverAvatarSemanticLabel':
          'Young Bangladeshi woman with hijab smiling outdoors in natural light',
      'driverInitial': 'T',
      'rating': 4.7,
      'totalRides': 43,
      'pricePerSeat': 70,
      'currency': '₦',
      'fromLocation': 'Banani',
      'toLocation': 'Rayer Bazar',
      'stops': 4,
      'departureDate': '09 Apr',
      'departureTime': '8:30 AM',
      'seatsLeft': 1,
      'totalSeats': 2,
      'distance': 10.1,
      'vehicleModel': 'Blue Yamaha FZS',
      'vehicleType': 'Bike',
      'hasAC': false,
      'notes': 'Female only. Helmet provided. Safe and reliable daily commute.',
      'isFemaleOnly': true,
      'isTopRated': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startEntranceAnimation();
  }

  void _initAnimations() {
    _cardAnimControllers = List.generate(
      _rideMaps.length,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 350 + (i * 60)),
      ),
    );
    _cardSlideAnimations = _cardAnimControllers.map((ctrl) {
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic));
    }).toList();
    _cardFadeAnimations = _cardAnimControllers.map((ctrl) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));
    }).toList();
  }

  void _startEntranceAnimation() async {
    for (int i = 0; i < _cardAnimControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 80));
      if (mounted) _cardAnimControllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final ctrl in _cardAnimControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRides {
    return _rideMaps.where((ride) {
      if (_selectedVehicleType == 'All') return true;
      if (_selectedVehicleType == 'AC') return ride['hasAC'] == true;
      return ride['vehicleType'] == _selectedVehicleType;
    }).toList();
  }

  void _onNavTap(int index) {
    // TODO: Replace with Riverpod/Bloc for production
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.postARideScreen);
      return;
    }
    setState(() => _selectedNavIndex = index);
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      for (final ctrl in _cardAnimControllers) {
        ctrl.reset();
      }
      _startEntranceAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final filteredRides = _filteredRides;
    final femaleOnlyCount = _rideMaps
        .where((r) => r['isFemaleOnly'] == true)
        .length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: isTablet
            ? Row(
                children: [
                  AppNavigation(
                    currentIndex: _selectedNavIndex,
                    onTap: _onNavTap,
                  ),
                  Expanded(
                    child: _buildBody(
                      theme,
                      filteredRides,
                      femaleOnlyCount,
                      isTablet,
                    ),
                  ),
                ],
              )
            : _buildBody(theme, filteredRides, femaleOnlyCount, isTablet),
      ),
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(currentIndex: _selectedNavIndex, onTap: _onNavTap),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    List<Map<String, dynamic>> filteredRides,
    int femaleOnlyCount,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(theme),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppTheme.primary,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (femaleOnlyCount > 0)
                        FemaleOnlyBannerWidget(count: femaleOnlyCount),
                      SortFilterBarWidget(
                        selectedIndex: _selectedSortIndex,
                        onSortSelected: (i) =>
                            setState(() => _selectedSortIndex = i),
                      ),
                      VehicleTypeFilterWidget(
                        selectedType: _selectedVehicleType,
                        onTypeSelected: (type) =>
                            setState(() => _selectedVehicleType = type),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: Text(
                          '${filteredRides.length} ride${filteredRides.length != 1 ? 's' : ''} available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (filteredRides.isEmpty)
                  SliverFillRemaining(
                    child: EmptyStateWidget(
                      icon: Icons.help_outline,
                      title: 'No rides found',
                      description:
                          'No rides match your current filters. Try changing the vehicle type or sort order.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: isTablet
                        ? SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) => _buildAnimatedCard(filteredRides, i),
                              childCount: filteredRides.length,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) => _buildAnimatedCard(filteredRides, i),
                              childCount: filteredRides.length,
                            ),
                          ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCard(List<Map<String, dynamic>> rides, int index) {
    if (index >= _cardAnimControllers.length) {
      return RideCardWidget(
        rideData: rides[index],
        onDetailsPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.rideDetailScreen,
          arguments: rides[index],
        ),
        onBookPressed: () => _showBookingConfirmation(rides[index]),
      );
    }
    return SlideTransition(
      position: _cardSlideAnimations[index],
      child: FadeTransition(
        opacity: _cardFadeAnimations[index],
        child: RideCardWidget(
          rideData: rides[index],
          onDetailsPressed: () => Navigator.pushNamed(
            context,
            AppRoutes.rideDetailScreen,
            arguments: rides[index],
          ),
          onBookPressed: () => _showBookingConfirmation(rides[index]),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.directions_car_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'RideShare',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Find a Ride',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5252),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withAlpha(77),
                        Colors.white.withAlpha(38),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha(128),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'N',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _FilterButton(),
            ],
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation(Map<String, dynamic> ride) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookingBottomSheet(ride: ride),
    );
  }
}

class _FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              'Filters',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingBottomSheet extends StatefulWidget {
  final Map<String, dynamic> ride;

  const _BookingBottomSheet({required this.ride});

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  int _seats = 1;
  bool _isBooking = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ride = widget.ride;
    final maxSeats = ride['seatsLeft'] as int;
    final pricePerSeat = ride['pricePerSeat'] as int;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.cardBorder,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Confirm Booking', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            '${ride['fromLocation']} → ${ride['toLocation']}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seats', style: theme.textTheme.titleSmall),
              Row(
                children: [
                  _SeatButton(
                    icon: Icons.remove_rounded,
                    onTap: _seats > 1 ? () => setState(() => _seats--) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_seats',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _SeatButton(
                    icon: Icons.add_rounded,
                    onTap: _seats < maxSeats
                        ? () => setState(() => _seats++)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: theme.textTheme.titleSmall),
                Text(
                  '${ride['currency']}${pricePerSeat * _seats}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.priceGreen,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isBooking ? null : _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isBooking
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Confirm Booking',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() async {
    setState(() => _isBooking = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking confirmed! $_seats seat${_seats > 1 ? 's' : ''} reserved.',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}

class _SeatButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SeatButton({required this.icon, this.onTap});

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
