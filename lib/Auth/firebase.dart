import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:thopaa/Auth/handler/auth_result_handler.dart';
import 'package:thopaa/Model/user_data_model.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  late AuthResultStatus? status;
  final database = FirebaseFirestore.instance;

  //signup
  Future<AuthResultStatus?> signupwithEmailandPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (authResult.user != null) {
        status = AuthResultStatus.successful;
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      status = AuthExceptionHandler.handleException(e);
    }
    return status;
  }

  //login
  Future<AuthResultStatus?> login({email, pass}) async {
    try {
      final authResult =
          await auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        status = AuthResultStatus.successful;
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      status = AuthExceptionHandler.handleException(e);
    }
    return status;
  }

//logout
  logout() {
    auth.signOut();
  }

  //createuser in database
  Future<void> createUser(UserData data) async {
    try {
      database
          .collection('Users')
          .doc(data.uid)
          .set(data.toJson())
          .whenComplete(() {
        toast('Data added to database');
      });
    } catch (e) {
      toast(e.toString());
    }
  }

  //get user status
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await auth.currentUser!;

    print(currentUser.uid);

    return currentUser;
  }

  //getuserdetails and save
  Future<UserData> fetchUserDetails(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    final snapshot = await users.doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>;
    return UserData.fromMap(data);
  }
  // }
  //   DocumentSnapshot documentSnapshot =
  //       await database.collection("users").doc(uid).get();
  //   print(documentSnapshot.data()['uid']);
  //   return UserData.fromMap(documentSnapshot.data());
  // }
}
