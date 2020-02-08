import 'package:zoom/components/classes.dart';

class StoreManager {
  List<Order> orders;

  Store store;
  StoreManager({this.store}) {
    orders = new List<Order>();
    orders.add(new Order(
      client: Client(
        name: "Amanda Plant",
        email: "plant.ethan@gmail.com",
        phone: "2267914365"
      ),
      items: new List<Item>(),
      driver: Driver(
        name: "John Doe",
        email: "bbbb@gmail.com",
        phone: "1234567890",
        licensePlate: "abcd-1234"
      ),
      id: "792847698"
    ));

    orders[0].items.add(new Item(
      price: 19.95
    ));

    orders.add(new Order(
        client: Client(
            name: "Amanda Plant",
            email: "plant.ethan@gmail.com",
            phone: "2267914365"
        ),
        items: new List<Item>(),
        driver: Driver(
            name: "John Doe",
            email: "bbbb@gmail.com",
            phone: "1234567890",
            licensePlate: "abcd-1234"
        ),
        id: "73494329"
    ));

    orders[1].items.add(new Item(
        price: 19.95
    ));
  }

}