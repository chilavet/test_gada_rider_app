import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyPhoneController;

  bool _isEditing = false;
  bool _hasChanges = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profile = RiderScope.of(context).userProfile;
      _firstNameController = TextEditingController(text: profile.firstName);
      _lastNameController = TextEditingController(text: profile.lastName);
      _emailController = TextEditingController(text: profile.email);
      _phoneController = TextEditingController(text: profile.phone);
      _emergencyPhoneController = TextEditingController(text: profile.emergencyContact);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final state = RiderScope.of(context);
    state.updateUserProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      emergencyContact: _emergencyPhoneController.text.trim(),
    );

    setState(() {
      _isEditing = false;
      _hasChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Profile information updated successfully!'),
          ],
        ),
        backgroundColor: AppColors.onlineGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);
    final profile = state.userProfile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Profile Info',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Text(
              _isEditing ? 'Cancel' : 'Edit',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Profile Avatar & Badge
              _buildAvatarCard(context, profile, isDark),
              const SizedBox(height: 20),

              // Section 1: Personal Information (Figma 741:13337 input fields)
              _sectionHeader(context, 'Personal Information'),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.getCardBorder(context), width: 1.2),
                ),
                child: Column(
                  children: [
                    // First Name & Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            context: context,
                            label: 'First Name',
                            controller: _firstNameController,
                            enabled: _isEditing,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInputField(
                            context: context,
                            label: 'Last Name',
                            controller: _lastNameController,
                            enabled: _isEditing,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Email (Optional) Field
                    _buildInputField(
                      context: context,
                      label: 'Email Address',
                      controller: _emailController,
                      enabled: _isEditing,
                      prefixIcon: Icons.mail_outline_rounded,
                    ),
                    const SizedBox(height: 14),

                    // Phone Number Field
                    _buildInputField(
                      context: context,
                      label: 'Phone Number',
                      controller: _phoneController,
                      enabled: _isEditing,
                      prefixIcon: Icons.phone_outlined,
                      suffixBadge: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.onlineGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 13, color: AppColors.onlineGreen),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onlineGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Emergency Contact Field
                    _buildInputField(
                      context: context,
                      label: 'Emergency Contact',
                      controller: _emergencyPhoneController,
                      enabled: _isEditing,
                      prefixIcon: Icons.contact_phone_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section 2: Operational & Vehicle Details
              _sectionHeader(context, 'Operational & Vehicle Details'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.getCardBorder(context), width: 1.2),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      context: context,
                      icon: Icons.two_wheeler_rounded,
                      label: 'Assigned Vehicle',
                      value: profile.vehicleType,
                    ),
                    _divider(context),
                    _infoRow(
                      context: context,
                      icon: Icons.badge_outlined,
                      label: 'Vehicle Plate',
                      value: profile.vehiclePlate,
                    ),
                    _divider(context),
                    _infoRow(
                      context: context,
                      icon: Icons.work_outline_rounded,
                      label: 'Assigned Role',
                      value: state.activeRole,
                    ),
                    _divider(context),
                    _infoRow(
                      context: context,
                      icon: Icons.verified_user_outlined,
                      label: 'KYC Verification',
                      value: profile.isKycVerified ? 'Verified (Level 2)' : 'Pending',
                      valueColor: profile.isKycVerified ? AppColors.onlineGreen : AppColors.primary,
                    ),
                    _divider(context),
                    _infoRow(
                      context: context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Member Since',
                      value: profile.memberSince,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save Changes Button (Visible when editing)
              if (_isEditing)
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarCard(BuildContext context, dynamic profile, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.getCardBorder(context), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar Stack
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9500), Color(0xFFFF5E00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${profile.firstName.isNotEmpty ? profile.firstName[0] : 'A'}${profile.lastName.isNotEmpty ? profile.lastName[0] : 'E'}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera photo upload ready.')),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.getSurface(context),
                      width: 2.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            '${profile.firstName} ${profile.lastName}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 4),

          // ID and Role badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  profile.id,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.onlineGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 12, color: AppColors.onlineGreen),
                    SizedBox(width: 4),
                    Text(
                      'Verified Rider',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onlineGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool enabled,
    IconData? prefixIcon,
    Widget? suffixBadge,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: enabled
            ? (isDark ? const Color(0xFF22222C) : const Color(0xFFF3F4F6))
            : (isDark ? const Color(0xFF191922) : const Color(0xFFF8F9FA)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.getCardBorder(context),
          width: enabled ? 1.4 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  size: 18,
                  color: enabled ? AppColors.primary : AppColors.getTextSecondary(context),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.getTextPrimary(context),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  onChanged: (_) {
                    if (!_hasChanges) {
                      setState(() => _hasChanges = true);
                    }
                  },
                ),
              ),
              ?suffixBadge,
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.getTextPrimary(context)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.getTextPrimary(context),
            ),
          ),
        ],
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

  Widget _divider(BuildContext context) {
    return Divider(height: 1, color: AppColors.getCardBorder(context));
  }
}
