part of 'user_with_post_bloc.dart';

abstract class UserWithPostEvent extends Equatable {
  const UserWithPostEvent();

  @override
  List<Object> get props => [];
}

class FetchUserWithType extends UserWithPostEvent {
  const FetchUserWithType();

  @override
  List<Object> get props => [];
}
