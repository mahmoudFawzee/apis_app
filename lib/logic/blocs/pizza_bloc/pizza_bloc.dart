import 'dart:developer';

import 'package:apis/data/models/pizza.dart';
import 'package:apis/data/services/pizza_service.dart';
import 'package:apis/view/resources/strings/strings_manger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pizza_event.dart';
part 'pizza_state.dart';

class PizzaBloc extends Bloc<PizzaEvent, PizzaState> {
  PizzaBloc() : super(const PizzaInitial()) {
    final PizzaService pizzaService = PizzaService();
    on<GetPizzasEvent>((event, emit) async {
      emit(const PizzaLoadingState());
      try {
        final pizzasList = await pizzaService.getPizzas();
        if (pizzasList == null) {
          emit(const GotPizzaErrorState('some error occurred'));
        } else if (pizzasList.isEmpty) {
          emit(const NoPizzasState());
        } else {
          emit(GotPizzasState(pizzasList));
        }
      } catch (e) {
        log(e.toString());
        emit(GotPizzaErrorState(e.toString()));
      }
    });

    on<PostNewPizza>((event, emit) async {
      emit(const PizzaLoadingState());
      try {
        final newId = await pizzaService.getNewPizzaId();
        final pizza = Pizza(
          id: newId,
          name: event.name,
          description: event.description,
          imageUrl:
              'https://t4.ftcdn.net/jpg/01/92/79/53/360_F_192795305_qVIymD7LGorjBCt0EVSpjrRj0kL51oCh.jpg',
          price: event.price,
        );
        final response = await pizzaService.postPizza(pizza);
        log('$response');
        if (response == null) {
          emit(const GotPizzaErrorState(StringsManger.error));
        } else {
          emit(const PostedNewPizzaState());
        }
      } catch (e) {
        emit(GotPizzaErrorState(e.toString()));
      }
    });

    on<UpdatePizzaEvent>((event, emit) async {
      emit(const PizzaLoadingState());
      try {
        final pizza = Pizza(
          id: event.id,
          name: event.newName,
          description: event.newDescription,
          imageUrl: event.imageUrl,
          price: event.price,
        );
        final updated = await pizzaService.updatePizza(pizza);
        if (updated == null || !updated) {
          emit(const GotPizzaErrorState(StringsManger.error));
        } else if (updated) {
          emit(const UpdatedPizzaState());
        }
      } catch (e) {
        emit(GotPizzaErrorState(e.toString()));
      }
    });

    on<DeletePizzaEvent>((event, emit) async {
      emit(const PizzaLoadingState());
      try {
        final deleted = await pizzaService.deletePizza(event.id);
        if (deleted == null || !deleted) {
          emit(const GotPizzaErrorState(StringsManger.error));
        } else {
          emit(const DeletedPizzaState());
        }
      } catch (e) {
        emit(GotPizzaErrorState(e.toString()));
      }
    });
  }
}
