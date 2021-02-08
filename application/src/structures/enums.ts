export enum ConfigKey {

    allowStoresToAddProducts = 1,
    allowStoresToChangeProducts = 3,
    allowDividedUnity = 2,
}

export enum ConfigValue {
    Allowed = 1,
    NotAllowed = 2,
    HalvesOnly = 3,
    ThirdAndHalvesOnly = 4
}

export enum Unity {
    kilogram = 1,
    miligram = 2,
    litre = 3,
    mililitre = 5,
    unity = 4,
}

export enum Status {
    pending = 0,
    confirmed = 1,
    preparing = 2,
    waiting = 3,
    onTheWay = 4,
    delivered = 5,
    finished = 6
}

enum Permission { get, put, add, del }