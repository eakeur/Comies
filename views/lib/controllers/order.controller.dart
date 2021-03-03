import 'package:comies_entities/comies_entities.dart';

class NewOrderController {

  Item item;
  List<Item> items = [];
  
  
  setItem(Product product, {bool trigger = true}){
    var existents = items.where((item) => item.product == product).toList();
    if (existents.isNotEmpty){
      item = items[items.indexOf(existents[0])];
    } else {
      item = new Item();
      item.quantity = product.min;
      item.group = 1;
      item.product = product;
    }
    if (trigger) callListeners(NewOrderTriggerType.itemCreation, item);
  }

  bool get hasItemPositioned => item != null && item.product != null;


  void addItem({bool trigger = true}){
    if (!items.contains(item)) items.add(item);
    else items[items.indexOf(item)] = item;
    if (trigger) callListeners(NewOrderTriggerType.itemAddition, item);

  }

  void cancelItemEdition({bool trigger = true}){
    item = null;
    if (trigger) callListeners(NewOrderTriggerType.itemCancellation, item);
  }

  void removeItem(Item item, {bool trigger = true}){
    if (this.item == item) cancelItemEdition();
    items.remove(item);
    if (trigger) callListeners(NewOrderTriggerType.itemDeletion, item);
  }

  void changeItemQuantity(double quantity, {bool trigger = true}){
    item.quantity = quantity;
    if (trigger) callListeners(NewOrderTriggerType.itemQuantityChange, item);
  }

  void onItemQuantityChange(String change){
    change = change.replaceAll(',', '.');
    var q = double.tryParse(change);
    if (q >= item.product.min) {changeItemQuantity(q % item.product.min == 0 ? q : q - (q % item.product.min));}
  }

  //STATIC REGION OF THE CONTROLLER

  static Map<String, Map<NewOrderTriggerType, List<Function(Item)>>> listeners = new Map<String, Map<NewOrderTriggerType, List<Function(Item)>>>();

  static void addListener(String id, NewOrderTriggerType type, Function(Item) listener){
    listeners[id] != null
      ? listeners[id][type] != null ? listeners[id][type].add(listener) : listeners[id][type] = [listener]
      : listeners[id] = {type : [listener]};
  }
  static void callListeners(NewOrderTriggerType type, Item item){
    listeners.forEach((key, list){
        if (list[type] != null)list[type]
        .forEach((listener) => {if (listener != null)listener(item)});
      }
    );
  }
  static void removeListeners(String id, {NewOrderTriggerType type}){
    if (id != null){
      if (type != null) listeners[id].remove(type);
      else listeners.remove(id);
    }
  }
}

enum NewOrderTriggerType {
  itemCreation, itemQuantityChange, itemAddition, itemDeletion, itemCancellation
}