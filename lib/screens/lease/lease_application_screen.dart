import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/lease_bike.dart';
import '../../state/rider_scope.dart';
import 'lease_success_screen.dart';

class LeaseApplicationScreen extends StatefulWidget {
  final LeaseBike bike;

  const LeaseApplicationScreen({
    super.key,
    required this.bike,
  });

  @override
  State<LeaseApplicationScreen> createState() => _LeaseApplicationScreenState();
}

class _LeaseApplicationScreenState extends State<LeaseApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Applicant controllers
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _ninController;

  // Guarantor controllers
  late final TextEditingController _guarantorNameController;
  late final TextEditingController _guarantorPhoneController;
  late final TextEditingController _guarantorAddressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Daniel Adeleke');
    _phoneController = TextEditingController(text: '080123456789');
    _addressController = TextEditingController(text: '14 Ademola Adetokunbo Crescent, Wuse 2, Abuja');
    _ninController = TextEditingController(text: '10928374651');

    _guarantorNameController = TextEditingController(text: 'Alhaji Musa Ibrahim');
    _guarantorPhoneController = TextEditingController(text: '080987654321');
    _guarantorAddressController = TextEditingController(text: '8 Gana Street, Maitama, Abuja');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ninController.dispose();
    _guarantorNameController.dispose();
    _guarantorPhoneController.dispose();
    _guarantorAddressController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_formKey.currentState?.validate() ?? true) {
      final state = RiderScope.of(context);
      state.submitLeaseApplication(widget.bike.id);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LeaseSuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lease application',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selected Bike Summary Card (Figma 1212:14845)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                widget.bike.emojiIcon,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.bike.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.bike.specs,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F7EE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '● Available',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF047857),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AppColors.cardBorder),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _compactStat('Weekly payment', currency.format(widget.bike.weeklyPayment), isBlue: true),
                          _compactStat('Lease duration', '${widget.bike.leaseDurationWeeks} weeks'),
                          _compactStat('Start fee', currency.format(widget.bike.startFee)),
                          _compactStat('Total cost', currency.format(widget.bike.totalLeaseCost)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 1: Applicant Details (Figma 1212:14845)
                const Text(
                  'Applicant details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _inputField(
                  controller: _nameController,
                  hint: 'Full name',
                ),
                const SizedBox(height: 12),
                _inputField(
                  controller: _phoneController,
                  hint: 'Phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _inputField(
                  controller: _addressController,
                  hint: 'Home address',
                ),
                const SizedBox(height: 12),
                _inputField(
                  controller: _ninController,
                  hint: 'NIN number',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 28),

                // Section 2: Guarantor Details (Figma 1212:14845)
                const Text(
                  'Guarantor details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _inputField(
                  controller: _guarantorNameController,
                  hint: 'Guarantor full name',
                ),
                const SizedBox(height: 12),
                _inputField(
                  controller: _guarantorPhoneController,
                  hint: 'Guarantor phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _inputField(
                  controller: _guarantorAddressController,
                  hint: 'Guarantor home address',
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitApplication,
                  child: const Text(
                    'Submit application',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _compactStat(String label, String val, {bool isBlue = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            val,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isBlue ? const Color(0xFF1D4ED8) : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.textPrimary, width: 1.5),
        ),
      ),
    );
  }
}
