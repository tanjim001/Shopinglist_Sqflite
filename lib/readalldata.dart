import 'package:sqlcrud/model.dart';

class ReadAllResult {
  final List<Crudmodel> data;
  final double total;

  ReadAllResult(this.data, this.total);
}