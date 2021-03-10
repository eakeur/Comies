"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var socket_io_1 = require("socket.io");
var KitchenController = /** @class */ (function () {
    function KitchenController(server) {
    }
    KitchenController.openKitchen = function (io) {
        KitchenController.socket = new socket_io_1.Server(io);
        KitchenController.socket.on('connection', function (socket) {
            console.log('a user connected');
            socket.on('chat message', function (msg) {
                console.log('message: ' + msg);
            });
            socket.on('disconnect', function () {
                console.log('user disconnected');
            });
        });
    };
    KitchenController.sendOrderToKitchen = function (order) {
        KitchenController.socket.emit('newOrder');
    };
    return KitchenController;
}());
exports.KitchenController = KitchenController;
//# sourceMappingURL=kitchen.controller.js.map