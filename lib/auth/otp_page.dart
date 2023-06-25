import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/menu_provider.dart';
import 'package:lunch_box/provider/order_provider.dart';
import 'package:lunch_box/tabs.dart';
import 'package:lunch_box/util/utils.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({required this.verificationId, required this.toPage, Key? key})
      : super(key: key);
  final int toPage;
  final String verificationId;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  String _otpCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: const Center(child: Text('nom nom')),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Enter the OTP sent to your phone number'),
                        const SizedBox(
                          height: 12,
                        ),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          autofocus: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            setState(() {
                              _otpCode = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          child: ref.watch(authProvider).isLoading
                              ? const SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                  height: 20.0,
                                  width: 20.0,
                                )
                              : const Text('Verify'),
                          onPressed: () {
                            if (_otpCode != null) {
                              _verify(context, _otpCode);
                            } else {
                              showSnackBar(context, "Enter 6-Digit code");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _verify(BuildContext context, String otpCode) {
    ref.read(authProvider.notifier).verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: otpCode,
        onSuccess: () {
          ref
              .read(authProvider.notifier)
              .checkExistingUser()
              .then((value) async {
            if (value == true) {
              //user exists in our app
              if (ref.read(orderProvider).totalCount <= 0) {
                ref.read(orderProvider.notifier).loadOngoingOrder(
                    ref.read(authProvider).uId,
                    ref.read(menuProvider).menuDate);
              }
            } else {
              //New User
              ref
                  .read(authProvider.notifier)
                  .saveUserDataToFirebase(context: context);
            }
            ref.read(authProvider.notifier).stopLoading();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Tabs(
                          selectedPage: widget.toPage,
                        )),
                (route) => false);
          });
        });
  }
}
