import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SecurityDashboardScreen extends StatefulWidget {
  const SecurityDashboardScreen({super.key});

  @override
  State<SecurityDashboardScreen> createState() => _SecurityDashboardScreenState();
}

class _SecurityDashboardScreenState extends State<SecurityDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data
  final List<EmergencyAlert> _emergencyAlerts = [
    EmergencyAlert(
      id: 'SOS-001',
      userName: 'Sarah Johnson',
      userRole: 'Student',
      location: 'Library Building, Floor 2',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: EmergencyStatus.active,
    ),
    EmergencyAlert(
      id: 'SOS-002',
      userName: 'Michael Chen',
      userRole: 'Student',
      location: 'Parking Lot C',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      status: EmergencyStatus.active,
    ),
  ];
  
  final List<ActiveJourney> _activeJourneys = [
    ActiveJourney(
      id: 'JRN-001',
      userName: 'Aisha Rahman',
      userRole: 'Student',
      startLocation: 'Main Hall',
      destination: 'Residential College 3',
      startTime: DateTime.now().subtract(const Duration(minutes: 8)),
      estimatedDuration: 15,
    ),
    ActiveJourney(
      id: 'JRN-002',
      userName: 'David Wilson',
      userRole: 'Staff',
      startLocation: 'Admin Building',
      destination: 'Parking Lot A',
      startTime: DateTime.now().subtract(const Duration(minutes: 3)),
      estimatedDuration: 10,
    ),
    ActiveJourney(
      id: 'JRN-003',
      userName: 'Lisa Wong',
      userRole: 'Student',
      startLocation: 'Science Building',
      destination: 'Bus Stop',
      startTime: DateTime.now().subtract(const Duration(minutes: 15)),
      estimatedDuration: 20,
    ),
  ];
  
  final List<IncidentReport> _incidentReports = [
    IncidentReport(
      id: 'RPT-001',
      title: 'Suspicious Person',
      location: 'Near Library Entrance',
      category: 'Suspicious Activity',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      status: IncidentStatus.new_,
      description: 'Person in black hoodie loitering around the library entrance for over 30 minutes.',
    ),
    IncidentReport(
      id: 'RPT-002',
      title: 'Broken Street Light',
      location: 'Pathway between Blocks A and B',
      category: 'Safety Hazard',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      status: IncidentStatus.inProgress,
      description: 'Street light is not working, making the pathway very dark at night.',
    ),
    IncidentReport(
      id: 'RPT-003',
      title: 'Lost Wallet',
      location: 'Cafeteria',
      category: 'Lost Item',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: IncidentStatus.resolved,
      description: 'Black leather wallet lost during lunch time.',
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Emergencies'),
            Tab(text: 'Active Journeys'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmergenciesTab(),
          _buildActiveJourneysTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show campus-wide alert dialog
        },
        backgroundColor: AppTheme.dangerColor,
        child: const Icon(Icons.campaign),
        tooltip: 'Send Campus Alert',
      ),
    );
  }
  
  Widget _buildEmergenciesTab() {
    return _emergencyAlerts.isEmpty
        ? _buildEmptyState(
            icon: Icons.emergency,
            title: 'No Active Emergencies',
            subtitle: 'All emergency alerts will appear here',
          )
        : ListView.builder(
            itemCount: _emergencyAlerts.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final alert = _emergencyAlerts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: AppTheme.dangerColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppTheme.dangerColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.emergency,
                            color: AppTheme.dangerColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Emergency Alert',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.dangerColor,
                            ),
                          ),
                          const Spacer(),
                          _buildStatusChip(alert.status.toString().split('.').last),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        alert.userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        alert.userRole,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.location_on, 'Location', alert.location),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.access_time,
                        'Time',
                        _formatTimestamp(alert.timestamp),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Show location on map
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('View on Map'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Respond to emergency
                              },
                              icon: const Icon(Icons.phone),
                              label: const Text('Respond'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.dangerColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
  
  Widget _buildActiveJourneysTab() {
    return _activeJourneys.isEmpty
        ? _buildEmptyState(
            icon: Icons.directions_walk,
            title: 'No Active Journeys',
            subtitle: 'Students and staff using Walk With Me will appear here',
          )
        : ListView.builder(
            itemCount: _activeJourneys.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final journey = _activeJourneys[index];
              
              // Calculate elapsed time
              final elapsedMinutes = DateTime.now().difference(journey.startTime).inMinutes;
              final progress = elapsedMinutes / journey.estimatedDuration;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.directions_walk,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Active Journey',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.infoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${journey.estimatedDuration} min',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.infoColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        journey.userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        journey.userRole,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.play_arrow, 'From', journey.startLocation),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.flag, 'To', journey.destination),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.access_time,
                        'Started',
                        _formatTimestamp(journey.startTime),
                      ),
                      const SizedBox(height: 16),
                      // Progress bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress: ${(progress * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress > 1.0 ? AppTheme.warningColor : AppTheme.primaryColor,
                            ),
                          ),
                          if (progress > 1.0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Journey taking longer than expected',
                                style: TextStyle(
                                  color: AppTheme.warningColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Track journey on map
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Track Journey'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
  
  Widget _buildReportsTab() {
    return _incidentReports.isEmpty
        ? _buildEmptyState(
            icon: Icons.report,
            title: 'No Incident Reports',
            subtitle: 'Reported incidents will appear here',
          )
        : ListView.builder(
            itemCount: _incidentReports.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final report = _incidentReports[index];
              
              // Determine card color based on status
              Color statusColor;
              switch (report.status) {
                case IncidentStatus.new_:
                  statusColor = AppTheme.warningColor;
                  break;
                case IncidentStatus.inProgress:
                  statusColor = AppTheme.infoColor;
                  break;
                case IncidentStatus.resolved:
                  statusColor = AppTheme.successColor;
                  break;
              }
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: statusColor.withOpacity(0.5), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.report,
                            color: statusColor,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              report.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _buildStatusChip(_formatStatus(report.status)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        report.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.location_on, 'Location', report.location),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.access_time,
                        'Reported',
                        _formatTimestamp(report.timestamp),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(report.description),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Show location on map
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('View on Map'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Update incident status
                              },
                              icon: const Icon(Icons.assignment),
                              label: Text(
                                report.status == IncidentStatus.resolved
                                    ? 'Details'
                                    : 'Respond',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: statusColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppTheme.textTertiaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'active':
      case 'new':
        chipColor = AppTheme.dangerColor;
        break;
      case 'in progress':
        chipColor = AppTheme.infoColor;
        break;
      case 'resolved':
        chipColor = AppTheme.successColor;
        break;
      default:
        chipColor = AppTheme.textSecondaryColor;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: chipColor,
        ),
      ),
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
  
  String _formatStatus(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.new_:
        return 'New';
      case IncidentStatus.inProgress:
        return 'In Progress';
      case IncidentStatus.resolved:
        return 'Resolved';
    }
  }
}

// Models
enum EmergencyStatus {
  active,
  resolved,
}

class EmergencyAlert {
  final String id;
  final String userName;
  final String userRole;
  final String location;
  final DateTime timestamp;
  final EmergencyStatus status;
  
  EmergencyAlert({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.location,
    required this.timestamp,
    required this.status,
  });
}

class ActiveJourney {
  final String id;
  final String userName;
  final String userRole;
  final String startLocation;
  final String destination;
  final DateTime startTime;
  final int estimatedDuration; // in minutes
  
  ActiveJourney({
    required this.id,
    required this.userName,
    required this.userRole,
    required this.startLocation,
    required this.destination,
    required this.startTime,
    required this.estimatedDuration,
  });
}

enum IncidentStatus {
  new_,
  inProgress,
  resolved,
}

class IncidentReport {
  final String id;
  final String title;
  final String location;
  final String category;
  final DateTime timestamp;
  final IncidentStatus status;
  final String description;
  
  IncidentReport({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.timestamp,
    required this.status,
    required this.description,
  });
}
