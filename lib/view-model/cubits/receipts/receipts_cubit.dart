import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/model/receipts_model.dart';
import 'package:rct/view-model/services/crud.dart';

part 'receipts_state.dart';

class ReceiptsCubit extends Cubit<ReceiptsState> {
  ReceiptsCubit() : super(ReceiptsInitial());
  final Crud _crud = Crud();

  Future<void> sendReceipt(ReceiptsModel model) async {
    emit(ReceiptsLoading());
    try {
      await _crud.postRequestWithFiles(
        linkReceipts,
        {
          "description": model.description,
        },
        {
          "file": model.file,
        },
        headers: {},
      );
      emit(ReceiptsSuccess());
    } catch (e) {
      emit(ReceiptsFailure(e.toString()));
    }
  }
}
