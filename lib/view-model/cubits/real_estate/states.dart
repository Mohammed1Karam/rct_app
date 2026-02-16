import 'package:rct/model/modelget.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataSuccess extends DataState {
  final List<Modelget> data;

  DataSuccess(
    this.data,
  );
}

class DtatLoaded extends DataState {
  final List<Modelget> data;

  DtatLoaded(
    this.data,
  );
}

class GetFavoritesSuccessState extends DataState{}

class FavouriteSuccess extends DataState {
  final List<dynamic> data;
  final bool isInGoodList;
  FavouriteSuccess(this.data, this.isInGoodList);
}

class DataError extends DataState {
  final String message;

  DataError(
    this.message,
  );

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}

class FilterSuccessState extends DataState {
  final List<Modelget> data;

  FilterSuccessState(this.data);
}

class FilterFailedState extends DataState {
  final String message;

  FilterFailedState(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}

class FilterloadingssState extends DataState {}

class SearchProductsEmptyState extends DataState {}

class FilterCategorySuccessState extends DataState {
  final List<Modelget> data;

  FilterCategorySuccessState(this.data);
}

class FavouriteUpdated extends DataState {
  // final List<Modelget> favList;
  // FavouriteUpdated(this.favList);
}

class FavouriteError extends DataState {
  final String message;

  FavouriteError(this.message);

  @override
  // ignore: override_on_non_overriding_member
  List<Object> get props => [message];
}

class FavouriteLoading extends DataState {}
