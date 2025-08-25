part of 'chat_search_bloc.dart';

sealed class ChatSearchState extends Equatable {
  const ChatSearchState();
  
  @override
  List<Object> get props => [];
}

final class ChatSearchInitial extends ChatSearchState {}
