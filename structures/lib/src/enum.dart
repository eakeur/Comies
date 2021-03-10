enum Permission { get, put, add, del }

enum Unity { kilogram, milgram, litre, mililitre, unity }

enum Status {
  pending,
  confirmed,
  preparing,
  waiting,
  onTheWay,
  delivered,
  finished
}

enum PaymentMethod {cash, debit, credit, pix, transference}

enum DeliverType {takeout, delivery}

enum LoadStatus { loading, loaded, failed, waitingStart }

enum ConfigKey {

    allowStoresToAddProducts,
    allowStoresToChangeProducts,
    allowDividedUnity,
}

enum ConfigValue {
    Allowed,
    NotAllowed,
    HalvesOnly,
    ThirdAndHalvesOnly
}