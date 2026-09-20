import 'package:easy_localization/easy_localization.dart';
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

        errorMessage: 'otp.complete_code'.tr(),
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

        title: 'otp.success_title'.tr(),

        message: 'otp.success_message'.tr(),

        buttonText: 'otp.continue'.tr(),

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
            'otp.verify_failed'.tr(),
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
      appBar: AppBar(title: Text('otp.title'.tr()), centerTitle: true),

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

              Text(
                'otp.verify_email'.tr(),

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'otp.enter_code'.tr(namedArgs: {'email': widget.email}),

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
                      : Text('otp.verify'.tr()),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () {
                  displayAwesomeDialog(
                    context,

                    message: 'otp.resend_message'.tr(),
                  );
                },

                child: Text(
                  'otp.resend_code'.tr(),

                  style: const TextStyle(color: Color(0xFFE50046)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
