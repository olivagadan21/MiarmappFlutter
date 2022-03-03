import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_miarmapp/models/publicacion_dto.dart';
import 'package:flutter_miarmapp/models/publicacion_model.dart';
import 'package:flutter_miarmapp/repository/publicacion_repository/publicacion_repository.dart';

part 'bloc_publicaciones_event.dart';
part 'bloc_publicaciones_state.dart';

class BlocPublicacionesBloc
    extends Bloc<BlocPublicacionesEvent, BlocPublicacionesState> {
  final PublicacionRepository public;

  BlocPublicacionesBloc(this.public) : super(BlocPublicacionesInitial()) {
    on<FetchPublicacionWithType>(_publicacionesFetched);
    on<DoPublicacionEvent>(_doPublicacionEvent);
  }

  void _publicacionesFetched(FetchPublicacionWithType event,
      Emitter<BlocPublicacionesState> emit) async {
    try {
      final publicaciones = await public.fetchPublicaciones(event.type);
      emit(PublicacionesFetched(publicaciones, event.type));
      return;
    } on Exception catch (e) {
      emit(PublicacionFetchError(e.toString()));
    }
  }

  void _doPublicacionEvent(
      DoPublicacionEvent event, Emitter<BlocPublicacionesState> emit) async {
    try {
      final loginResponse =
          await public.createPublicacion(event.registerDto, event.imagePath);
      emit(PublicacionesSuccessState(loginResponse));
      return;
    } on Exception catch (e) {
      emit(PublicacionErrorState(e.toString()));
    }
  }
}
