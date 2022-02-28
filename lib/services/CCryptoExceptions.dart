enum ExceptionType {
  UNKNOWN,
  WALLET_EXISTS
}

class CCryptoExceptionsWalletExists implements Exception {
  late final ExceptionType type;

  CCryptoExceptionsWalletExists() {
    type = ExceptionType.WALLET_EXISTS;
  }
}