// home_screen.dart
import 'package:flutter/material.dart';

// Note: Uncomment and update these imports to match your actual project structure.
// import '../components/ride_card.dart';
// import '../components/booking_modal.dart';
// import '../types.dart';
// import '../mock_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Search Inputs ---
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _checkpointController = TextEditingController();
  DateTime? _searchDate;

  // --- Filters ---
  String _vehicleType = 'all';
  String _priceRange = 'all';
  String _acFilter = 'all';
  String _sortBy = 'time';

  // --- UI State ---
  bool _showSearchPanel = false;
  bool _showAdvanced = false;
  final bool _bookingOpen = false;
  // Ride? _selectedRide; // Uncomment when you have the Ride model imported

  // Mocking the user and derived data since mockData isn't provided
  // Replace these with your actual state management or derived data logic
  final Map<String, dynamic> _currentUser = {'gender': 'female'};
  final List<dynamic> _filteredRides = [];
  final int _femaleOnlyCount = 2;

  // --- Derived ---
  int get _activeFilterCount {
    int count = 0;
    if (_vehicleType != 'all') count++;
    if (_priceRange != 'all') count++;
    if (_acFilter != 'all') count++;
    if (_sortBy != 'time') count++;
    if (_checkpointController.text.trim().isNotEmpty) count++;
    return count;
  }

  void _clearAll() {
    setState(() {
      _originController.clear();
      _destinationController.clear();
      _checkpointController.clear();
      _searchDate = null;
      _vehicleType = 'all';
      _priceRange = 'all';
      _acFilter = 'all';
      _sortBy = 'time';
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _checkpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 512), // max-w-lg
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── HEADER ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Find a Ride',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900, // font-black
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_filteredRides.length} ride${_filteredRides.length != 1 ? 's' : ''} available',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        _buildFilterButton(),
                      ],
                    ),
                  ),

                  // ── GENDER SAFETY BANNER ──
                  if (_currentUser['gender'] == 'female' &&
                      _femaleOnlyCount > 0)
                    _buildSafetyBanner(
                      icon: Icons.security,
                      iconColor: Colors.pink[500]!,
                      bgColor: Colors.pink[50]!,
                      borderColor: Colors.pink[100]!,
                      content: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.pink[700],
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '$_femaleOnlyCount Female Only',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' ride${_femaleOnlyCount > 1 ? 's' : ''} available — exclusive safe rides just for you.',
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (_currentUser['gender'] == 'male' && _femaleOnlyCount > 0)
                    _buildSafetyBanner(
                      icon: Icons.error_outline,
                      iconColor: Colors.grey[400]!,
                      bgColor: Colors.grey[50]!,
                      borderColor: Colors.grey[200]!,
                      content: const Text(
                        'Female Only rides are hidden from your results for safety.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),

                  // ── SEARCH / FILTER PANEL ──
                  if (_showSearchPanel) _buildSearchPanel(),

                  // ── QUICK SORT CHIPS (always visible) ──
                  if (!_showSearchPanel)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildChip(
                              '🕐 Soonest',
                              _sortBy == 'time',
                              () => setState(() => _sortBy = 'time'),
                            ),
                            _buildChip(
                              '💰 Cheapest',
                              _sortBy == 'price',
                              () => setState(() => _sortBy = 'price'),
                            ),
                            _buildChip(
                              '⭐ Top Rated',
                              _sortBy == 'rating',
                              () => setState(() => _sortBy = 'rating'),
                            ),
                            _buildChip(
                              '🚗 Car',
                              _vehicleType == 'car',
                              () => setState(
                                () => _vehicleType = _vehicleType == 'car'
                                    ? 'all'
                                    : 'car',
                              ),
                            ),
                            _buildChip(
                              '🏍 Bike',
                              _vehicleType == 'bike',
                              () => setState(
                                () => _vehicleType = _vehicleType == 'bike'
                                    ? 'all'
                                    : 'bike',
                              ),
                            ),
                            _buildChip(
                              '❄️ AC',
                              _acFilter == 'yes',
                              () => setState(
                                () => _acFilter = _acFilter == 'yes'
                                    ? 'all'
                                    : 'yes',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── RESULTS ──
                  if (_filteredRides.isEmpty)
                    _buildEmptyState()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: _filteredRides.map((ride) {
                          // return RideCard(ride: ride);
                          return const Card(
                            child: ListTile(title: Text('Ride Placeholder')),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BookingModal(...) // Implement this logic using a bottom sheet or modal
    );
  }

  // --- Widget Builders ---

  Widget _buildFilterButton() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showSearchPanel = !_showSearchPanel;
              _showAdvanced = false;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _showSearchPanel ? Colors.blue[600] : Colors.white,
              border: Border.all(
                color: _showSearchPanel ? Colors.blue[600]! : Colors.grey[200]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  size: 14,
                  color: _showSearchPanel ? Colors.white : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _showSearchPanel ? Colors.white : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_activeFilterCount > 0)
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_activeFilterCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSafetyBanner({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // From Input
            _buildTextField(
              controller: _originController,
              hint: 'From — origin or checkpoint',
              prefixIcon: _buildDotIndicator(Colors.green),
            ),
            const SizedBox(height: 12),

            // To Input
            _buildTextField(
              controller: _destinationController,
              hint: 'To — destination',
              prefixIcon: _buildDotIndicator(Colors.red),
            ),
            const SizedBox(height: 12),

            // Date Picker Placeholder
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) setState(() => _searchDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _searchDate == null
                          ? 'Select Date'
                          : '${_searchDate!.day}/${_searchDate!.month}/${_searchDate!.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _searchDate == null
                            ? Colors.grey[400]
                            : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Advanced Toggle
            TextButton(
              onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.grey[600],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced filters ${_activeFilterCount > 0 ? '($_activeFilterCount active)' : ''}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Icon(
                    _showAdvanced ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                  ),
                ],
              ),
            ),

            // Advanced Panel
            if (_showAdvanced)
              Container(
                padding: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[100]!)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _checkpointController,
                      hint: 'Search by checkpoint name',
                      prefixIcon: Icon(
                        Icons.navigation,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildFilterSection(
                      'Vehicle',
                      [
                        {'v': 'all', 'label': 'All'},
                        {'v': 'car', 'label': '🚗 Car'},
                        {'v': 'bike', 'label': '🏍 Bike'},
                        {'v': 'scooter', 'label': '🛵 Scooter'},
                      ],
                      _vehicleType,
                      (v) => setState(() => _vehicleType = v),
                    ),

                    _buildFilterSection(
                      'Price',
                      [
                        {'v': 'all', 'label': 'Any'},
                        {'v': 'low', 'label': '≤৳80'},
                        {'v': 'medium', 'label': '৳80–150'},
                        {'v': 'high', 'label': '>৳150'},
                      ],
                      _priceRange,
                      (v) => setState(() => _priceRange = v),
                    ),

                    _buildFilterSection(
                      'AC',
                      [
                        {'v': 'all', 'label': 'Any'},
                        {'v': 'yes', 'label': '❄️ AC'},
                        {'v': 'no', 'label': 'No AC'},
                      ],
                      _acFilter,
                      (v) => setState(() => _acFilter = v),
                    ),

                    _buildFilterSection(
                      'Sort by',
                      [
                        {'v': 'time', 'label': '🕐 Time'},
                        {'v': 'price', 'label': '💰 Price'},
                        {'v': 'rating', 'label': '⭐ Rating'},
                      ],
                      _sortBy,
                      (v) => setState(() => _sortBy = v),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),
            Row(
              children: [
                if (_activeFilterCount > 0) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAll,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        'Clear All',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showSearchPanel = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Show ${_filteredRides.length} ride${_filteredRides.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<Map<String, String>> options,
    String currentValue,
    Function(String) onSelect,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              return _buildChip(
                opt['label']!,
                currentValue == opt['v'],
                () => onSelect(opt['v']!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Widget prefixIcon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: prefixIcon,
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close, size: 14, color: Colors.grey[400]),
                onPressed: () => setState(() => controller.clear()),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[200]!, width: 2),
        ),
      ),
      onChanged: (val) => setState(() {}),
    );
  }

  Widget _buildDotIndicator(Color color) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildChip(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[600] : Colors.white,
          border: Border.all(
            color: isActive ? Colors.blue[600]! : Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 28, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          const Text(
            'No rides found',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your filters or check back later',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          if (_activeFilterCount > 0)
            ElevatedButton(
              onPressed: _clearAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
