import 'package:bankr/data/repository/transaction_repository.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_event.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_state.dart';
import 'package:bloc/bloc.dart';

class TransactionsScreenBloc extends Bloc<TransactionsScreenEvent, TransactionsScreenState> {
  final DateTransactionsInfoRepository _dateTransactionsInfoRepository;

  TransactionsScreenBloc(this._dateTransactionsInfoRepository) : assert(_dateTransactionsInfoRepository != null);

  @override
  TransactionsScreenState get initialState => StateInitial();

  @override
  Stream<TransactionsScreenState> mapEventToState(TransactionsScreenEvent event) async* {
    if (event is TransactionsScreenLoaded) {
      yield StateInitial();
      var accountsTransactions = await _dateTransactionsInfoRepository.getAllAccountsTransactions();
      yield StateSuccess(List.from(accountsTransactions));
    }
  }
}
