import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheger_parking/bloc/home_event.dart';
import 'package:sheger_parking/bloc/home_state.dart';

class CurrentIndexBloc extends Bloc<NewIndexEvent, CurrentIndexState>{
  CurrentIndexBloc() : super(CurrentIndexState(0)) {
    on<NewIndexEvent>((NewIndexEvent event, Emitter emit) {
      emit(CurrentIndexState(event.index));
    });
  }
}