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
var connection_1 = __importDefault(require("../utils/connection"));
var response_1 = __importDefault(require("../structures/response"));
var order_1 = __importDefault(require("../structures/order"));
var notification_1 = __importDefault(require("../structures/notification"));
var OrderService = /** @class */ (function () {
    function OrderService(operator) {
        this.response = new response_1.default();
        this.collection = connection_1.default.db.getRepository(order_1.default);
        this.operator = operator;
    }
    OrderService.prototype.addOrder = function (order) {
        return __awaiter(this, void 0, void 0, function () {
            var error_1;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        order.operator = this.operator;
                        order.store = this.operator.store;
                        return [4 /*yield*/, this.collection.save(order)];
                    case 1:
                        _a.sent();
                        this.response.notification = new notification_1.default("Pedido adicionado com sucesso!");
                        return [3 /*break*/, 3];
                    case 2:
                        error_1 = _a.sent();
                        console.log(error_1.message);
                        this.response.success = false;
                        this.response.notification = new notification_1.default("Um erro ocorreu ao adicionar esse pedido. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OrderService.prototype.removeOrder = function (order) {
        return __awaiter(this, void 0, void 0, function () {
            var response, error_2;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        response = new response_1.default();
                        _a.label = 1;
                    case 1:
                        _a.trys.push([1, 3, , 4]);
                        if (order.store !== this.operator.store) {
                            throw Error;
                        }
                        return [4 /*yield*/, this.collection.remove(order)];
                    case 2:
                        _a.sent();
                        this.response.notification = new notification_1.default("Pedido excluído com sucesso!");
                        return [3 /*break*/, 4];
                    case 3:
                        error_2 = _a.sent();
                        console.log(error_2.message);
                        this.response.success = false;
                        this.response.notification = new notification_1.default("Ocorreu um erro ao excluir este pedido. Por favor, tente mais tarde ou fale com um administrador.");
                        return [3 /*break*/, 4];
                    case 4: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OrderService.prototype.updateOrder = function (order) {
        return __awaiter(this, void 0, void 0, function () {
            var error_3;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        if (order.store !== this.operator.store) {
                            throw Error;
                        }
                        return [4 /*yield*/, this.collection.save(order)];
                    case 1:
                        _a.sent();
                        this.response.notification = new notification_1.default("Pedido atualizado com sucesso!");
                        return [3 /*break*/, 3];
                    case 2:
                        error_3 = _a.sent();
                        console.log(error_3.message);
                        this.response.success = false;
                        this.response.notification = new notification_1.default("Ocorreu um erro ao atualizar este pedido. Por favor, tente mais tarde ou fale com um administrador.");
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OrderService.prototype.getOrderById = function (id) {
        return __awaiter(this, void 0, void 0, function () {
            var order, error_4;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        return [4 /*yield*/, this.collection.findOne(id)];
                    case 1:
                        order = _a.sent();
                        if (order.store !== this.operator.store) {
                            throw Error;
                        }
                        this.response.data = order;
                        return [3 /*break*/, 3];
                    case 2:
                        error_4 = _a.sent();
                        console.log(error_4.message);
                        this.response.success = false;
                        this.response.notification = new notification_1.default("Ocorreu um erro ao procurar por este pedido. Por favor, tente mais tarde ou fale com um administrador.");
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OrderService.prototype.getOrders = function (filters) {
        return __awaiter(this, void 0, void 0, function () {
            var query, _a, error_5;
            return __generator(this, function (_b) {
                switch (_b.label) {
                    case 0:
                        _b.trys.push([0, 2, , 3]);
                        if (filters.store) {
                            if (filters.store !== this.operator.store) {
                                throw Error;
                            }
                        }
                        query = this.collection.createQueryBuilder();
                        query.where("active = 1");
                        query.orderBy("placed");
                        _a = this.response;
                        return [4 /*yield*/, query.getMany()];
                    case 1:
                        _a.data = _b.sent();
                        return [3 /*break*/, 3];
                    case 2:
                        error_5 = _b.sent();
                        console.error(error_5);
                        this.response.success = false;
                        this.response.notification = new notification_1.default("Ocorreu um erro ao procurar por pedidos. Por favor, tente mais tarde ou fale com um administrador.");
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    return OrderService;
}());
exports.default = OrderService;
//# sourceMappingURL=order.service.js.map