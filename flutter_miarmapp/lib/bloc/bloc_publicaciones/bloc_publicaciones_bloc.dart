import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_miarmapp/models/publicacion_model.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository.dart';

part 'bloc_publicaciones_event.dart';
part 'bloc_publicaciones_state.dart';

class BlocPublicacionesBloc extends Bloc<BlocPublicacionesEvent, BlocPublicacionesState> {

  final PublicacionRepository public;

  BlocPublicacionesBloc(this.public) : super(BlocPublicacionesInitial()) {
    on<FetchPublicacionWithType>(_publicacionesFetched);
}

void _publicacionesFetched(FetchPublicacionWithType event, Emitter<BlocPublicacionesState> emit) async {
    try {
      final movies = await public.fetchPublicaciones(event.type);
      emit(PublicacionesFetched(movies, event.type));
      return;
    } on Exception catch (e) {
      emit(PublicacionFetchError(e.toString()));
    }
  }
}
