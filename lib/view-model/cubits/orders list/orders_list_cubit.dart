import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view-model/services/crud.dart';

part 'orders_list_state.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit() : super(OrdersListInitial());

  bool _isLoaded = false;
  List<dynamic>? _listOfData; // Cache for the fetched data
  final Crud _crud = Crud();

  Future<void> fetchOrderList({bool fromInit=true}) async {
    // if (_isLoaded) {
      // Emit the cached data if already loaded
      // emit(OrdersListSuccess(_listOfData!));
      // return;
    // }
if(fromInit){
  emit(OrdersListLoading());

}
    try {
      final response = await _crud.getRequest(linkOrders);
      _listOfData = response["data"]; // Cache the fetched data
      _isLoaded = true; // Mark data as loaded
      print("-------------------++++++++++++++++");
      print(_listOfData);
      emit(OrdersListSuccess(_listOfData!));
    } catch (error) {
      emit(OrdersListFailure(error.toString()));
    }
  }
}
