class AppConstants {
  static const String appName = 'Gadaride';
  static const String officeLocation =
      'Bb03, Hillside Plaza, Yakubu Gowon Crescent, Asokoro, Abuja';
  static const String officeLocationShort =
      'Bb03, Hillside Plaza, Asokoro, Abuja';
  static const String supportPhone = '+234 800 4232 7433';
  static const String supportEmail = 'support@gadaride.ng';

  // Google Maps Platform Integration
  static const String gmpUsageAttributionId = 'gmp_git_agentskills_v1';
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  // Abuja Coordinates
  static const double defaultLatAbuja = 9.0667;
  static const double defaultLngAbuja = 7.4500;
  static const double wuseMarketLat = 9.0667;
  static const double wuseMarketLng = 7.4500;
  static const double aminuKanoLat = 9.0782;
  static const double aminuKanoLng = 7.4725;
  static const double mamaNkechiLat = 9.0435;
  static const double mamaNkechiLng = 7.4950;
  static const double asokoroOfficeLat = 9.0435;
  static const double asokoroOfficeLng = 7.5255;

  // Google Maps Dark Style JSON
  static const String darkMapStyle = r'''
[
  {"elementType": "geometry", "stylers": [{"color": "#181920"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#8E92A0"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#181920"}]},
  {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#D0D4E0"}]},
  {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#6E7282"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#1E2A22"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#282936"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#20212C"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#E05A00"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#9E3C00"}]},
  {"featureType": "transit", "elementType": "geometry", "stylers": [{"color": "#242533"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#101624"}]}
]
''';

  // Google Maps Light Style JSON
  static const String lightMapStyle = r'''
[
  {"elementType": "geometry", "stylers": [{"color": "#F5F6F8"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#525666"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#FFFFFF"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#FFFFFF"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#E4E6EB"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#FFE5D1"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#FFA766"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#DCE9FA"}]}
]
''';
}

