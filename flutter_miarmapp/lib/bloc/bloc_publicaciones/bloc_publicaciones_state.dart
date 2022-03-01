part of 'bloc_publicaciones_bloc.dart';

abstract class BlocPublicacionesState extends Equatable {
  const BlocPublicacionesState();
  
  @override
  List<Object> get props => [];
}

class BlocPublicacionesInitial extends BlocPublicacionesState {}

class PublicacionesFetched extends BlocPublicacionesState {
  final List<PublicacionData> movies;
  final String type;

  const PublicacionesFetched(this.movies, this.type);

  @override
  List<Object> get props => [movies];
}

class PublicacionFetchError extends BlocPublicacionesState {
  final String message;
  const PublicacionFetchError(this.message);

  @override
  List<Object> get props => [message];
}
