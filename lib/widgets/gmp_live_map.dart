// Source: Google Maps Platform Code Assist
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import 'interactive_map_canvas.dart';

class GMPLiveMap extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupLabel;
  final String dropoffLabel;
  final double progress; // 0.0 to 1.0
  final bool enableZoomControls;
  final bool isInteractive;
  final bool showMapControls;
  final bool forceCanvas;

  const GMPLiveMap({
    super.key,
    this.pickupLocation = const LatLng(
      AppConstants.wuseMarketLat,
      AppConstants.wuseMarketLng,
    ),
    this.dropoffLocation = const LatLng(
      AppConstants.aminuKanoLat,
      AppConstants.aminuKanoLng,
    ),
    this.pickupLabel = 'Wuse Market',
    this.dropoffLabel = '12 Aminu Kano Crescent',
    this.progress = 0.45,
    this.enableZoomControls = false,
    this.isInteractive = true,
    this.showMapControls = true,
    this.forceCanvas = false,
  });

  @override
  State<GMPLiveMap> createState() => _GMPLiveMapState();
}

class _GMPLiveMapState extends State<GMPLiveMap> {
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  bool _mapRenderFailed = false;
  bool _isFollowingRider = false;

  void _handleMapError() {
    if (mounted && !_mapRenderFailed) {
      setState(() {
        _mapRenderFailed = true;
      });
    }
  }

  bool get _canUseGoogleMaps {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  LatLng get _riderLocation {
    // Interpolate rider location along line between pickup and dropoff
    final pLat = widget.pickupLocation.latitude;
    final pLng = widget.pickupLocation.longitude;
    final dLat = widget.dropoffLocation.latitude;
    final dLng = widget.dropoffLocation.longitude;

    final lat = pLat + (dLat - pLat) * widget.progress;
    final lng = pLng + (dLng - pLng) * widget.progress;
    return LatLng(lat, lng);
  }

  LatLng get _centerPoint {
    return LatLng(
      (widget.pickupLocation.latitude + widget.dropoffLocation.latitude) / 2,
      (widget.pickupLocation.longitude + widget.dropoffLocation.longitude) / 2,
    );
  }

  @override
  void didUpdateWidget(covariant GMPLiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.pickupLocation != widget.pickupLocation ||
        oldWidget.dropoffLocation != widget.dropoffLocation) {
      if (_controllerCompleter.isCompleted) {
        _controllerCompleter.future.then((controller) {
          if (!mounted) return;
          if (_isFollowingRider) {
            _animateToRider(controller);
          } else {
            _adjustCameraBounds(controller);
          }
        });
      }
    }
  }

  Set<Marker> _buildMarkers(BuildContext context) {
    return {
      // Pickup Store Marker
      Marker(
        markerId: const MarkerId('pickup_store'),
        position: widget.pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: 'Store Pickup: ${widget.pickupLabel}',
          snippet: 'Collect package',
        ),
      ),

      // Dropoff Destination Marker
      Marker(
        markerId: const MarkerId('dropoff_dest'),
        position: widget.dropoffLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Customer: ${widget.dropoffLabel}',
          snippet: 'Destination',
        ),
      ),

