part of 'manager_bloc.dart';

@immutable
sealed class ManagerState {}

final class ManagerInitial extends ManagerState {}

final class ErrorState extends ManagerState {}

final class SuccessState extends ManagerState {}
