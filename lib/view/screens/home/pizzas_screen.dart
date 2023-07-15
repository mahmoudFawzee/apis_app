import 'dart:developer';

import 'package:apis/logic/blocs/pizza_bloc/pizza_bloc.dart';
import 'package:apis/view/resources/colors/colors_manger.dart';
import 'package:apis/view/resources/strings/strings_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PizzasScreen extends StatelessWidget {
  const PizzasScreen({super.key});
  static const pageRoute = 'pizzas_page';
  static TextEditingController _nameController = TextEditingController();
  static TextEditingController _desController = TextEditingController();
  static TextEditingController _priceController = TextEditingController();
  static TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringsManger.pizzasHome),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => pizzaDialog(
                  context,
                  isUpdate: false,
                  onPressed: () {
                    final name = _nameController.value.text;
                    final description = _desController.value.text;
                    final price = _priceController.value.text;
                    if (name.isEmpty || price.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            StringsManger.invalid,
                          ),
                        ),
                      );
                    } else {
                      context.read<PizzaBloc>().add(
                            PostNewPizza(
                              name: _nameController.value.text,
                              description: _desController.value.text,
                              price: _priceController.value.text,
                            ),
                          );
                      Navigator.pop(context);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<PizzaBloc, PizzaState>(
        listener: (context, state) {
          if (state is PostedNewPizzaState) {
            context.read<PizzaBloc>().add(const GetPizzasEvent());
          } else if (state is UpdatedPizzaState) {
            context.read<PizzaBloc>().add(const GetPizzasEvent());
          } else if (state is DeletedPizzaState) {
            context.read<PizzaBloc>().add(const GetPizzasEvent());
          }
        },
        builder: (context, state) {
          if (state is GotPizzasState) {
            log('$state');
            final pizzas = state.pizzas;
            return ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzas[index];
                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(pizza.imageUrl),
                          backgroundColor: ColorsManger.blueGrey,
                        ),
                        title: Text(pizza.name),
                        subtitle:
                            Text('${pizza.description} : ${pizza.price}\$'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              _nameController =
                                  TextEditingController(text: pizza.name);
                              _desController = TextEditingController(
                                  text: pizza.description);
                              _priceController =
                                  TextEditingController(text: pizza.price);
                              _imageUrlController =
                                  TextEditingController(text: pizza.imageUrl);
                              await showDialog(
                                context: context,
                                builder: (_) => pizzaDialog(
                                  context,
                                  isUpdate: true,
                                  onPressed: () {
                                    final name = _nameController.value.text;
                                    final description =
                                        _desController.value.text;
                                    final price = _priceController.value.text;
                                    final imageUrl =
                                        _imageUrlController.value.text;
                                    if (name.isEmpty ||
                                        price.isEmpty ||
                                        description.isEmpty ||
                                        imageUrl.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            StringsManger.invalid,
                                          ),
                                        ),
                                      );
                                    } else {
                                      context.read<PizzaBloc>().add(
                                            UpdatePizzaEvent(
                                              id: pizza.id,
                                              newName:
                                                  _nameController.value.text,
                                              newDescription:
                                                  _desController.value.text,
                                              price:
                                                  _priceController.value.text,
                                              imageUrl: _imageUrlController
                                                  .value.text,
                                            ),
                                          );
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(StringsManger.delete),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(StringsManger.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<PizzaBloc>().add(
                                              DeletePizzaEvent(id: pizza.id));
                                          Navigator.pop(context);
                                        },
                                        child: const Text(StringsManger.delete),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: ColorsManger.red,
                              ))
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is PizzaLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManger.blue,
              ),
            );
          } else if (state is NoPizzasState) {
            return const Center(
              child: Text(StringsManger.nothing),
            );
          } else if (state is GotPizzaErrorState) {
            return Center(
              child: Text(state.error),
            );
          }
          return Container();
        },
      ),
    );
  }

  AlertDialog pizzaDialog(
    BuildContext context, {
    required bool isUpdate,
    required void Function()? onPressed,
  }) {
    return AlertDialog(
      title: const Text(StringsManger.addNew),
      content: Container(
        height: 200,
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              pizzaField(
                label: StringsManger.name,
                controller: _nameController,
              ),
              pizzaField(
                label: StringsManger.description,
                controller: _desController,
              ),
              pizzaField(
                label: StringsManger.price,
                controller: _priceController,
              ),
              Visibility(
                visible: isUpdate,
                child: pizzaField(
                  label: StringsManger.imageUrl,
                  controller: _imageUrlController,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(StringsManger.cancel)),
        TextButton(onPressed: onPressed, child: const Text(StringsManger.add)),
      ],
    );
  }

  Widget pizzaField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
