import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/auth/otp_page.dart';
import 'package:lunch_box/model/app_address.dart';
import 'package:lunch_box/model/app_user.dart';
import 'package:lunch_box/util/utils.dart';

class AuthNotifier extends StateNotifier<AppUser> {
  AuthNotifier()
      : super(AppUser(
            isSigned: false,
            isLoading: false,
            uId: '',
            phoneNumber: '',
            name: '',
            address: AppAddress(
                officeName: "", streetAddress: "", city: "", state: "", zip: 0),
            preferredCombo: ''));

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isSignedIn() {
    return state.isSigned;
  }

  bool isLoadingState() {
    return state.isLoading;
  }

  void signInUser(BuildContext context, String phoneNumber, int toPage) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) {
          if (error.code == 'invalid-phone-number') {
            showSnackBar(context, 'The provided phone number is not valid.');
          } else {
            throw error;
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpPage(
              verificationId: verificationId,
              toPage: toPage,
            ),
          ));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context,
          "Error verifying phone number. Error: " + e.message.toString());
    }
    //state = getAppUser();
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    try {
      await startLoading();
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        AppUser appUser = getAppUser();
        appUser.uId = user.uid;
        appUser.isSigned = true;
        appUser.isLoading = true;
        appUser.phoneNumber = user.phoneNumber!;
        state = appUser;
        onSuccess();
      } else {
        await stopLoading();
      }
    } on FirebaseAuthException catch (e) {
      await stopLoading();
      if (e.message.toString().contains("auth/invalid-verification-code")) {
        showSnackBar(context, "Invalid OTP");
      } else {
        showSnackBar(context, e.message.toString());
      }
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firestore.collection("user").doc(state.uId).get();
    if (snapshot.exists) {
      state = AppUser.fromMap(snapshot.data() as Map<String, dynamic>);
      return true;
    } else {
      return false;
    }
  }

  void saveUserDataToFirebase({required BuildContext context}) async {
    await startLoading();
    try {
      await _firestore
          .collection("user")
          .doc(state.uId)
          .set(getAppUserFromState().toMap())
          .then((value) async {
        await stopLoading();
      });
    } on FirebaseAuthException catch (e) {
      await stopLoading();
      showSnackBar(context, e.message.toString());
    }
  }

  updateUser(String name, AppAddress address) {
    state = state.copyWith(name: name, address: address);
    _firestore.collection("user").doc(state.uId).set(state.toMap());
  }

  Future signOutUser({required BuildContext context}) async {
    await _firebaseAuth.signOut();
    state = getAppUser();
  }

  AppUser getAppUser() {
    return AppUser(
        isSigned: false,
        isLoading: false,
        uId: '',
        phoneNumber: '',
        name: '',
        address: AppAddress(
            officeName: "", streetAddress: "", city: "", state: "", zip: 0),
        preferredCombo: '');
  }

  AppUser getAppUserFromState() {
    return AppUser(
        isSigned: state.isSigned,
        isLoading: state.isLoading,
        uId: state.uId,
        phoneNumber: state.phoneNumber,
        name: state.name,
        address: state.address,
        preferredCombo: state.preferredCombo);
  }

  Future<bool> startLoading() {
    AppUser appUser = state.copyWith(isLoading: true);
    state = appUser;
    return Future(() => true);
  }

  Future<bool> stopLoading() {
    var appUser = state.copyWith(isLoading: false);
    state = appUser;
    return Future(() => false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AppUser>((ref) {
  return AuthNotifier();
});
