import 'package:flutter/material.dart';
import 'package:fuel_app/services/station_service.dart';
import 'package:fuel_app/models/station_model.dart';
import 'package:fuel_app/auth/theme.dart';
import 'package:fuel_app/widgets/theme_toggle_button.dart';

class StationManagementScreen extends StatefulWidget {
  const StationManagementScreen({super.key});

  @override
  State<StationManagementScreen> createState() => _StationManagementScreenState();
}

class _StationManagementScreenState extends State<StationManagementScreen> {
  final StationService _stationService = StationService();
  List<StationModel> _stations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterStatus = 'all';
  bool _isAddingStation = false;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    setState(() => _isLoading = true);
    
    final result = await _stationService.getStations(
      search: _searchQuery.isEmpty ? null : _searchQuery,
      status: _filterStatus == 'all' ? null : _filterStatus,
    );
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _stations = result['stations'] ?? [];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load stations'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      });
    }
  }

  void _showAddStationDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final addressController = TextEditingController();
    final priceController = TextEditingController(text: '3.60');
    final fuelTypesController = TextEditingController(text: 'Petrol,Diesel,Gas');
    bool isOpen = true;
    bool is24_7 = false;
    double rating = 4.0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppTheme.gold.withOpacity(0.3)),
              ),
              title: Row(
                children: [
                  Icon(Icons.local_gas_station, color: AppTheme.gold),
                  const SizedBox(width: 8),
                  Text(
                    'Add New Station',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Station Name', nameController, isDark),
                    const SizedBox(height: 12),
                    _buildTextField('Location', locationController, isDark),
                    const SizedBox(height: 12),
                    _buildTextField('Address', addressController, isDark),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Price per Gallon',
                      priceController,
                      isDark,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Fuel Types (comma separated)',
                      fuelTypesController,
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSwitchTile(
                            '24/7 Open',
                            is24_7,
                            (val) => setStateDialog(() => is24_7 = val),
                            isDark,
                          ),
                        ),
                        Expanded(
                          child: _buildSwitchTile(
                            'Open Now',
                            isOpen,
                            (val) => setStateDialog(() => isOpen = val),
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Rating: ${rating.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: rating,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            activeColor: AppTheme.gold,
                            onChanged: (val) => setStateDialog(() => rating = val),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Station name is required')),
                      );
                      return;
                    }
                    
                    final newStation = StationModel(
                      name: nameController.text,
                      location: locationController.text,
                      address: addressController.text,
                      pricePerGallon: double.tryParse(priceController.text) ?? 3.60,
                      fuelTypes: fuelTypesController.text,
                      isOpen: isOpen,
                      is24_7: is24_7,
                      rating: rating,
                    );
                    
                    final result = await _stationService.createStation(newStation);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    
                    if (result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? 'Station added!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadStations();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? 'Failed to add station'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Station',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isDark, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.gold, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildSwitchTile(
    String label,
    bool value,
    Function(bool) onChanged,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.gold,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Station Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        actions: [
          CustomThemeToggle(
            iconColor: isDark ? Colors.white : Colors.black,
            bgColor: Colors.transparent,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                      onSubmitted: (_) => _loadStations(),
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Search stations...',
                        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                        prefixIcon: Icon(Icons.search, color: AppTheme.gold),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _filterStatus,
                    underline: const SizedBox(),
                    dropdownColor: cardColor,
                    style: TextStyle(color: textColor),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'open', child: Text('Open')),
                      DropdownMenuItem(value: 'closed', child: Text('Closed')),
                    ],
                    onChanged: (val) {
                      setState(() => _filterStatus = val ?? 'all');
                      _loadStations();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _showAddStationDialog,
                  backgroundColor: AppTheme.gold,
                  mini: true,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Station List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.gold))
                : _stations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_gas_station_outlined,
                              size: 64,
                              color: isDark ? Colors.white24 : Colors.black12,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No stations found',
                              style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black38,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to add one',
                              style: TextStyle(
                                color: isDark ? Colors.white24 : Colors.black26,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _stations.length,
                        itemBuilder: (context, index) {
                          final station = _stations[index];
                          return _buildStationCard(station, isDark);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationCard(StationModel station, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: station.isOpen ? AppTheme.gold.withOpacity(0.3) : Colors.red.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  station.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: station.isOpen ? AppTheme.gold : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  station.isOpen ? 'OPEN' : 'CLOSED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.gold, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  station.location,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '⭐ ${station.rating.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: AppTheme.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${station.reviewsCount} reviews',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '\$${station.pricePerGallon.toStringAsFixed(2)}/gal',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            station.fuelTypes,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme.gold, size: 18),
                onPressed: () => _showEditStationDialog(station),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 18),
                onPressed: () => _showDeleteConfirmation(station),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditStationDialog(StationModel station) {
    // Similar to add dialog but pre-filled with station data
    // Implementation similar to _showAddStationDialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit feature coming soon!')),
    );
  }

  void _showDeleteConfirmation(StationModel station) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red.withOpacity(0.3)),
          ),
          title: const Text(
            'Delete Station',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Are you sure you want to delete "${station.name}"?',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final result = await _stationService.deleteStation(station.id!);
                if (context.mounted) {
                  if (result['success']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _loadStations();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Failed to delete'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}