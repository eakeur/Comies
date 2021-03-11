"use strict";
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
var WebSocket = __importStar(require("ws"));
var DeliveryController = /** @class */ (function () {
    function DeliveryController() {
    }
    DeliveryController.openKitchen = function (io) {
        DeliveryController.socket = new WebSocket.Server({ noServer: true })
            .on("connection", function (srv) {
            console.log('Someone started driving');
            srv.on("message", function (message) {
                return DeliveryController.socket.clients.forEach(function (client) { return client.send("New location"); });
            });
        });
    };
    DeliveryController.sendOrderToKitchen = function (order) {
        DeliveryController.socket.clients.forEach(function (client) {
            return client.send(JSON.stringify(order));
        });
    };
    return DeliveryController;
}());
exports.DeliveryController = DeliveryController;
//# sourceMappingURL=delivery.controller.js.map