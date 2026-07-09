import 'package:flutter_bloc/flutter_bloc.dart';

import 'ownership_details_repository.dart';
import 'ownership_details_state.dart';

class OwnershipDetailsCubit extends Cubit<OwnershipDetailsState> {
  final OwnershipDetailsRepository repository;

  OwnershipDetailsCubit(this.repository) : super(OwnershipDetailsInitial());

  Future<void> getRenterDetails(String id) async {
    emit(OwnershipDetailsLoading());
    try {
      final renter = await repository.getRenterDetails(id);
      emit(OwnershipDetailsSuccess(renter));
    } catch (e) {
      emit(OwnershipDetailsError(e.toString()));
    }
  }
}
