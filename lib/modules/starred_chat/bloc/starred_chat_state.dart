part of 'starred_chat_bloc.dart';

sealed class StarredChatState extends Equatable {
  const StarredChatState();
  
  @override
  List<Object> get props => [];
}

final class StarredChatInitial extends StarredChatState {}
