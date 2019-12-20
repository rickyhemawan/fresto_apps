import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresto_apps/models_data/current_user_data.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {
  FirebaseUser user;
}

class MockFirestore extends Mock implements Firestore {}

void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  when(_auth.onAuthStateChanged).thenAnswer((_) {
    return _user;
  });
  CurrentUserData _repo = CurrentUserData(auth: _auth);

  group('Login, Logout, Register Use cases', () {
    when(_auth.signInWithEmailAndPassword(
            email: "rickyafk@gmail.com", password: "fresto123"))
        .thenAnswer((_) async {
      _user.add(MockFirebaseUser());
      MockAuthResult mr = MockAuthResult();
      mr.user = MockFirebaseUser();
      return mr;
    });
    when(_auth.signInWithEmailAndPassword(email: "mail", password: "pass"))
        .thenThrow(() {
      return null;
    });
    when(_auth.currentUser()).thenAnswer((_) async {
      if (_repo.email == "rickyafk@gmail.com") return MockFirebaseUser();
      return null;
    });

    when(_auth.createUserWithEmailAndPassword(
            email: "rickyafk@gmail.com", password: "password"))
        .thenAnswer((_) async {
      MockAuthResult mr = MockAuthResult();
      mr.user = MockFirebaseUser();
      return mr;
    });

    test("Sign in with email and password", () async {
      _repo.setEmail("rickyafk@gmail.com");
      _repo.setPassword("fresto123");
      String login = await _repo.loginUser();
      expect(login, null);
      bool loginStatus = await _repo.isUserAuthenticated();
      expect(loginStatus, true);
    });

    test("Sign in or Register fails with incorrect email and password",
        () async {
      _repo.setEmail("mail");
      _repo.setPassword("pass");
      String login = await _repo.loginUser();
      expect(login, isNotNull);
      bool loginStatus = await _repo.isUserAuthenticated();
      expect(loginStatus, false);
    });

    test('Sign out', () async {
      _repo.signOutUser(null);
      bool loginStatus = await _repo.isUserAuthenticated();
      expect(loginStatus, false);
    });

    test("Register", () async {
      _repo.setEmail("rickyafk@gmail.com");
      _repo.setPassword("password");
      _repo.setConfirmPassword("password");
      _repo.setFullName("testFullname");
      _repo.setPhoneNumber("0812345678901");
      String error = await _repo.registerUser();
      expect(error, null);
    });
  });
}
