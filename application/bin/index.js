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
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
var connection_1 = __importDefault(require("./utils/connection"));
require("reflect-metadata");
var express_1 = __importDefault(require("express"));
var routing_controllers_1 = require("routing-controllers");
var costumer_controller_1 = __importDefault(require("./controllers/costumer.controller"));
var product_controller_1 = __importDefault(require("./controllers/product.controller"));
var order_controller_1 = __importDefault(require("./controllers/order.controller"));
var operator_controller_1 = __importDefault(require("./controllers/operator.controller"));
var serve_static_1 = __importDefault(require("serve-static"));
var WebSocket = __importStar(require("ws"));
var authentication_controller_1 = __importDefault(require("./controllers/authentication.controller"));
var kitchen_controller_1 = require("./controllers/kitchen.controller");
var screen_controller_1 = require("./controllers/screen.controller");
var ServerInitializer = /** @class */ (function () {
    function ServerInitializer() {
        var _this = this;
        this.getDatabaseConnection()
            .then(function () { return _this.initializeServer(); });
    }
    ServerInitializer.start = function () {
        var init = new ServerInitializer();
    };
    ServerInitializer.prototype.getDatabaseConnection = function () {
        return __awaiter(this, void 0, void 0, function () {
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, connection_1.default.connect()];
                    case 1:
                        _a.sent();
                        return [4 /*yield*/, connection_1.default.initializeDatabase()];
                    case 2:
                        _a.sent();
                        return [2 /*return*/];
                }
            });
        });
    };
    ServerInitializer.prototype.initializeServer = function () {
        return __awaiter(this, void 0, void 0, function () {
            var port, server;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        port = process.env.PORT || 8080;
                        server = routing_controllers_1.useExpressServer(express_1.default().use("/", serve_static_1.default("public")), {
                            cors: true,
                            currentUserChecker: function (action) { return new authentication_controller_1.default().getOperatorByToken(action); },
                            classTransformer: true,
                            authorizationChecker: function (action, roles) { return new authentication_controller_1.default().authorizeOperator(action, roles); },
                            controllers: [costumer_controller_1.default, product_controller_1.default, order_controller_1.default, operator_controller_1.default, authentication_controller_1.default]
                        }).listen(port);
                        return [4 /*yield*/, this.openRooms(server)];
                    case 1:
                        _a.sent();
                        console.log("Comies server started on port " + port);
                        return [2 /*return*/];
                }
            });
        });
    };
    ServerInitializer.prototype.openRooms = function (server) {
        return __awaiter(this, void 0, void 0, function () {
            var socket;
            var _this = this;
            return __generator(this, function (_a) {
                socket = new WebSocket.Server({ server: server });
                kitchen_controller_1.KitchenController.openKitchen(socket);
                socket.on("connection", function (srv, req) { return __awaiter(_this, void 0, void 0, function () {
                    var routes_1, operator, partnerID_1, storeID_1, error_1;
                    return __generator(this, function (_a) {
                        switch (_a.label) {
                            case 0:
                                _a.trys.push([0, 2, , 3]);
                                routes_1 = req.url.split('/');
                                return [4 /*yield*/, new authentication_controller_1.default().getOperatorBySocketToken(req.headers.authorization)];
                            case 1:
                                operator = _a.sent();
                                if (operator) {
                                    console.log('Operator ' + operator.id + ' from store ' + operator.store.id + ' connected to the socket with address :' + req.socket.remoteAddress);
                                    partnerID_1 = Number.parseInt(routes_1[2], 10);
                                    storeID_1 = Number.parseInt(routes_1[3], 10);
                                    if (partnerID_1 === operator.partner.id && storeID_1 === operator.store.id) {
                                        switch (routes_1[1]) {
                                            case "":
                                                srv.close();
                                                break;
                                            case "kitchen":
                                                kitchen_controller_1.KitchenController.addClient(srv, partnerID_1, storeID_1, operator);
                                                break;
                                            case "screen":
                                                screen_controller_1.ScreenController.addClient(srv, partnerID_1, storeID_1, operator, routes_1[4] === "TV");
                                                break;
                                            default:
                                                srv.close();
                                                break;
                                        }
                                        srv.on("message", function (message) {
                                            switch (routes_1[1]) {
                                                case "":
                                                    srv.close();
                                                    break;
                                                case "kitchen":
                                                    kitchen_controller_1.KitchenController.receiveSocket(message, routes_1.slice(2));
                                                    break;
                                                case "screen":
                                                    screen_controller_1.ScreenController.receiveSocket(message, routes_1.slice(2));
                                                    break;
                                                default:
                                                    srv.close();
                                                    break;
                                            }
                                        });
                                        srv.on("close", function (message) {
                                            switch (routes_1[1]) {
                                                case "": break;
                                                case "kitchen":
                                                    kitchen_controller_1.KitchenController.removeClient(srv, partnerID_1, storeID_1);
                                                    break;
                                                default: break;
                                            }
                                        });
                                    }
                                    else
                                        srv.close();
                                }
                                else
                                    srv.close();
                                return [3 /*break*/, 3];
                            case 2:
                                error_1 = _a.sent();
                                srv.close();
                                return [3 /*break*/, 3];
                            case 3: return [2 /*return*/];
                        }
                    });
                }); });
                return [2 /*return*/];
            });
        });
    };
    return ServerInitializer;
}());
ServerInitializer.start();
//# sourceMappingURL=index.js.map