// login exceptions
class UserNotFoundException implements Exception {}
class WrongPasswordAuthException implements Exception {}


// register exceptions
class WeakPassowrdAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}
class InvalidEmailAuthException implements Exception {}


// generic exception that we needed

class GenericAuthException implements Exception {}
class UserNotLoggedInAuthException implements Exception {}


