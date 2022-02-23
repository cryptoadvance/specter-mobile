import 'package:specter_mobile/app/models/CryptoContainerModel.dart';

import '../CServices.dart';
import 'providers/CCryptoProvider.dart';

class CControlWalletsService {
  CControlWalletsService(CCryptoProvider cryptoProvider);

  Future<bool> addNewWallet({required String walletName}) async {
    SMnemonicRootKey mnemonicRootKey = CServices.crypto.cryptoContainerAuth.getCurrentMnemonicRootKey();

    SWalletDescriptor walletDescriptor;
    try {
      walletDescriptor = CServices.crypto.cryptoProvider.getDefaultDescriptor(mnemonicRootKey, WalletNetwork.BITCOIN);
    } catch(e) {
      print(e);
      return false;
    }

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
    required String walletName,
    required String descriptor
  }) async {
    SMnemonicRootKey mnemonicRootKey = CServices.crypto.cryptoContainerAuth.getCurrentMnemonicRootKey();

    SWalletDescriptor walletDescriptor;
    try {
      walletDescriptor = CServices.crypto.cryptoProvider.getParsedDescriptor(mnemonicRootKey, descriptor, WalletNetwork.BITCOIN);
    } catch(e) {
      print(e);
      return false;
    }

    //
    if (!(await CServices.crypto.cryptoContainer.addNewWallet(
        walletName: walletName,
        walletDescriptor: walletDescriptor
    ))) {
      return false;
    }
    return true;
  }

  SWalletModel getWalletByKey(String key) {
    return CServices.crypto.cryptoContainer.getWalletByKey(key);
  }
}