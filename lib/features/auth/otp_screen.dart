import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:otlopapp/core/utils/display_awesome_dialog.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  String get _otp {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) {
      displayAwesomeDialog(
        context,

        errorMessage: 'Please enter the complete OTP.',
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      displayAwesomeDialog(
        context,

        title: 'Success Registration',

        message: 'Your account has been verified successfully.',

        buttonText: 'Continue',

        onOk: () {
          Navigator.pushNamedAndRemoveUntil(context, '/nav', (route) => false);
        },
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      displayAwesomeDialog(
        context,

        errorMessage:
            'Unable to verify OTP. '
            'Please try again.',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification'), centerTitle: true),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.mark_email_read_outlined,

                size: 90,

                color: Color(0xFFE50046),
              ),

              const SizedBox(height: 25),

              const Text(
                'Verify your email',

                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                'Enter the 6-digit code sent to\n${widget.email}',

                textAlign: TextAlign.center,

                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,

                    child: TextField(
                      controller: _controllers[index],

                      focusNode: _focusNodes[index],

                      keyboardType: TextInputType.number,

                      textAlign: TextAlign.center,

                      maxLength: 1,

                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                      decoration: InputDecoration(
                        counterText: '',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),

                          borderSide: const BorderSide(
                            color: Color(0xFFE50046),

                            width: 2,
                          ),
                        ),
                      ),

                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }

                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50046),

                    foregroundColor: Colors.white,
                  ),

                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,

                          child: CircularProgressIndicator(
                            strokeWidth: 2,

                            color: Colors.white,
                          ),
                        )
                      : const Text('Verify'),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  displayAwesomeDialog(
                    context,

                    message: 'A new OTP will be sent when the resend API is connected.',
                  );
                },

                child: const Text(
                  'Resend Code',

                  style: TextStyle(color: Color(0xFFE50046)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
