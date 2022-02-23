part of 'publicaciones_bloc.dart';

abstract class PublicacionesState extends Equatable {
  const PublicacionesState();
  
  @override
  List<Object> get props => [];
}

class PublicacionesInitial extends PublicacionesState {}


class PublicacionesFetched extends PublicacionesState {
  final List<Publicacion> publicaciones;
  final String type;

  const PublicacionesFetched(this.publicaciones, this.type);

  @override
  List<Object> get props => [publicaciones];
}

class PublicacionFetchError extends PublicacionesState {
  final String message;
  const PublicacionFetchError(this.message);

  @override
  List<Object> get props => [message];
}