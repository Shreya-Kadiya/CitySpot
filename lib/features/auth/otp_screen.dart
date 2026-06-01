import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../navigation/main_navigation.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationCode;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationCode,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;
  late String _activeOtp;

  @override
  void initState() {
    super.initState();
    _activeOtp = widget.verificationCode;
    debugPrint('CitySpot OTP sent to ${widget.phoneNumber}: $_activeOtp');
  }

  void _verifyOtp() {
    final enteredOtp = _getEnteredOtp();
    if (enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit OTP code.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });

      if (enteredOtp != _activeOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The OTP code is incorrect. Please try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account verified successfully! Welcome to CitySpot.'),
          backgroundColor: AppColors.iotAvailable,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    });
  }

  String _getEnteredOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _resendOtp() {
    setState(() {
      _activeOtp = _generateOtp();
    });
    debugPrint('CitySpot OTP resent to ${widget.phoneNumber}: $_activeOtp');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new OTP verification code has been sent.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _generateOtp() {
    return (1000 + Random().nextInt(9000)).toString();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'OTP Verification',
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
                'We have sent a verification code to ${widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "+1 (555) 019-2834"}. Enter the code below.',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 64,
                    height: 64,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (index == 3 && value.isNotEmpty) {
                          _focusNodes[index].unfocus();
                          _verifyOtp();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Verify & Proceed',
                onPressed: _verifyOtp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: GoogleFonts.outfit(
                        color: isDark
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        'Resend OTP Code',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
