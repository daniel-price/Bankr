import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';

class DownloadedData {
  final AccountProvider _accountProvider;
  final List<Account> _accounts;
  final List<AccountBalance> _accountBalances;
  final List<AccountTransaction> _accountTransactions;

  DownloadedData(this._accountProvider, this._accounts, this._accountBalances, this._accountTransactions);

  AccountProvider get accountProvider => _accountProvider;

  List<Account> get accounts => _accounts;

  List<AccountBalance> get accountBalances => _accountBalances;

  List<AccountTransaction> get accountTransactions => _accountTransactions;
}
