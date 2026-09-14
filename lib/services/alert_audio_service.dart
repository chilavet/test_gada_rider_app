import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Service responsible for playing loud, looping auditory and haptic alerts
/// when an incoming delivery request is dispatched to the rider.
class AlertAudioService {
  static final AlertAudioService instance = AlertAudioService._internal();

  AlertAudioService._internal();

  AudioPlayer? _player;
  Timer? _vibrateTimer;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  /// Starts the loud, looping incoming order alert tone and haptics.
  Future<void> playIncomingOrderAlert() async {
    if (_isPlaying) return;
    _isPlaying = true;

    try {
      _player ??= AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(1.0);
      await _player!.play(AssetSource('sounds/order_alert.wav'));
    } catch (_) {
      // Audio playback fallback in headless or restricted environments
    }

    // Accompanying haptic feedback loop for riders on motorcycles
    try {
      HapticFeedback.heavyImpact();
      _vibrateTimer?.cancel();
      _vibrateTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        if (_isPlaying) {
          HapticFeedback.vibrate();
        } else {
          _vibrateTimer?.cancel();
        }
      });
    } catch (_) {}
  }

  /// Stops the alert sound and vibration immediately (on accept, decline, or timeout).
  Future<void> stopAlert() async {
    _isPlaying = false;
    _vibrateTimer?.cancel();
    _vibrateTimer = null;

    try {
      await _player?.stop();
    } catch (_) {}
  }
}
