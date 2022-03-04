part of 'user_with_post_bloc.dart';

abstract class UserWithPostState extends Equatable {
  const UserWithPostState();

  @override
  List<Object> get props => [];
}

class UserWithPostInitial extends UserWithPostState {}

class UsersFetched extends UserWithPostState {
  final UserData users;

  const UsersFetched(this.users);

  @override
  List<Object> get props => [users];
}

class UserFetchedError extends UserWithPostState {
  final String message;
  const UserFetchedError(this.message);

  @override
  List<Object> get props => [message];
}
