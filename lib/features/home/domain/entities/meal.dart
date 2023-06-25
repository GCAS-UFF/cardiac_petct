import 'package:cardiac_petct/features/home/domain/entities/meal_item.dart';
import 'package:cardiac_petct/features/home/domain/entities/meal_type.dart';

enum CurrencyEnum { real, dolar, euro }

class Meal {
  final String? id;
  final List<MealItem>? items;
  final String? imageUrl;
  final MealType? type;
  final CurrencyEnum currency;
  final String typeId;
  final double price;
  final List<String> itemsIds;

  Meal(this.id, this.items, this.imageUrl, this.type,
      {required this.currency,
      required this.price,
      required this.typeId,
      required this.itemsIds});
}