      // Live Rider Vehicle Marker
      Marker(
        markerId: const MarkerId('rider_live'),
        position: _riderLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(
          title: '🛵 Rider Live Position',
          snippet: 'En Route',
        ),
      ),
    };
  }

  Set<Polyline> _buildPolylines(bool isDark) {
    // Street-following polyline coordinates between Wuse Market and Aminu Kano
    final intermediatePoints = [
      widget.pickupLocation,
      LatLng(
        widget.pickupLocation.latitude + 0.0030,
        widget.pickupLocation.longitude + 0.0060,
      ),
      LatLng(
        widget.pickupLocation.latitude + 0.0070,
        widget.pickupLocation.longitude + 0.0120,
      ),
      widget.dropoffLocation,
    ];

    return {
      Polyline(
        polylineId: const PolylineId('delivery_route_background'),
        points: intermediatePoints,
        color: isDark ? const Color(0xFF42424E) : const Color(0xFFCFD2DC),
        width: 6,
      ),
      Polyline(
        polylineId: const PolylineId('delivery_route_active'),
        points: intermediatePoints,
        color: AppColors.primary,
        width: 4,
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    try {
      if (!_controllerCompleter.isCompleted) {
        _controllerCompleter.complete(controller);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _adjustCameraBounds(controller);
        }
      });
    } catch (_) {
      _handleMapError();
    }
  }

  Future<void> _adjustCameraBounds(GoogleMapController controller) async {
    try {
      final southwestLat = widget.pickupLocation.latitude < widget.dropoffLocation.latitude
          ? widget.pickupLocation.latitude
          : widget.dropoffLocation.latitude;
      final southwestLng = widget.pickupLocation.longitude < widget.dropoffLocation.longitude
          ? widget.pickupLocation.longitude
          : widget.dropoffLocation.longitude;

      final northeastLat = widget.pickupLocation.latitude > widget.dropoffLocation.latitude
          ? widget.pickupLocation.latitude
          : widget.dropoffLocation.latitude;
      final northeastLng = widget.pickupLocation.longitude > widget.dropoffLocation.longitude
          ? widget.pickupLocation.longitude
          : widget.dropoffLocation.longitude;

      final bounds = LatLngBounds(
        southwest: LatLng(southwestLat - 0.004, southwestLng - 0.004),
        northeast: LatLng(northeastLat + 0.004, northeastLng + 0.004),
      );

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0),
      );
    } catch (_) {
      try {
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _centerPoint, zoom: 14.5),
          ),
        );
      } catch (_) {}
    }
  }

  Future<void> _animateToRider(GoogleMapController controller) async {
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _riderLocation, zoom: 16.0),
        ),
      );
    } catch (_) {}
  }

  Future<void> _zoomIn() async {
    if (_controllerCompleter.isCompleted) {
      final controller = await _controllerCompleter.future;
      controller.animateCamera(CameraUpdate.zoomIn());
    }
  }

  Future<void> _zoomOut() async {
    if (_controllerCompleter.isCompleted) {
      final controller = await _controllerCompleter.future;
      controller.animateCamera(CameraUpdate.zoomOut());
    }
  }

  Future<void> _toggleRiderFocus() async {
    setState(() {
      _isFollowingRider = !_isFollowingRider;
    });
    if (_controllerCompleter.isCompleted) {
      final controller = await _controllerCompleter.future;
      if (_isFollowingRider) {
        _animateToRider(controller);
      } else {
        _adjustCameraBounds(controller);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Graceful fallback if platform doesn't support Google Maps natively, forced canvas, or map failed
    if (widget.forceCanvas || !_canUseGoogleMaps || _mapRenderFailed) {
      return InteractiveMapCanvas(
        progress: widget.progress,
        pickupLabel: widget.pickupLabel,
        dropoffLabel: widget.dropoffLabel,
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _centerPoint,
            zoom: 14.5,
          ),
          onMapCreated: _onMapCreated,
          markers: _buildMarkers(context),
          polylines: _buildPolylines(isDark),
          style: isDark ? AppConstants.darkMapStyle : AppConstants.lightMapStyle,
          zoomControlsEnabled: widget.enableZoomControls,
          compassEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          scrollGesturesEnabled: widget.isInteractive,
          zoomGesturesEnabled: widget.isInteractive,
          rotateGesturesEnabled: widget.isInteractive,
          tiltGesturesEnabled: false,
        ),

        // Attribution & GPS Status Badge on top-right
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context).withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.getCardBorder(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.onlineGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.pin_drop_rounded, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Abuja Live GPS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Optional Quick Floating Map Controls (Recenter, Zoom)
        if (widget.showMapControls)
          Positioned(
            left: 12,
            top: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Recenter / Toggle Rider Follow Button
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context).withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.getCardBorder(context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                    tooltip: _isFollowingRider ? 'View Route Overview' : 'Center on Rider',
                    icon: Icon(
                      _isFollowingRider ? Icons.navigation_rounded : Icons.my_location_rounded,
                      color: _isFollowingRider ? AppColors.primary : AppColors.getTextPrimary(context),
                    ),
                    onPressed: _toggleRiderFocus,
                  ),
                ),
                const SizedBox(height: 6),
                // Zoom In
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context).withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.getCardBorder(context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Zoom In',
                    icon: Icon(Icons.add_rounded, color: AppColors.getTextPrimary(context)),
                    onPressed: _zoomIn,
                  ),
                ),
                const SizedBox(height: 6),
                // Zoom Out
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context).withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.getCardBorder(context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 18,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Zoom Out',
                    icon: Icon(Icons.remove_rounded, color: AppColors.getTextPrimary(context)),
                    onPressed: _zoomOut,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
