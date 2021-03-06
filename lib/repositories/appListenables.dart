import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:freshology/models/cart.dart';
import 'package:freshology/models/userModel.dart';

// ValueNotifier<List<Cart>> currentCart = new ValueNotifier(<Cart>[]);
// ValueNotifier<double> cartValue = new ValueNotifier(0.00);

ValueNotifier<User> currentUser = new ValueNotifier(User());
