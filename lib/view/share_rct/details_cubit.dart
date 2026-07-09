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
}
