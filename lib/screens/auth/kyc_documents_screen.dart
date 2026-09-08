import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gada_logo.dart';
import '../main_rider_shell.dart';

class KycDocumentsScreen extends StatefulWidget {
  final String roleName;

  const KycDocumentsScreen({
    super.key,
    required this.roleName,
  });

  @override
  State<KycDocumentsScreen> createState() => _KycDocumentsScreenState();
}

class _KycDocumentsScreenState extends State<KycDocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = RiderScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: GadaLogo(size: 32)),
              const SizedBox(height: 28),

              // Headline (Figma 805:10495)
              Text(
                'Complete your ${widget.roleName} KYC',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'These documents verify that you meet the necessary qualifications to be a ${widget.roleName.toLowerCase()} on Gada.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 1. Personal Information
              _kycItemCard(
                title: 'Personal information',
                description: 'Tell us a little about yourself and where you operate.',
                isCompleted: state.kycPersonalInfoDone,
                onTap: () {
                  state.completeKycStep('personal');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Personal profile details up to date.')),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 2. Identity Verification
              _kycItemCard(
                title: 'Identity verification',
                description: 'Provide valid identification so we can verify your identity.',
                isCompleted: state.kycIdentityDone,
                onTap: () {
                  state.completeKycStep('identity');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.onlineGreen,
                      content: Text('✓ National ID / NIN verification submitted!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 3. Vehicle Information
              _kycItemCard(
                title: 'Vehicle information',
                description: 'Add your vehicle details so we can confirm it is suitable for deliveries.',
                isCompleted: state.kycVehicleDone,
                onTap: () {
                  state.completeKycStep('vehicle');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.onlineGreen,
                      content: Text('✓ Motorbike registration document verified!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 4. Bank Details
              _kycItemCard(
                title: 'Bank details',
                description: 'Add the bank account where your delivery earnings should be paid.',
                isCompleted: state.kycBankDone,
                onTap: () {
                  state.completeKycStep('bank');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.onlineGreen,
                      content: Text('✓ Bank account linked (GTBank ••• 4092)'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainRiderShell()),
                    (route) => false,
                  );
                },
                child: const Text('Continue to Dashboard'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kycItemCard({
    required String title,
    required String description,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline_rounded,
                                size: 14, color: AppColors.onlineGreen),
                            SizedBox(width: 4),
                            Text(
                              'Filled',
                              style: TextStyle(
                                color: AppColors.onlineGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Pending',
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textTertiary, size: 20),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
