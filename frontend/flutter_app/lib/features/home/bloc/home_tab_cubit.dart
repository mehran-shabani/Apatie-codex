import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabState extends Equatable {
  const HomeTabState(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(const HomeTabState(0));

  void setTab(int index) {
    if (index == state.index) return;
    emit(HomeTabState(index));
  }
}
