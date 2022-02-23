import 'package:get/get.dart';
import 'package:specter_mobile/app/models/CryptoContainerModel.dart';
import 'package:specter_mobile/app/modules/200_wallets/walletInfo/controllers/wallet_info_controller.dart';
import 'package:specter_mobile/services/cryptoService/providers/CCryptoProvider.dart';

class WalletInfoDetailsNode {
  String name;
  String value;
  WalletInfoDetailsNode(this.name, this.value);
}

class WalletInfoDetailsController extends GetxController {
  late SWalletModel walletItem;
  late int keyIndex;

  late List<WalletInfoDetailsNode> list;

  @override
  void onInit() {
    super.onInit();

    WalletInfoController walletInfoController = Get.find<WalletInfoController>();
    walletItem = walletInfoController.walletItem!;
    keyIndex = walletInfoController.keyIndex;

    SWalletKey walletKeyDetails = walletItem.descriptor.keys[keyIndex];
    print(walletKeyDetails.raw);

    list = [];
    list.add(WalletInfoDetailsNode('Net', walletItem.descriptor.net.toShortString().toLowerCase()));
    list.add(WalletInfoDetailsNode('Type', walletItem.descriptor.policy));
    list.add(WalletInfoDetailsNode('Format', walletItem.descriptor.type));
    list.add(WalletInfoDetailsNode('Derivation', walletKeyDetails.getDerivationPath()));
    list.add(WalletInfoDetailsNode('Fingerprint', walletKeyDetails.getFingerprint()));
    list.add(WalletInfoDetailsNode('Balance', '0.0 BTC'));
    list.add(WalletInfoDetailsNode('Balance, fiat', '0 USD'));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}