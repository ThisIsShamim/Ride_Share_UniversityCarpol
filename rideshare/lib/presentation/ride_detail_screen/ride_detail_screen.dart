import '../../core/app_export.dart';
import './widgets/booking_summary_widget.dart';
import './widgets/driver_profile_widget.dart';
import './widgets/ride_policies_widget.dart';
import './widgets/route_timeline_widget.dart';
import './widgets/vehicle_info_widget.dart';

class RideDetailScreen extends StatefulWidget {
  const RideDetailScreen({super.key});

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

// TODO: Replace with Riverpod/Bloc for production
class _RideDetailScreenState extends State<RideDetailScreen> {
  int _selectedSeats = 1;
  bool _isBooking = false;

  // Default ride data (fallback if no arguments passed)
  static final Map<String, dynamic> _defaultRide = {
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
  };

  static const List<Map<String, String>> _stopsMaps = [
    {'name': 'Mirpur 10 Circle', 'type': 'pickup', 'time': '7:30 AM'},
    {'name': 'Mirpur 1', 'type': 'stop', 'time': '7:38 AM'},
    {'name': 'Farmgate', 'type': 'stop', 'time': '7:50 AM'},
    {'name': 'Shahbag', 'type': 'stop', 'time': '8:02 AM'},
    {'name': 'TSC', 'type': 'stop', 'time': '8:08 AM'},
    {'name': 'BUET Gate', 'type': 'dropoff', 'time': '8:15 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final ride = (args is Map<String, dynamic>) ? args : _defaultRide;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final seatsLeft = ride['seatsLeft'] as int;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context, ride, seatsLeft)
            : _buildPhoneLayout(context, ride, seatsLeft),
      ),
    );
  }

  Widget _buildPhoneLayout(
    BuildContext context,
    Map<String, dynamic> ride,
    int seatsLeft,
  ) {
    return Column(
      children: [
        _buildDetailAppBar(context, ride),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DriverProfileWidget(ride: ride),
                const SizedBox(height: 16),
                RouteTimelineWidget(stops: _stopsMaps, ride: ride),
                const SizedBox(height: 16),
                VehicleInfoWidget(ride: ride),
                const SizedBox(height: 16),
                RidePoliciesWidget(ride: ride),
                const SizedBox(height: 16),
                BookingSummaryWidget(
                  ride: ride,
                  selectedSeats: _selectedSeats,
                  onSeatsChanged: (v) => setState(() => _selectedSeats = v),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        _buildBookingBar(context, ride, seatsLeft),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    Map<String, dynamic> ride,
    int seatsLeft,
  ) {
    return Column(
      children: [
        _buildDetailAppBar(context, ride),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      DriverProfileWidget(ride: ride),
                      const SizedBox(height: 16),
                      RouteTimelineWidget(stops: _stopsMaps, ride: ride),
                      const SizedBox(height: 16),
                      VehicleInfoWidget(ride: ride),
                      const SizedBox(height: 16),
                      RidePoliciesWidget(ride: ride),
                    ],
                  ),
                ),
              ),
              Container(width: 1, color: AppTheme.cardBorder),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      BookingSummaryWidget(
                        ride: ride,
                        selectedSeats: _selectedSeats,
                        onSeatsChanged: (v) =>
                            setState(() => _selectedSeats = v),
                      ),
                      const SizedBox(height: 20),
                      _buildBookNowButton(
                        context,
                        ride,
                        seatsLeft,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailAppBar(BuildContext context, Map<String, dynamic> ride) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${ride['fromLocation']} → ${ride['toLocation']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingBar(
    BuildContext context,
    Map<String, dynamic> ride,
    int seatsLeft,
  ) {
    final pricePerSeat = ride['pricePerSeat'] as int;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total for $_selectedSeats seat${_selectedSeats > 1 ? 's' : ''}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
                      text: '${pricePerSeat * _selectedSeats}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
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
          const SizedBox(width: 16),
          Expanded(child: _buildBookNowButton(context, ride, seatsLeft)),
        ],
      ),
    );
  }

  Widget _buildBookNowButton(
    BuildContext context,
    Map<String, dynamic> ride,
    int seatsLeft, {
    bool fullWidth = false,
  }) {
    return SizedBox(
      height: 52,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: seatsLeft > 0 && !_isBooking ? _handleBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark_add_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    seatsLeft > 0 ? 'Book Now' : 'Fully Booked',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handleBooking() async {
    setState(() => _isBooking = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isBooking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking confirmed! $_selectedSeats seat${_selectedSeats > 1 ? 's' : ''} reserved.',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}
