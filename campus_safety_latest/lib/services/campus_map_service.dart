import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:path_provider/path_provider.dart'; // Temporarily removed due to build tools conflict
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

class CampusMapService {
  static final CampusMapService _instance = CampusMapService._internal();
  factory CampusMapService() => _instance;
  CampusMapService._internal();

  // UUM Campus coordinates (Sintok, Kedah, Malaysia)
  static const LatLng uumCenter = LatLng(6.4676, 100.5067);
  static const double uumZoom = 15.0;
  
  // Campus boundaries (approximate)
  static const LatLng uumNorthEast = LatLng(6.4850, 100.5250);
  static const LatLng uumSouthWest = LatLng(6.4500, 100.4850);
  
  // Important campus locations
  static final Map<String, CampusLocation> campusLocations = {
    'main_gate': CampusLocation(
      'Main Gate',
      LatLng(6.4650, 100.5020),
      'Main entrance to UUM campus',
      LocationType.entrance,
    ),
    'chancellor_hall': CampusLocation(
      'Chancellor Hall',
      LatLng(6.4690, 100.5080),
      'Main auditorium and ceremony hall',
      LocationType.building,
    ),
    'library': CampusLocation(
      'Sultanah Bahiyah Library',
      LatLng(6.4680, 100.5070),
      'Main campus library',
      LocationType.building,
    ),
    'student_center': CampusLocation(
      'Student Affairs Center',
      LatLng(6.4670, 100.5060),
      'Student services and activities',
      LocationType.building,
    ),
    'medical_center': CampusLocation(
      'Medical Center',
      LatLng(6.4660, 100.5050),
      'Campus healthcare facility',
      LocationType.medical,
    ),
    'security_office': CampusLocation(
      'Security Office',
      LatLng(6.4655, 100.5025),
      'Campus security headquarters',
      LocationType.security,
    ),
    'parking_a': CampusLocation(
      'Parking Area A',
      LatLng(6.4645, 100.5030),
      'Main parking area',
      LocationType.parking,
    ),
    'parking_b': CampusLocation(
      'Parking Area B',
      LatLng(6.4695, 100.5090),
      'Secondary parking area',
      LocationType.parking,
    ),
    'residential_area': CampusLocation(
      'Residential Colleges',
      LatLng(6.4700, 100.5100),
      'Student accommodation area',
      LocationType.residential,
    ),
    'sports_complex': CampusLocation(
      'Sports Complex',
      LatLng(6.4720, 100.5110),
      'Athletic facilities and gymnasium',
      LocationType.recreation,
    ),
  };

  // Safety zones (well-lit, frequently patrolled areas)
  static final List<SafetyZone> safetyZones = [
    SafetyZone(
      'Main Campus Core',
      [
        LatLng(6.4665, 100.5040),
        LatLng(6.4695, 100.5040),
        LatLng(6.4695, 100.5100),
        LatLng(6.4665, 100.5100),
      ],
      SafetyLevel.high,
      'Well-lit area with regular security patrols',
    ),
    SafetyZone(
      'Library Vicinity',
      [
        LatLng(6.4675, 100.5065),
        LatLng(6.4685, 100.5065),
        LatLng(6.4685, 100.5085),
        LatLng(6.4675, 100.5085),
      ],
      SafetyLevel.high,
      '24/7 lighting and CCTV coverage',
    ),
    SafetyZone(
      'Parking Area A',
      [
        LatLng(6.4640, 100.5020),
        LatLng(6.4650, 100.5020),
        LatLng(6.4650, 100.5040),
        LatLng(6.4640, 100.5040),
      ],
      SafetyLevel.medium,
      'Moderate lighting, avoid after 10 PM',
    ),
    SafetyZone(
      'Residential Path',
      [
        LatLng(6.4690, 100.5090),
        LatLng(6.4710, 100.5090),
        LatLng(6.4710, 100.5120),
        LatLng(6.4690, 100.5120),
      ],
      SafetyLevel.low,
      'Poor lighting after 9 PM, use buddy system',
    ),
  ];

  String? _offlineMapPath;
  bool _isMapCacheInitialized = false;

  /// Initialize offline map cache
  Future<void> initializeOfflineMap() async {
    if (_isMapCacheInitialized) return;

    try {
      // Offline map functionality temporarily disabled due to build tools conflicts
      throw Exception('Offline map functionality coming soon');
      
      final cacheDir = Directory(_offlineMapPath!);
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      _isMapCacheInitialized = true;
      debugPrint('Offline map cache initialized at: $_offlineMapPath');
    } catch (e) {
      debugPrint('Error initializing offline map cache: $e');
    }
  }

