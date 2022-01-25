import '../CServices.dart';
import 'providers/CCryptoProvider.dart';

class CControlWalletsService {
  late final CCryptoProvider _cryptoProvider;

  CControlWalletsService(CCryptoProvider cryptoProvider): _cryptoProvider = cryptoProvider;

  Future<bool> addNewWallet({required String walletName}) async {
    if (!(await CServices.crypto.cryptoContainer.addNewWallet(walletName: walletName))) {
      return false;
    }
    return true;
  }
}