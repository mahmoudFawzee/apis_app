part of 'pizza_bloc.dart';

abstract class PizzaState extends Equatable {
  const PizzaState();

  @override
  List<Object> get props => [];
}

class PizzaInitial extends PizzaState {
  const PizzaInitial();
}

class PizzaLoadingState extends PizzaState {
  const PizzaLoadingState();
}

class GotPizzasState extends PizzaState {
  final List<Pizza> pizzas;
  const GotPizzasState(this.pizzas);
  @override
  List<Object> get props => [pizzas];
}

class NoPizzasState extends PizzaState {
  const NoPizzasState();
}

class GotPizzaErrorState extends PizzaState {
  final String error;
  const GotPizzaErrorState(this.error);
  @override
  List<Object> get props => [error];
}

class PostedNewPizzaState extends PizzaState {
  const PostedNewPizzaState();
}

class UpdatedPizzaState extends PizzaState {
  const UpdatedPizzaState();
}

class DeletedPizzaState extends PizzaState {
  const DeletedPizzaState();
}
