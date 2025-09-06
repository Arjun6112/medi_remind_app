import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}

class HomeLoadEvent extends HomeEvent {}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadEvent>((event, emit) {
      // Load medications, etc.
      emit(HomeLoaded());
    });
  }
}
