import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'starred_chat_event.dart';
part 'starred_chat_state.dart';

class StarredChatBloc extends Bloc<StarredChatEvent, StarredChatState> {
  StarredChatBloc() : super(StarredChatInitial()) {
    on<StarredChatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
