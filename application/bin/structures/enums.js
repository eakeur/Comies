"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var ConfigKey;
(function (ConfigKey) {
    ConfigKey[ConfigKey["allowStoresToAddProducts"] = 1] = "allowStoresToAddProducts";
    ConfigKey[ConfigKey["allowStoresToChangeProducts"] = 3] = "allowStoresToChangeProducts";
    ConfigKey[ConfigKey["allowDividedUnity"] = 2] = "allowDividedUnity";
})(ConfigKey = exports.ConfigKey || (exports.ConfigKey = {}));
var ConfigValue;
(function (ConfigValue) {
    ConfigValue[ConfigValue["Allowed"] = 1] = "Allowed";
    ConfigValue[ConfigValue["NotAllowed"] = 2] = "NotAllowed";
    ConfigValue[ConfigValue["HalvesOnly"] = 3] = "HalvesOnly";
    ConfigValue[ConfigValue["ThirdAndHalvesOnly"] = 4] = "ThirdAndHalvesOnly";
})(ConfigValue = exports.ConfigValue || (exports.ConfigValue = {}));
var Unity;
(function (Unity) {
    Unity[Unity["kilogram"] = 1] = "kilogram";
    Unity[Unity["miligram"] = 2] = "miligram";
    Unity[Unity["litre"] = 3] = "litre";
    Unity[Unity["mililitre"] = 5] = "mililitre";
    Unity[Unity["unity"] = 4] = "unity";
})(Unity = exports.Unity || (exports.Unity = {}));
var Status;
(function (Status) {
    Status[Status["pending"] = 0] = "pending";
    Status[Status["confirmed"] = 1] = "confirmed";
    Status[Status["preparing"] = 2] = "preparing";
    Status[Status["waiting"] = 3] = "waiting";
    Status[Status["onTheWay"] = 4] = "onTheWay";
    Status[Status["delivered"] = 5] = "delivered";
    Status[Status["finished"] = 6] = "finished";
})(Status = exports.Status || (exports.Status = {}));
//# sourceMappingURL=enums.js.map