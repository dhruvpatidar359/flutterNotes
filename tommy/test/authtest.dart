import 'package:test/test.dart';
import 'package:tommy/services/auth/auth_exceptions.dart';
import 'package:tommy/services/auth/auth_provider.dart';
import 'package:tommy/services/auth/auth_user.dart';

void main() {

  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test("should be initialized to begin with", () {
      expect(provider._isInitialized, false);
    });

    test("log out can't be done before initialization ##error##", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("should be able to initialize", () async {
      await provider.initialize();

      expect(provider.isInitialized, true);
    });

    test("user should be null after initialization", () {
      expect(provider.currentUser, null);
    });

    test("should be able to do in the given time of 2 seconds", () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Create user should delegate to logIn function", () async {
      final badEmailUser = await provider.createUser(
        email: "foo@bar.com",
        password: 'anypassword',
      );
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));

      final badPasswordUser = await provider.createUser(
        email: "anyEmail",
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("logged user should be able to get verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to logout and login again', () async {
      await provider.logOut();
      await provider.login(
        email: 'email',
        password: 'password',
      );
      expect(
        provider.currentUser,
        isNotNull
      );
    });


  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
    // throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
    // TODO: implement logOut
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundException();
    Future.delayed(const Duration(seconds: 1));
    _user = null;

  
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    // TODO: implement login
    if (!isInitialized) throw NotInitializedException();
    if (email != 'foobar@bar.com') throw NotInitializedException();
    if (password != 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'foo@bar.com');
    _user = user;
    return Future.value(user);

    // throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(isEmailVerified: true, email: 'foo@bar.com');
    _user = newUser;
  }
}
