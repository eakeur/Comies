"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var order_1 = __importDefault(require("../structures/order"));
var order_service_1 = __importDefault(require("../services/order.service"));
var KitchenController = /** @class */ (function () {
    function KitchenController() {
    }
    KitchenController.openKitchen = function (socket) {
        KitchenController.socket = socket;
    };
    KitchenController.addClient = function (client, partnerID, storeID, operator) {
        return __awaiter(this, void 0, void 0, function () {
            var socketSet, orderMap, socketSet, _a, _b, _c, _d;
            return __generator(this, function (_e) {
                switch (_e.label) {
                    case 0:
                        if (KitchenController.rooms.has(partnerID)) {
                            if (KitchenController.rooms.get(partnerID).has(storeID))
                                KitchenController.rooms.get(partnerID).get(storeID).add(client);
                            else {
                                socketSet = new Set();
                                socketSet.add(client);
                                KitchenController.rooms.get(partnerID);
                            }
                        }
                        else {
                            orderMap = new Map();
                            socketSet = new Set();
                            socketSet.add(client);
                            orderMap.set(storeID, socketSet);
                            KitchenController.rooms.set(partnerID, orderMap);
                        }
                        _b = (_a = client).send;
                        _d = (_c = JSON).stringify;
                        return [4 /*yield*/, new order_service_1.default(operator).getOrders(new order_1.default())];
                    case 1:
                        _b.apply(_a, [_d.apply(_c, [(_e.sent()).data])]);
                        return [2 /*return*/];
                }
            });
        });
    };
    KitchenController.removeClient = function (client, partnerID, storeID) {
        KitchenController.rooms.get(partnerID).get(storeID).delete(client);
    };
    KitchenController.sendOrderToKitchen = function (order) {
        if (KitchenController.rooms.has(order.store.partner.id)) {
            if (KitchenController.rooms.get(order.store.partner.id).has(order.store.id)) {
                KitchenController.rooms.get(order.store.partner.id).get(order.store.id).forEach(function (client) {
                    client.send(JSON.stringify([order]));
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