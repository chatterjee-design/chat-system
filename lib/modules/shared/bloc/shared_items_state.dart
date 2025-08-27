part of 'shared_items_bloc.dart';

sealed class SharedItemsState extends Equatable {
  const SharedItemsState();
  
  @override
  List<Object> get props => [];
}

final class SharedItemsInitial extends SharedItemsState {}
