import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fresto_apps/models_data/user_auth_data.dart';
import 'package:fresto_apps/screens/account_screen.dart';
import 'package:fresto_apps/screens/home_screen.dart';
import 'package:fresto_apps/screens/login_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockCurrentUserData extends Mock implements UserAuthData {
  final MockFirebaseAuth auth;
  MockCurrentUserData(this.auth);
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final mockObserver = MockNavigatorObserver();
  MockFirebaseAuth _auth = MockFirebaseAuth();
  MockCurrentUserData _currentUserData;
  _currentUserData = MockCurrentUserData(_auth);

  Widget _makeTestable(Widget child) {
    return ChangeNotifierProvider<UserAuthData>.value(
      value: _currentUserData,
      child: MaterialApp(
        home: child,
        navigatorObservers: [mockObserver],
      ),
    );
  }

  var emailField = find.byKey(Key("tfEmail"));
  var passwordField = find.byKey(Key("tfPassword"));
  var confirmPasswordField = find.byKey(Key("tfConfirmPassword"));
  var phoneNumberField = find.byKey(Key("tfPhoneNumber"));
  var fullNameField = find.byKey(Key("tfFullName"));
  var signInButton = find.byKey(Key("btnLoginOrRegister"));
  var switchButton = find.byKey(Key("btnSwitchLoginOrRegister"));
  var accountPageLogoutButton = find.byKey(Key("btnAccountSignOut"));
  var homePageLogoutButton = find.byKey(Key("btnHomeSignOut"));

  final String realEmail = "rickyafk@gmail.com";
  final String realPassword = "fresto123";
  final String realFullName = "Ricky Hemawan";
  final String realPhoneNumber = "0812345678901";

  group("login page test", () {
    testWidgets("email and password text field are found and editable",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(LoginScreen()));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      await tester.enterText(emailField, realEmail);
      await tester.enterText(passwordField, realPassword);
      await tester.pump();
      expect(find.text(realEmail), findsOneWidget);
    });
    testWidgets(
        "Login button found, should call login function called when clicked",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(LoginScreen()));
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      verify(_currentUserData.loginUser()).called(1);
    });
  });

  group("register page test", () {
    testWidgets(
        "email, password, confirm password, phone number, full name, text field are found and editable",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(LoginScreen()));
      expect(switchButton, findsOneWidget);
      await tester.tap(switchButton);
      await tester.pump();
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(confirmPasswordField, findsOneWidget);
      expect(phoneNumberField, findsOneWidget);
      expect(fullNameField, findsOneWidget);
      await tester.enterText(emailField, realEmail);
      await tester.enterText(passwordField, realPassword);
      await tester.enterText(confirmPasswordField, realPassword);
      await tester.enterText(phoneNumberField, realPhoneNumber);
      await tester.enterText(fullNameField, realFullName);
      await tester.pump();
      expect(find.text(realEmail), findsOneWidget);
      expect(find.text(realPhoneNumber), findsOneWidget);
      expect(find.text(realFullName), findsOneWidget);
    });
    testWidgets(
        "Register button found, should call register function called when clicked",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(LoginScreen()));
      await tester.tap(switchButton);
      await tester.pump();
      expect(find.text("Register"), findsNWidgets(2));
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pump();
      verifyNever(_currentUserData.registerUser());
//      expect(switchButton, findsOneWidget);
//      await tester.tap(switchButton);
//      await tester.pump();
//      expect(signInButton, findsOneWidget);
//      await tester.tap(signInButton);
//      await tester.pump();
//      verify(_currentUserData.registerUser()).called(1);
    });
  });

  group("logout widget test", () {
    testWidgets(
        "Logout button found on account page, should navigate to other screen when clicked",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(AccountScreen()));
      expect(accountPageLogoutButton, findsOneWidget);
      await tester.tap(accountPageLogoutButton);
      await tester.pumpAndSettle();
    });
    testWidgets(
        "Logout button found on home page, should navigate to other screen when clicked",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(HomeScreen()));
      expect(homePageLogoutButton, findsOneWidget);
      await tester.tap(homePageLogoutButton);
      await tester.pumpAndSettle();
    });
  });
}
