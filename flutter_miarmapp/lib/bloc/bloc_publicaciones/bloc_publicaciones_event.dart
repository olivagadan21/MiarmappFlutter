part of 'bloc_publicaciones_bloc.dart';

abstract class BlocPublicacionesEvent extends Equatable {
  const BlocPublicacionesEvent();

  @override
  List<Object> get props => [];
}

class FetchPublicacionWithType extends BlocPublicacionesEvent {
  final String type;

  const FetchPublicacionWithType(this.type);

  @override
  List<Object> get props => [type];
}

class DoPublicacionEvent extends BlocPublicacionesEvent {
  final PublicacionDto registerDto;
  final String imagePath;

  const DoPublicacionEvent(this.registerDto, this.imagePath);
}
