import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';
import '../../state/rider_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSunsetSwitch = true;
  bool _loudAlerts = true;
  bool _vibrateOnJob = true;
  bool _voiceGuidance = true;
  String _navApp = 'Google Maps';

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section 1: Display & Theme Mode
              _sectionHeader(context, 'Display & Appearance'),
              _nightDayModeCard(context, state),
              const SizedBox(height: 20),

              // Section 2: Navigation & Route Preferences
              _sectionHeader(context, 'Navigation & Sound'),
              _cardContainer(
                context,
                children: [
                  _switchTile(
                    context: context,
                    icon: Icons.volume_up_outlined,
                    title: 'Loud Order Alerts',
                    subtitle: 'Play high-volume alert chime for new job offers while on motorbike',
                    value: _loudAlerts,
                    onChanged: (val) => setState(() => _loudAlerts = val),
                  ),
                  _divider(context),
                  _switchTile(
                    context: context,
                    icon: Icons.vibration_rounded,
                    title: 'Vibrate on New Job',
                    subtitle: 'Vibrate phone for incoming delivery requests',
                    value: _vibrateOnJob,
                    onChanged: (val) => setState(() => _vibrateOnJob = val),
                  ),
                  _divider(context),
                  _switchTile(
                    context: context,
                    icon: Icons.record_voice_over_outlined,
                    title: 'Voice Navigation Prompts',
                    subtitle: 'Spoken turn-by-turn guidance during active trips',
                    value: _voiceGuidance,
                    onChanged: (val) => setState(() => _voiceGuidance = val),
                  ),
                  _divider(context),
                  _dropdownTile(
                    context: context,
                    icon: Icons.map_outlined,
                    title: 'Default Navigation App',
                    currentValue: _navApp,
                    options: const ['Google Maps', 'Apple Maps', 'In-App Vector Map'],
                    onChanged: (val) {
                      if (val != null) setState(() => _navApp = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Section 3: App Information
              _sectionHeader(context, 'About App'),
              _cardContainer(
                context,
                children: [
                  _infoTile(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: 'App Version',
                    value: '1.0.0 (Build 42)',
                  ),
                  _divider(context),
                  _infoTile(
                    context: context,
                    icon: Icons.location_on_outlined,
                    title: 'Head Office',
                    value: AppConstants.officeLocationShort,
                  ),
                  _divider(context),
                  _actionTile(
                    context: context,
                    icon: Icons.cleaning_services_outlined,
                    title: 'Clear Temporary Cache',
                    value: '14.2 MB',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache cleared successfully.')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.getTextSecondary(context),
        ),
      ),
    );
  }

  Widget _cardContainer(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.getCardBorder(context), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(height: 1, color: AppColors.getCardBorder(context));
  }

  Widget _nightDayModeCard(BuildContext context, RiderState state) {
    final isNight = state.isNightMode;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.getCardBorder(context), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isNight ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isNight
                      ? const Color(0xFF312E81).withValues(alpha: 0.5)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    color: isNight ? const Color(0xFFA5B4FC) : const Color(0xFFD97706),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Night & Day Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Adjust contrast and screen glare for daytime or night riding',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 3-Way Mode Segmented Selector (Day / Night / System)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceElevated(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _modeSegmentOption(
                  context: context,
                  label: 'Day',
                  icon: Icons.wb_sunny_rounded,
                  isSelected: state.themeMode == ThemeMode.light,
                  onTap: () => state.setThemeMode(ThemeMode.light),
                ),
                _modeSegmentOption(
                  context: context,
                  label: 'Night',
                  icon: Icons.nightlight_round,
                  isSelected: state.themeMode == ThemeMode.dark,
                  onTap: () => state.setThemeMode(ThemeMode.dark),
                ),
                _modeSegmentOption(
                  context: context,
                  label: 'System',
                  icon: Icons.brightness_auto_rounded,
                  isSelected: state.themeMode == ThemeMode.system,
                  onTap: () => state.setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Direct Toggle Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Night Ride Contrast',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isNight ? 'Active (Low screen eye-strain)' : 'Inactive (Standard brightness)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isNight ? AppColors.onlineGreen : AppColors.getTextSecondary(context),
                        fontWeight: isNight ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Switch.adaptive(
                value: isNight,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                onChanged: (_) => state.toggleNightMode(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _divider(context),
          const SizedBox(height: 12),

          // Auto-Sunset Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-Switch at Sunset',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Turn on Night Mode automatically after 7:00 PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Switch.adaptive(
                value: _autoSunsetSwitch,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                onChanged: (val) => setState(() => _autoSunsetSwitch = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modeSegmentOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final activeBg = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2E2E38)
        : Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.primary : AppColors.getTextSecondary(context),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? AppColors.getTextPrimary(context)
                      : AppColors.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.getTextPrimary(context), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _dropdownTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.getTextPrimary(context), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
          DropdownButton<String>(
            value: currentValue,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down_rounded),
            dropdownColor: AppColors.getSurface(context),
            items: options.map((opt) {
              return DropdownMenuItem(
                value: opt,
                child: Text(
                  opt,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.getTextPrimary(context), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getTextSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.getTextPrimary(context), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.getTextSecondary(context),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.getTextTertiary(context),
            ),
          ],
        ),
      ),
    );
  }
}
