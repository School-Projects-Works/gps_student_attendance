import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gps_student_attendance/features/auth/data/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<(bool, String)> createUser(Users user) async {
    // create user
    try {
      //create firebase user
      final credential = await auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      //send email verification
      await credential.user!.sendEmailVerification();
      //create user in firestore
      if (credential.user != null) {
        user.id = credential.user!.uid;
        user.createdAt = DateTime.now().millisecondsSinceEpoch;
        CollectionReference users = firestore.collection('users');
        await users.doc(user.id).set(user.toMap());
        return (true, 'User created successfully, please verify your email');
      } else {
        return (false, 'User not created');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return (false, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return (false, 'The account already exists for that email.');
      }
      return (false, e.toString());
    } catch (e) {
      // handle error
      return (false, e.toString());
    }
  }

  static Future<(String, User?)> login({required String email, required String password}) async{
    try{
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          if(credential.user != null){
            return ('Login successful', credential.user);
          }else{
            return ('Login failed', null);
          }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.', null);
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.', null);
      }
      return (e.toString(), null);
    }catch(error){
      return (error.toString(), null);
    }
  }

  static Future<(String, Users)>getUserData(String uid)async {
    try{
      var user = await firestore.collection('users').doc(uid).get();
      if(user.exists){
        return ('User found', Users.fromMap(user.data()!));
      }else{
        return ('User not found', Users());
      }
    }catch(e){
      return (e.toString(), Users());
    }
  }

  static Future<Users>checkIfLoggedIn() async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user');
      if(user!=null){
        var (_, userData) = await getUserData(user);
        return userData;
      }else{
        return Users();
      }
  }
}
