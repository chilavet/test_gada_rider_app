import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../state/rider_scope.dart';
import '../../widgets/gada_logo.dart';
import '../lease/lease_home_screen.dart';
import 'kyc_documents_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

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

              // Headline (Figma 805:13269)
              const Text(
                "Choose how you'll work",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Select the role that best describes what you'll do on GADA. You can only continue with one role during setup.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Option 1: Rider
              _roleCard(
                badgeLabel: 'RIDER',
                badgeIcon: '🛵',
                title: 'I am a Rider',
                description:
                    'I pick up completed orders from vendors or agents and deliver them safely to customers.',
                onTap: () {
                  state.switchRole('Rider');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KycDocumentsScreen(roleName: 'Rider'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Option 2: Market Agent
              _roleCard(
                badgeLabel: 'AGENT',
                badgeIcon: '💬',
                title: 'I am a Market Agent',
                description:
                    'I receive Market Run requests, purchase the requested items at the market, and hand them over to a rider for delivery.',
                onTap: () {
                  state.switchRole('Agent');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const KycDocumentsScreen(roleName: 'Market Agent'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Option 3: Lease a Vehicle
              _roleCard(
                badgeLabel: 'LEASE',
                badgeIcon: '🪴',
                title: 'I Want to Lease a Vehicle',
                description:
                    'I want to lease a vehicle for deliveries and earn by completing rides and orders across the city.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LeaseHomeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required String badgeLabel,
    required String badgeIcon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F1F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(badgeIcon, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 5),
                      Text(
                        badgeLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary, size: 20),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
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
