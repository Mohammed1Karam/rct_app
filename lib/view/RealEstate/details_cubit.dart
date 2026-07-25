import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/view/RealEstate/details_repository.dart';
import 'package:rct/view/RealEstate/details_state.dart';

class RealEstateDetailsCubit extends Cubit<RealEstateDetailsState> {
  final RealEstateDetailsRepository repository;

  RealEstateDetailsCubit(this.repository) : super(RealEstateDetailsInitial());

  Future<void> getPropertyDetails(String id) async {
    emit(RealEstateDetailsLoading());
    try {
      final product = await repository.getPropertyDetails(id);
      emit(RealEstateDetailsSuccess(product));
    } catch (e) {
      emit(RealEstateDetailsError(e.toString()));
    }
  }
}
