import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'publicacion_event.dart';
part 'publicacion_state.dart';

class PublicacionBloc extends Bloc<PublicacionEvent, PublicacionState> {
  PublicacionBloc() : super(PublicacionInitial()) {
    on<PublicacionEvent>((event, emit) {});
  }
}
