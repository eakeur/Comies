"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var KitchenController = /** @class */ (function () {
    function KitchenController() {
    }
    KitchenController.openKitchen = function (socket) {
        KitchenController.socket = socket;
    };
    KitchenController.addClient = function (client, partnerID, storeID) {
        if (KitchenController.rooms.has(partnerID)) {
            if (KitchenController.rooms.get(partnerID).has(storeID))
                KitchenController.rooms.get(partnerID).get(storeID).add(client);
            else {
                var socketSet = new Set();
                socketSet.add(client);
                KitchenController.rooms.get(partnerID);
            }
        }
        else {
            var orderMap = new Map();
            var socketSet = new Set();
            socketSet.add(client);
            orderMap.set(storeID, socketSet);
            KitchenController.rooms.set(partnerID, orderMap);
        }
    };
    KitchenController.removeClient = function (client, partnerID, storeID) {
        KitchenController.rooms.get(partnerID).get(storeID).delete(client);
    };
    KitchenController.sendOrderToKitchen = function (order) {
        if (KitchenController.rooms.has(order.store.partner.id)) {
            if (KitchenController.rooms.get(order.store.partner.id).has(order.store.id)) {
                KitchenController.rooms.get(order.store.partner.id).get(order.store.id).forEach(function (client) {
                    client.send(JSON.stringify(order));
                });
            }
        }
    };
    KitchenController.receiveSocket = function (message, route) {
        try {
            KitchenController.rooms.get(Number.parseInt(route[0], 10)).get(Number.parseInt(route[1], 10))
                .forEach(function (cli) { return cli.send("Someone put something on the oven: " + message); });
        }
        catch (error) {
        }
    };
    KitchenController.rooms = new Map();
    return KitchenController;
}());
exports.KitchenController = KitchenController;
//# sourceMappingURL=kitchen.controller.js.map