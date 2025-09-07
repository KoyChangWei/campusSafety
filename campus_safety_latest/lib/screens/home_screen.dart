import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import '../widgets/sos_button.dart';
import '../screens/camera_detection_screen.dart';
import '../screens/report_incident_screen.dart';
import '../screens/safety_assessment_screen.dart';
import '../screens/camera_screen.dart';
import 'walk_with_me_screen.dart';
import 'trusted_contacts_screen.dart';
import 'settings_screen.dart';
import '../services/campus_map_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const _DashboardScreen(),
    const _MapScreen(),
    const _SOSScreen(), // SOS screen when button is pressed
    const _ReportsScreen(),
    const _ProfileScreen(),
  ];
  
  final List<String> _titles = [
    'Dashboard',
    'Map',
    '',
    'Reports',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _currentIndex != 2 ? AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          // Notifications Icon
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications screen
            },
          ),
        ],
      ) : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotch(),
        height: 65, // Set a fixed height
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Dashboard Tab
              Expanded(child: _buildNavItem(0, Icons.dashboard, 'Dashboard')),
            
            // Map Tab
              Expanded(child: _buildNavItem(1, Icons.map, 'Map')),
            
            // SOS Button (Empty space)
            const SizedBox(width: 80),
            
            // Reports Tab
              Expanded(child: _buildNavItem(3, Icons.report, 'Reports')),
            
            // Profile Tab
              Expanded(child: _buildNavItem(4, Icons.person, 'Profile')),
          ],
        ),
      ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => setState(() => _currentIndex = 2),
        child: const SOSButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
            size: 24,
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : AppTheme.textSecondaryColor,
            ),
          const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
              fontSize: 10,
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : AppTheme.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            ),
          ],
      ),
    );
  }
}

