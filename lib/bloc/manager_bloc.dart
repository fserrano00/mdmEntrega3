import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'manager_event.dart';
part 'manager_state.dart';

//Extraer el metodo y y asignar los evnetos del bloc de event
class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  ManagerBloc() : super(ManagerInitial()) {
    on<LoginEvent>(_loginEvent);
  }
  //apuntar y asignar el espacio de las operaciones
  FutureOr<void> _loginEvent(LoginEvent event, Emitter emit) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (userCredential != null) {
        emit(SuccessState());
      } else {
        emit(ErrorState());
      }
      ; // Devuelve el userCredential si el inicio de sesión fue exitoso.
    } catch (e) {
      print("Error: $e");
      emit(ErrorState()); // Retorna null si el inicio de sesión falló.
    }
  }
}