  /// Download map tiles for offline use (call this when connected to WiFi)
  Future<void> downloadCampusMapTiles({
    int minZoom = 13,
    int maxZoom = 18,
    Function(int, int)? onProgress,
  }) async {
    if (!_isMapCacheInitialized) {
      await initializeOfflineMap();
    }

    try {
      int totalTiles = 0;
      int downloadedTiles = 0;

      // Calculate total tiles needed
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        final bounds = _calculateTileBounds(zoom);
        totalTiles += (bounds['maxX']! - bounds['minX']! + 1) * 
                     (bounds['maxY']! - bounds['minY']! + 1);
      }

      // Download tiles
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        final bounds = _calculateTileBounds(zoom);
        
        for (int x = bounds['minX']!; x <= bounds['maxX']!; x++) {
          for (int y = bounds['minY']!; y <= bounds['maxY']!; y++) {
            await _downloadTile(x, y, zoom);
            downloadedTiles++;
            onProgress?.call(downloadedTiles, totalTiles);
          }
        }
      }

      debugPrint('Downloaded $downloadedTiles tiles for offline use');
    } catch (e) {
      debugPrint('Error downloading map tiles: $e');
    }
  }

  /// Calculate tile bounds for UUM campus area
  Map<String, int> _calculateTileBounds(int zoom) {
    final minTile = _latLngToTile(uumSouthWest, zoom);
    final maxTile = _latLngToTile(uumNorthEast, zoom);
    
    return {
      'minX': minTile['x']!,
      'minY': minTile['y']!,
      'maxX': maxTile['x']!,
      'maxY': maxTile['y']!,
    };
  }

  /// Convert lat/lng to tile coordinates
  Map<String, int> _latLngToTile(LatLng latLng, int zoom) {
    final n = pow(2, zoom).toInt();
    final x = ((latLng.longitude + 180) / 360 * n).floor();
    final y = ((1 - log(tan(latLng.latitude * pi / 180) + 
               1 / cos(latLng.latitude * pi / 180)) / pi) / 2 * n).floor();
    
    return {'x': x, 'y': y};
  }

  /// Download individual tile
  Future<void> _downloadTile(int x, int y, int zoom) async {
    if (_offlineMapPath == null) return;

    final tileUrl = 'https://tile.openstreetmap.org/$zoom/$x/$y.png';
    final tilePath = '$_offlineMapPath/$zoom/$x';
    final tileFile = File('$tilePath/$y.png');

    // Skip if tile already exists
    if (await tileFile.exists()) return;

    try {
      final response = await http.get(Uri.parse(tileUrl));
      if (response.statusCode == 200) {
        await Directory(tilePath).create(recursive: true);
        await tileFile.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      debugPrint('Error downloading tile $x,$y,$zoom: $e');
    }
  }

  /// Get offline tile if available
  Future<Uint8List?> getOfflineTile(int x, int y, int zoom) async {
    if (_offlineMapPath == null) return null;

    final tileFile = File('$_offlineMapPath/$zoom/$x/$y.png');
    if (await tileFile.exists()) {
      return await tileFile.readAsBytes();
    }
    return null;
  }

  /// Create FlutterMap widget for UUM campus
  Widget createCampusMap({
    MapController? mapController,
    List<Marker>? additionalMarkers,
    List<Polyline>? routes,
    Function(LatLng)? onTap,
    Function(LatLng)? onLongPress,
  }) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: uumCenter,
        initialZoom: uumZoom,
        minZoom: 13.0,
        maxZoom: 18.0,
        // Restrict map bounds to UUM campus area
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(uumSouthWest, uumNorthEast),
        ),
        onTap: onTap != null ? (_, point) => onTap(point) : null,
        onLongPress: onLongPress != null ? (_, point) => onLongPress(point) : null,
      ),
      children: [
        // Base map layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.uum.safeguard',
        ),
        
        // Safety zones overlay
        PolygonLayer(
          polygons: safetyZones.map((zone) => Polygon(
            points: zone.boundary,
            color: zone.level.color.withOpacity(0.3),
            borderColor: zone.level.color,
            borderStrokeWidth: 2.0,
            label: zone.name,
          )).toList(),
        ),
        
        // Campus location markers
        MarkerLayer(
          markers: [
            ...campusLocations.values.map((location) => Marker(
              point: location.coordinates,
              width: 40,
              height: 40,
              child: Icon(
                location.type.icon,
                color: location.type.color,
                size: 30,
              ),
            )),
            if (additionalMarkers != null) ...additionalMarkers,
          ],
        ),
        
        // Routes overlay
        if (routes != null)
          PolylineLayer(polylines: routes),
      ],
    );
  }

  /// Get campus locations by type
  List<CampusLocation> getLocationsByType(LocationType type) {
    return campusLocations.values
        .where((location) => location.type == type)
        .toList();
  }

  /// Find nearest safety zone
  SafetyZone? findNearestSafetyZone(LatLng position) {
    double minDistance = double.infinity;
    SafetyZone? nearest;

    for (final zone in safetyZones) {
      final center = _calculatePolygonCenter(zone.boundary);
      final distance = _calculateDistance(position, center);
      
      if (distance < minDistance) {
        minDistance = distance;
        nearest = zone;
      }
    }

    return nearest;
  }

  /// Calculate distance between two points
  double _calculateDistance(LatLng point1, LatLng point2) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }

  /// Calculate polygon center
  LatLng _calculatePolygonCenter(List<LatLng> points) {
    double lat = 0;
    double lng = 0;
    
    for (final point in points) {
      lat += point.latitude;
      lng += point.longitude;
    }
    
    return LatLng(lat / points.length, lng / points.length);
  }

  /// Check if point is within campus bounds
  bool isWithinCampus(LatLng point) {
    return point.latitude >= uumSouthWest.latitude &&
           point.latitude <= uumNorthEast.latitude &&
           point.longitude >= uumSouthWest.longitude &&
           point.longitude <= uumNorthEast.longitude;
  }

  /// Get cache size
  Future<int> getCacheSize() async {
    if (_offlineMapPath == null) return 0;
    
    final cacheDir = Directory(_offlineMapPath!);
    if (!await cacheDir.exists()) return 0;
    
    int totalSize = 0;
    await for (final entity in cacheDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    
    return totalSize;
  }

  /// Clear map cache
  Future<void> clearCache() async {
    if (_offlineMapPath == null) return;
    
    final cacheDir = Directory(_offlineMapPath!);
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
      await cacheDir.create();
    }
  }
}

