import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class PublicacionesBloc extends Bloc<PublicacionesEvent, PublicacionesState> {
  final PublicacionRepository publicacionRepository;

  PublicacionesBloc(this.publicacionRepository) : super(PublicacionesInitial()) {
    on<FetchPublicacionWithType>(_publicacionesFetched);
  }

  void _publicacionesFetched(FetchPublicacionWithType event, Emitter<PublicacionesState> emit) async {
    try {
      final publicaciones = await publicacionRepository.fetchPublicaciones(event.type);
      emit(PublicacionesFetched(publicaciones, event.type));
      return;
    } on Exception catch (e) {
      emit(PublicacionFetchError(e.toString()));
    }
  }
}