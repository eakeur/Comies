"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var WebSocket = __importStar(require("ws"));
var costumer_service_1 = __importDefault(require("../services/costumer.service"));
var costumer_1 = __importDefault(require("../structures/costumer"));
var KitchenController = /** @class */ (function () {
    function KitchenController() {
    }
    KitchenController.openKitchen = function (io) {
        var _this = this;
        KitchenController.socket = new WebSocket.Server({ server: io })
            .on("connection", function (srv) {
            console.log('a user connected on ' + srv.url);
            srv.on("message", function (message) { return _this.sendOrderToKitchen({ message: message }); });
            new costumer_service_1.default().getCostumers(new costumer_1.default())
                .then(function (x) { return srv.send(JSON.stringify(x.data)); });
        });
    };
    KitchenController.sendOrderToKitchen = function (data) {
        KitchenController.socket.clients.forEach(function (client) { return client.send(JSON.stringify(data)); });
    };
    return KitchenController;
}());
exports.KitchenController = KitchenController;
//# sourceMappingURL=kitchen.controller.js.map