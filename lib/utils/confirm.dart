class Confirm {

  static final Confirm _instancia = Confirm._internal();

  factory Confirm() {
    return _instancia;
  }

  Confirm._internal();

  int counter = 0;
}
