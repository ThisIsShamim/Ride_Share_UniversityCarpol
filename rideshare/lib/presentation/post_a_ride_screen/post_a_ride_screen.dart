import '../../core/app_export.dart';
import './widgets/route_section_widget.dart';
import './widgets/schedule_section_widget.dart';
import './widgets/seats_pricing_section_widget.dart';
import './widgets/vehicle_section_widget.dart';

class PostARideScreen extends StatefulWidget {
  const PostARideScreen({super.key});

  @override
  State<PostARideScreen> createState() => _PostARideScreenState();
}

// TODO: Replace with Riverpod/Bloc for production
class _PostARideScreenState extends State<PostARideScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPosting = false;
  int _currentStep = 0;

  // Route state
  String _fromLocation = '';
  String _toLocation = '';
  final List<String> _stops = [];

  // Schedule state
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _departureTime = const TimeOfDay(hour: 7, minute: 30);
  bool _isRecurring = false;

  // Vehicle state
  String _vehicleType = 'Bike';
  String _vehicleModel = '';
  String _vehicleColor = '';
  bool _hasAC = false;

  // Seats & Pricing
  int _totalSeats = 2;
  int _pricePerSeat = 80;
  bool _isFemaleOnly = false;

  final _steps = ['Route', 'Schedule', 'Vehicle', 'Pricing'];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildStepIndicator(),
            Expanded(
              child: Form(
                key: _formKey,
                child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
                  'Post a Ride',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Share your journey, split the cost',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withAlpha(204),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Step ${_currentStep + 1}/${_steps.length}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: _steps.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final isActive = _currentStep == i;
          final isDone = _currentStep > i;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isDone
                        ? () => setState(() => _currentStep = i)
                        : null,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppTheme.success
                                : isActive
                                ? AppTheme.primary
                                : AppTheme.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isDone
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : Text(
                                    '${i + 1}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isActive
                                          ? Colors.white
                                          : AppTheme.muted,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive
                                ? AppTheme.primary
                                : isDone
                                ? AppTheme.success
                                : AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (i < _steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: _currentStep > i
                            ? AppTheme.success
                            : AppTheme.cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildCurrentStepContent(),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildCurrentStepContent(),
          ),
        ),
        Container(width: 1, color: AppTheme.cardBorder),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildRidePreviewCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return RouteSectionWidget(
          fromLocation: _fromLocation,
          toLocation: _toLocation,
          stops: _stops,
          onFromChanged: (v) => setState(() => _fromLocation = v),
          onToChanged: (v) => setState(() => _toLocation = v),
          onStopAdded: (v) => setState(() => _stops.add(v)),
          onStopRemoved: (i) => setState(() => _stops.removeAt(i)),
        );
      case 1:
        return ScheduleSectionWidget(
          departureDate: _departureDate,
          departureTime: _departureTime,
          isRecurring: _isRecurring,
          onDateChanged: (d) => setState(() => _departureDate = d),
          onTimeChanged: (t) => setState(() => _departureTime = t),
          onRecurringChanged: (v) => setState(() => _isRecurring = v),
        );
      case 2:
        return VehicleSectionWidget(
          vehicleType: _vehicleType,
          vehicleModel: _vehicleModel,
          vehicleColor: _vehicleColor,
          hasAC: _hasAC,
          onTypeChanged: (v) => setState(() => _vehicleType = v),
          onModelChanged: (v) => setState(() => _vehicleModel = v),
          onColorChanged: (v) => setState(() => _vehicleColor = v),
          onACChanged: (v) => setState(() => _hasAC = v),
        );
      case 3:
        return SeatsPricingSectionWidget(
          totalSeats: _totalSeats,
          pricePerSeat: _pricePerSeat,
          isFemaleOnly: _isFemaleOnly,
          onSeatsChanged: (v) => setState(() => _totalSeats = v),
          onPriceChanged: (v) => setState(() => _pricePerSeat = v),
          onFemaleOnlyChanged: (v) => setState(() => _isFemaleOnly = v),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRidePreviewCard() {
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
                  Icons.preview_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Ride Preview',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PreviewRow(
            label: 'From',
            value: _fromLocation.isEmpty ? '—' : _fromLocation,
          ),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'To',
            value: _toLocation.isEmpty ? '—' : _toLocation,
          ),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Stops',
            value: _stops.isEmpty ? '0' : '${_stops.length}',
          ),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Date',
            value:
                '${_departureDate.day.toString().padLeft(2, '0')} ${_monthName(_departureDate.month)}',
          ),
          const SizedBox(height: 8),
          _PreviewRow(label: 'Time', value: _departureTime.format(context)),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Vehicle',
            value: _vehicleModel.isEmpty
                ? _vehicleType
                : '$_vehicleColor $_vehicleModel',
          ),
          const SizedBox(height: 8),
          _PreviewRow(label: 'Seats', value: '$_totalSeats available'),
          const SizedBox(height: 8),
          _PreviewRow(
            label: 'Price',
            value: '₦$_pricePerSeat/seat',
            valueColor: AppTheme.priceGreen,
          ),
          if (_isFemaleOnly) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.femalePinkLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.female_rounded,
                    size: 14,
                    color: AppTheme.femalePink,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Female Only Ride',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.femalePink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildBottomActions(BuildContext context) {
    final isLastStep = _currentStep == _steps.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                side: BorderSide(color: AppTheme.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Back',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isPosting ? null : _handleNextOrSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastStep
                      ? AppTheme.success
                      : AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isPosting
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
                          Icon(
                            isLastStep
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isLastStep ? 'Post Ride' : 'Continue',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextOrSubmit() async {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      setState(() => _isPosting = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _isPosting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ride posted successfully! Riders can now book your seats.',
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
}

class _PreviewRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PreviewRow({
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
