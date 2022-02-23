part of 'publicaciones_bloc.dart';


abstract class PublicacionesEvent extends Equatable {
  const PublicacionesEvent();

  @override
  List<Object> get props => [];
}

class FetchPublicacionWithType extends PublicacionesEvent {
  final String type;

  const FetchPublicacionWithType(this.type);

  @override
  List<Object> get props => [type];
}