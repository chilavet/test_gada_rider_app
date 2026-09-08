import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gada_logo.dart';
import 'otp_verification_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '080123456789');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  const Center(child: GadaLogo(size: 34)),
                  const SizedBox(height: 50),
                  // Phone Number Input Row (Figma 717:13166)
                  Row(
                    children: [
                      // Country Code Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Row(
                          children: [
                            Text('🇳🇬', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 6),
                            Text(
                              '+234',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down_rounded,
                                size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Phone Input
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            suffixIcon: Icon(Icons.phone_outlined,
                                color: AppColors.textSecondary, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      children: [
                        TextSpan(text: 'If you sign up, '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' apply'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final phone = _phoneController.text.trim();
                      if (phone.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtpVerificationScreen(phoneNumber: phone),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continue'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
