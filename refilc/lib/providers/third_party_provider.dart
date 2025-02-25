// ignore_for_file: use_build_context_synchronously

import 'package:refilc/models/linked_account.dart';
import 'package:flutter/material.dart';

class ThirdPartyProvider with ChangeNotifier {
  late List<LinkedAccount> _linkedAccounts;
  List<LinkedAccount> get linkedAccounts => _linkedAccounts;
  ThirdPartyProvider();
}
