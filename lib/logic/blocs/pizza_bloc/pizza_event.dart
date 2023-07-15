part of 'pizza_bloc.dart';

abstract class PizzaEvent extends Equatable {
  const PizzaEvent();

  @override
  List<Object> get props => [];
}

class GetPizzasEvent extends PizzaEvent {
  const GetPizzasEvent();
}

class PostNewPizza extends PizzaEvent {
  final String name;
  final String price;
  final String description;
  const PostNewPizza({
    required this.name,
    required this.description,
    required this.price,
  });
  @override
  List<Object> get props => [
        name,
        description,
        price,
      ];
}

class UpdatePizzaEvent extends PizzaEvent {
  final int id;
  final String newName;
  final String imageUrl;
  final String newDescription;
  final String price;
  const UpdatePizzaEvent(
      {required this.id,
      required this.newName,
      required this.newDescription,
      required this.imageUrl,
      required this.price});
  @override
  List<Object> get props => [id, newName, newDescription, imageUrl, price];
}

class DeletePizzaEvent extends PizzaEvent {
  final int id;
  const DeletePizzaEvent({required this.id});
  @override
  List<Object> get props => [id];
}
