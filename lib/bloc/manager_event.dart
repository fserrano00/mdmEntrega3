part of 'manager_bloc.dart';

@immutable
sealed class ManagerEvent extends Equatable {
  const ManagerEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends ManagerEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
