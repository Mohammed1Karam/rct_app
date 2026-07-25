import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/view/share_rct/details_repository.dart';
import 'package:rct/view/share_rct/details_state.dart';

class ShareDetailsCubit extends Cubit<ShareDetailsState> {
  final ShareDetailsRepository repository;

  ShareDetailsCubit(this.repository) : super(ShareDetailsInitial());

  Future<void> getOpportunityDetails(String id) async {
    emit(ShareDetailsLoading());
    try {
      final product = await repository.getOpportunityDetails(id);
      emit(ShareDetailsSuccess(product));
    } catch (e) {
      emit(ShareDetailsError(e.toString()));
    }
  }

  Future<void> registerInterest({required String name, required String phone}) async {
    emit(ShareDetailsInterestLoading());
    try {
      final response = await repository.registerOpportunityInterest(name: name, phone: phone);
      // The API returns status as a boolean
      if (response['status'] == true || response['status'] == 201 || response['status'] == 200) {
        emit(ShareDetailsInterestSuccess(response['message'] ?? "Success"));
      } else {
        emit(ShareDetailsInterestError(response['message'] ?? "Failed to register interest"));
      }
    } catch (e) {
      emit(ShareDetailsInterestError(e.toString()));
    }
  }
}