// Note: Offline tile provider will be implemented in a future update
// For now, the map uses online OpenStreetMap tiles with caching

// Data classes
class CampusLocation {
  final String name;
  final LatLng coordinates;
  final String description;
  final LocationType type;

  CampusLocation(this.name, this.coordinates, this.description, this.type);
}

enum LocationType {
  building,
  entrance,
  parking,
  medical,
  security,
  residential,
  recreation,
}

extension LocationTypeExtension on LocationType {
  IconData get icon {
    switch (this) {
      case LocationType.building:
        return Icons.business;
      case LocationType.entrance:
        return Icons.login;
      case LocationType.parking:
        return Icons.local_parking;
      case LocationType.medical:
        return Icons.local_hospital;
      case LocationType.security:
        return Icons.security;
      case LocationType.residential:
        return Icons.home;
      case LocationType.recreation:
        return Icons.sports;
    }
  }

  Color get color {
    switch (this) {
      case LocationType.building:
        return Colors.blue;
      case LocationType.entrance:
        return Colors.green;
      case LocationType.parking:
        return Colors.orange;
      case LocationType.medical:
        return Colors.red;
      case LocationType.security:
        return Colors.purple;
      case LocationType.residential:
        return Colors.brown;
      case LocationType.recreation:
        return Colors.teal;
    }
  }
}

class SafetyZone {
  final String name;
  final List<LatLng> boundary;
  final SafetyLevel level;
  final String description;

  SafetyZone(this.name, this.boundary, this.level, this.description);
}

enum SafetyLevel {
  high,
  medium,
  low,
}

extension SafetyLevelExtension on SafetyLevel {
  Color get color {
    switch (this) {
      case SafetyLevel.high:
        return Colors.green;
      case SafetyLevel.medium:
        return Colors.orange;
      case SafetyLevel.low:
        return Colors.red;
    }
  }

  String get label {
    switch (this) {
      case SafetyLevel.high:
        return 'Safe Zone';
      case SafetyLevel.medium:
        return 'Caution Zone';
      case SafetyLevel.low:
        return 'High Risk Zone';
    }
  }
}
