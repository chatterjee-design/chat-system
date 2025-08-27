import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_search_event.dart';
part 'chat_search_state.dart';

class ChatSearchBloc extends Bloc<ChatSearchEvent, ChatSearchState> {
  ChatSearchBloc() : super(ChatSearchInitial()) {
    on<ChatSearchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
