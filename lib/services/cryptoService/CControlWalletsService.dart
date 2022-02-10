import '../CServices.dart';
import 'providers/CCryptoProvider.dart';

class CControlWalletsService {
  late final CCryptoProvider _cryptoProvider;

  CControlWalletsService(CCryptoProvider cryptoProvider): _cryptoProvider = cryptoProvider;

  Future<bool> addNewWallet({required String walletName}) async {
    SMnemonicRootKey mnemonicRootKey = CServices.crypto.cryptoContainerAuth.getCurrentMnemonicRootKey();
    SWalletDescriptor walletDescriptor = CServices.crypto.cryptoProvider.getDefaultDescriptors(mnemonicRootKey);

    //
    if (!(await CServices.crypto.cryptoContainer.addNewWallet(
        walletName: walletName,
        walletDescriptor: walletDescriptor
    ))) {
      return false;
    }
    return true;
  }

  Future<bool> addExistWallet({
    required String walletName
  }) async {
    SMnemonicRootKey mnemonicRootKey = CServices.crypto.cryptoContainerAuth.getCurrentMnemonicRootKey();
    SWalletDescriptor walletDescriptor = CServices.crypto.cryptoProvider.getDefaultDescriptors(mnemonicRootKey);

    //
    if (!(await CServices.crypto.cryptoContainer.addNewWallet(
        walletName: walletName,
        walletDescriptor: walletDescriptor
    ))) {
      return false;
    }
    return true;
  }
}