// Custom notch shape for the bottom app bar
class CircularNotch extends NotchedShape {
  const CircularNotch();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    final double notchRadius = guest.width / 2;

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = sqrt(b * b * r * r * (1.0 - b * b / (b * b + a * a)));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = sqrt(r * r - p2xA * p2xA);
    final double p2yB = sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = List<Offset>.filled(6, Offset.zero);

    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    for (int i = 0; i < p.length; i += 1) {
      p[i] += guest.center;
    }

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(
        p[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

// Main Dashboard Screen with all core features
class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(context),
          const SizedBox(height: 24),
          
          // Quick Actions Grid
          _buildQuickActionsGrid(context),
          const SizedBox(height: 24),
          
          // Safety Status
          _buildSafetyStatus(context),
          const SizedBox(height: 24),
          
          // Recent Activity
          _buildRecentActivity(context),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Stay safe on campus',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildActionCard(
              context,
              'Walk With Me',
              Icons.directions_walk,
              AppTheme.primaryColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalkWithMeScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Safety Assessment',
              Icons.security,
              AppTheme.secondaryColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SafetyAssessmentScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Camera Detection',
              Icons.camera_alt,
              AppTheme.successColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CameraScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Report Incident',
              Icons.report,
              AppTheme.warningColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
              ),
            ),
            _buildActionCard(
              context,
              'Trusted Contacts',
              Icons.contacts,
              AppTheme.successColor,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrustedContactsScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSafetyStatus(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield, color: AppTheme.successColor),
                const SizedBox(width: 8),
                Text(
                  'Safety Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem('Location', 'Active', AppTheme.successColor),
                ),
                Expanded(
                  child: _buildStatusItem('Battery', '85%', AppTheme.successColor),
                ),
                Expanded(
                  child: _buildStatusItem('Signal', 'Strong', AppTheme.successColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildActivityItem('Walk completed', '2 hours ago', Icons.check_circle, AppTheme.successColor),
            _buildActivityItem('Report submitted', '1 day ago', Icons.report, AppTheme.warningColor),
            _buildActivityItem('Contact added', '3 days ago', Icons.person_add, AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(time, style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Map Screen with geofencing and live tracking
class _MapScreen extends StatefulWidget {
  const _MapScreen();

  @override
  State<_MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<_MapScreen> {
  bool _isLocationSharing = false;
  late MapController _mapController;
  final CampusMapService _mapService = CampusMapService();
  bool _showSafetyZones = true;
  bool _showCampusLocations = true;
  
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeMap();
  }
  
  Future<void> _initializeMap() async {
    await _mapService.initializeOfflineMap();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // UUM Campus Map
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Campus map
              _mapService.createCampusMap(
                mapController: _mapController,
                onTap: (LatLng point) {
                  _showLocationInfo(point);
                },
                onLongPress: (LatLng point) {
                  _showLocationOptions(point);
                },
              ),
              
              // Map controls overlay
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    // Zoom to campus button
                    FloatingActionButton.small(
                      onPressed: () => _mapController.move(CampusMapService.uumCenter, CampusMapService.uumZoom),
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.my_location, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    
                    // Toggle safety zones
                    FloatingActionButton.small(
                      onPressed: () => setState(() => _showSafetyZones = !_showSafetyZones),
                      backgroundColor: _showSafetyZones ? AppTheme.primaryColor : Colors.white,
                      child: Icon(
                        Icons.shield,
                        color: _showSafetyZones ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Toggle campus locations
                    FloatingActionButton.small(
                      onPressed: () => setState(() => _showCampusLocations = !_showCampusLocations),
                      backgroundColor: _showCampusLocations ? AppTheme.primaryColor : Colors.white,
                      child: Icon(
                        Icons.location_on,
                        color: _showCampusLocations ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Map legend
              if (_showSafetyZones || _showCampusLocations)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Legend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          if (_showSafetyZones) ...[
                            const SizedBox(height: 4),
                            _buildLegendItem('Safe Zone', Colors.green),
                            _buildLegendItem('Caution Zone', Colors.orange),
                            _buildLegendItem('High Risk Zone', Colors.red),
                          ],
                          if (_showCampusLocations) ...[
                            const SizedBox(height: 4),
                            _buildLegendItem('Security', Colors.purple),
                            _buildLegendItem('Medical', Colors.red),
                            _buildLegendItem('Parking', Colors.orange),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Controls Panel
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
      child: Column(
            children: [
              // Location sharing toggle
              Row(
        children: [
                  Icon(
                    _isLocationSharing ? Icons.location_on : Icons.location_off,
                    color: _isLocationSharing ? AppTheme.successColor : AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isLocationSharing ? 'Location sharing active' : 'Location sharing off',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Switch(
                    value: _isLocationSharing,
                    onChanged: (value) => setState(() => _isLocationSharing = value),
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
              
          const SizedBox(height: 16),
              
              // Quick action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WalkWithMeScreen()),
                      ),
                      icon: const Icon(Icons.directions_walk),
                      label: const Text('Walk With Me'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showGeofenceAlerts,
                      icon: const Icon(Icons.notifications),
                      label: const Text('Alerts'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              border: Border.all(color: color, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
  
  void _showLocationInfo(LatLng point) {
    // Find nearest campus location
    CampusLocation? nearestLocation;
    double minDistance = double.infinity;
    
    for (final location in CampusMapService.campusLocations.values) {
      final distance = _calculateDistance(point, location.coordinates);
      if (distance < minDistance && distance < 100) { // Within 100 meters
        minDistance = distance;
        nearestLocation = location;
      }
    }
    
    if (nearestLocation != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(nearestLocation!.type.icon, color: nearestLocation!.type.color),
                  const SizedBox(width: 8),
                  Text(nearestLocation!.name, style: Theme.of(context).textTheme.titleLarge),
                ],
          ),
          const SizedBox(height: 8),
              Text(nearestLocation!.description),
          const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to this location
                        _mapController.move(nearestLocation!.coordinates, 17.0);
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text('Navigate'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showLocationOptions(nearestLocation!.coordinates);
                      },
                      icon: const Icon(Icons.more_horiz),
                      label: const Text('Options'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
  
  void _showLocationOptions(LatLng point) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Location Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.directions_walk, color: AppTheme.primaryColor),
              title: const Text('Start Walk With Me'),
              subtitle: const Text('Share location while walking to this point'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Start Walk With Me to this location
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: AppTheme.warningColor),
              title: const Text('Report Incident'),
              subtitle: const Text('Report a safety concern at this location'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppTheme.primaryColor),
              title: const Text('Share Location'),
              subtitle: const Text('Send this location to trusted contacts'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Share location via SMS
              },
            ),
          ],
        ),
      ),
    );
  }
  
  double _calculateDistance(LatLng point1, LatLng point2) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }
  
  void _showGeofenceAlerts() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
              'Campus Safety Alerts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...CampusMapService.safetyZones.map((zone) => _buildAlertItem(
              zone.name,
              zone.description,
              zone.level.color,
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAlertItem(String location, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.location_on, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(description, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// SOS Screen - activated when SOS button is pressed
class _SOSScreen extends StatefulWidget {
  const _SOSScreen();

  @override
  State<_SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<_SOSScreen> {
  bool _isSOSActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isSOSActive ? AppTheme.dangerColor : AppTheme.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              // SOS Status
              Icon(
                _isSOSActive ? Icons.emergency : Icons.shield,
                size: 120,
                color: _isSOSActive ? Colors.white : AppTheme.primaryColor,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                _isSOSActive ? 'SOS ACTIVE' : 'Emergency Services',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: _isSOSActive ? Colors.white : AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
          const SizedBox(height: 16),
              
          Text(
                _isSOSActive 
                  ? 'Help is on the way!\nYour location has been shared with campus security and trusted contacts.'
                  : 'Press and hold the SOS button to activate emergency alert',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _isSOSActive ? Colors.white : AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              if (_isSOSActive) ...[
                ElevatedButton(
                  onPressed: () => setState(() => _isSOSActive = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.dangerColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Cancel SOS'),
                ),
              ] else ...[
                const SOSButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Reports Screen with incident management
class _ReportsScreen extends StatelessWidget {
  const _ReportsScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Report Button
          Card(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportIncidentScreen()),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: AppTheme.primaryColor, size: 32),
                    SizedBox(width: 16),
                    Expanded(
      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                          Text('Report New Incident', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Submit a safety concern or incident report', style: TextStyle(color: AppTheme.textSecondaryColor)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Recent Reports',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 16),
          
          // Mock reports list
          _buildReportItem(
            'Suspicious Activity',
            'Library parking lot',
            'Under review',
            AppTheme.warningColor,
            '2 hours ago',
          ),
          _buildReportItem(
            'Poor Lighting',
            'Walking path near dorms',
            'Resolved',
            AppTheme.successColor,
            '1 day ago',
          ),
          _buildReportItem(
            'Harassment',
            'Student center',
            'In progress',
            AppTheme.primaryColor,
            '3 days ago',
          ),
        ],
      ),
    );
  }
  
  Widget _buildReportItem(String title, String location, String status, Color statusColor, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(location, style: const TextStyle(color: AppTheme.textSecondaryColor)),
                ),
                Text(time, style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen with user settings and accessibility
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primaryColor,
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text('Student ID: 12345678'),
                        const Text('john.doe@student.uum.edu.my'),
                      ],
                    ),
          ),
        ],
      ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Menu Items
          _buildMenuItem(
            context,
            'Trusted Contacts',
            Icons.contacts,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrustedContactsScreen())),
          ),
          _buildMenuItem(
            context,
            'Accessibility Settings',
            Icons.accessibility,
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          _buildMenuItem(
            context,
            'Emergency Contacts',
        Icons.emergency,
            () => _showEmergencyContacts(context),
          ),
          _buildMenuItem(
            context,
            'Privacy & Safety',
            Icons.privacy_tip,
            () => _showPrivacySettings(context),
          ),
          _buildMenuItem(
            context,
            'Help & Support',
            Icons.help,
            () => _showHelpSupport(context),
          ),
          _buildMenuItem(
            context,
            'About',
            Icons.info,
            () => _showAbout(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
  
  void _showEmergencyContacts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency Contacts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildContactItem('Campus Security', '+60 4-928 4911'),
            _buildContactItem('Medical Emergency', '999'),
            _buildContactItem('Police', '999'),
            _buildContactItem('Fire Department', '994'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactItem(String name, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.phone, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(number, style: const TextStyle(color: AppTheme.textSecondaryColor)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {}, // TODO: Implement call functionality
            icon: const Icon(Icons.call, color: AppTheme.successColor),
          ),
        ],
      ),
    );
  }
  
  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Safety'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your privacy and safety are our top priorities.'),
            SizedBox(height: 16),
            Text('• Location data is only shared during active SOS or Walk With Me sessions'),
            Text('• Reports can be submitted anonymously'),
            Text('• All data is encrypted and secure'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Here are your options:'),
            SizedBox(height: 16),
            Text('📧 Email: support@uum.edu.my'),
            Text('📞 Phone: +60 4-928 4000'),
            Text('🏢 Visit: IT Support Center'),
            SizedBox(height: 16),
            Text('For emergencies, always call 999 or use the SOS button.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About UUM SafeGuard'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UUM SafeGuard v1.0'),
            SizedBox(height: 8),
            Text('Campus Safety & Security App'),
            SizedBox(height: 16),
            Text('Developed for Universiti Utara Malaysia'),
            Text('© 2024 UUM SafeGuard Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
