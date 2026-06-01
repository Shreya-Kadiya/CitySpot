import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import 'otp_screen.dart';

class ForgotPwdScreen extends StatefulWidget {
  const ForgotPwdScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPwdScreen> createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _handleReset() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _isLoading = false;
        });
        final contact = _emailController.text;
        final otpCode = (1000 + Random().nextInt(9000)).toString();
        debugPrint('CitySpot OTP sent to $contact: $otpCode');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset verification code sent successfully.'),
            backgroundColor: AppColors.iotAvailable,
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              phoneNumber: contact,
              verificationCode: otpCode,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Forgot Password?',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your email address or phone number and we will send you a verification code to reset your password.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Email / Phone Number',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email or phone',
                    prefixIcon: Icon(Icons.mail_outline, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Send Verification Code',
                  onPressed: _handleReset,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
