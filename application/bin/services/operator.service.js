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
var connection_1 = __importDefault(require("../utils/connection"));
var typeorm_1 = require("typeorm");
var operator_1 = __importDefault(require("../structures/operator"));
var response_1 = __importDefault(require("../structures/response"));
var notification_1 = __importDefault(require("../structures/notification"));
var jwt = __importStar(require("jsonwebtoken"));
var OperatorService = /** @class */ (function () {
    function OperatorService(operator) {
        this.response = new response_1.default();
        this.collection = connection_1.default.db.getRepository(operator_1.default);
        this.conditions = {};
        this.operator = operator;
    }
    OperatorService.prototype.addOperator = function (operator) {
        return __awaiter(this, void 0, void 0, function () {
            var error_1;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        return [4 /*yield*/, this.collection.save(operator)];
                    case 1:
                        _a.sent();
                        this.response.notifications.push(new notification_1.default("Operador adicionado com sucesso!"));
                        return [3 /*break*/, 3];
                    case 2:
                        error_1 = _a.sent();
                        console.error(error_1);
                        this.response.success = false;
                        this.response.notifications.push(new notification_1.default("Um erro ocorreu ao adicionar esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OperatorService.prototype.removeOperator = function (operator) {
        return __awaiter(this, void 0, void 0, function () {
            var error_2;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        return [4 /*yield*/, this.collection.remove(operator)];
                    case 1:
                        _a.sent();
                        this.response.notifications.push(new notification_1.default("Operador excluído com sucesso!"));
                        return [3 /*break*/, 3];
                    case 2:
                        error_2 = _a.sent();
                        console.error(error_2);
                        this.response.success = false;
                        this.response.notifications.push(new notification_1.default("Um erro ocorreu ao excluir esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OperatorService.prototype.updateOperator = function (operator) {
        return __awaiter(this, void 0, void 0, function () {
            var error_3;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        if (this.operator.id !== operator.id) {
                            throw Error;
                        }
                        return [4 /*yield*/, this.collection.save(operator)];
                    case 1:
                        _a.sent();
                        this.response.notifications.push(new notification_1.default("Operador atualizado com sucesso!"));
                        return [3 /*break*/, 3];
                    case 2:
                        error_3 = _a.sent();
                        console.error(error_3);
                        this.response.success = false;
                        this.response.notifications.push(new notification_1.default("Um erro ocorreu ao atualizar esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OperatorService.prototype.getOperatorById = function (id) {
        return __awaiter(this, void 0, void 0, function () {
            var result, error_4;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        return [4 /*yield*/, this.collection.findOne(id)];
                    case 1:
                        result = _a.sent();
                        delete result.password;
                        this.response.data = result;
                        return [3 /*break*/, 3];
                    case 2:
                        error_4 = _a.sent();
                        console.error(error_4);
                        this.response.success = false;
                        this.response.notifications.push(new notification_1.default("Ocorreu um erro ao procurar por este operador. Por favor, tente mais tarde ou fale com um administrador."));
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OperatorService.prototype.getOperators = function (filters) {
        return __awaiter(this, void 0, void 0, function () {
            var results, error_5;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        this.conditions.active = true;
                        if (filters.name)
                            this.conditions.name = typeorm_1.Like(filters.name);
                        return [4 /*yield*/, this.collection.find(this.conditions)];
                    case 1:
                        results = _a.sent();
                        results.forEach(function (result) { return delete result.password; });
                        this.response.data = results;
                        return [3 /*break*/, 3];
                    case 2:
                        error_5 = _a.sent();
                        console.error(error_5);
                        this.response.success = false;
                        this.response.notifications.push(new notification_1.default("Ocorreu um erro ao procurar por operadores. Por favor, tente mais tarde ou fale com um administrador."));
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    OperatorService.prototype.authenticate = function (authParams) {
        return __awaiter(this, void 0, void 0, function () {
            var filter, operator, error_6;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        filter = new operator_1.default();
                        filter.identification = authParams.identification;
                        return [4 /*yield*/, this.collection.findOneOrFail(filter)];
                    case 1:
                        operator = _a.sent();
                        if (!operator.active) {
                            throw new Error("Operator " + filter.identification + " is unactive and tried to login.");
                        }
                        if (operator.password === authParams.password) {
                            operator.lastLogin = new Date(Date.now());
                            this.response.access = jwt.sign({ id: operator.id }, connection_1.default.secret, { expiresIn: authParams.remember ? 86400 : 3600 });
                            this.response.success = true;
                        }
                        else {
                            this.response.success = false;
                            this.response.notifications.push(new notification_1.default("Senha incorreta."));
                        }
                        return [3 /*break*/, 3];
                    case 2:
                        error_6 = _a.sent();
                        console.error(error_6);
                        this.response.success = false;
                        this.response.notifications.push(new notification_1.default("Não foi possível encontrar um operador com o apelido especificado. Por favor, verifique se ele foi digitado corretamente ou fale com um administrador"));
                        return [3 /*break*/, 3];
                    case 3: return [2 /*return*/, this.response];
                }
            });
        });
    };
    // Internal use. Nothing here is used by controllers
    OperatorService.prototype.getOperatorByToken = function (action) {
        return __awaiter(this, void 0, void 0, function () {
            var identification, operator, error_7;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        identification = jwt.verify(action.request.headers.authorization, connection_1.default.secret);
                        return [4 /*yield*/, this.collection.findOne(identification.id)];
                    case 1:
                        operator = _a.sent();
                        if (!operator.active)
                            throw new Error('Inactive user');
                        if (new Date(identification.exp).getMinutes() < 60)
                            action.response.locals.jwtPayload = jwt.sign({ id: operator.id }, connection_1.default.secret, { expiresIn: 3600 });
                        return [2 /*return*/, operator];
                    case 2:
                        error_7 = _a.sent();
                        console.log("Operador não autorizado com token: " + action.request.headers.authorization);
                        return [2 /*return*/, undefined];
                    case 3: return [2 /*return*/];
                }
            });
        });
    };
    OperatorService.prototype.authorizeOperator = function (action, roles) {
        return __awaiter(this, void 0, void 0, function () {
            var identification, allowed_1, operator, allowances_1, error_8;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        _a.trys.push([0, 2, , 3]);
                        identification = jwt.verify(action.request.headers.authorization, connection_1.default.secret);
                        allowed_1 = false;
                        return [4 /*yield*/, this.collection.findOne(identification.toString(), { relations: ['profile'] })];
                    case 1:
                        operator = _a.sent();
                        allowances_1 = operator.profile;
                        roles.forEach(function (role) {
                            switch (role) {
                                case 'addCostumers':
                                    allowed_1 = allowances_1.canAddCostumers;
                                    break;
                                case 'getCostumers':
                                    allowed_1 = allowances_1.canGetCostumers;
                                    break;
                                case 'updateCostumers':
                                    allowed_1 = allowances_1.canUpdateCostumers;
                                    break;
                                case 'removeCostumers':
                                    allowed_1 = allowances_1.canRemoveCostumers;
                                    break;
                                case 'addOrders':
                                    allowed_1 = allowances_1.canAddOrders;
                                    break;
                                case 'getOrders':
                                    allowed_1 = allowances_1.canGetOrders;
                                    break;
                                case 'updateOrders':
                                    allowed_1 = allowances_1.canUpdateOrders;
                                    break;
                                case 'removeOrders':
                                    allowed_1 = allowances_1.canRemoveOrders;
                                    break;
                                case 'addProducts':
                                    allowed_1 = allowances_1.canAddProducts;
                                    break;
                                case 'getProducts':
                                    allowed_1 = allowances_1.canGetProducts;
                                    break;
                                case 'updateProducts':
                                    allowed_1 = allowances_1.canUpdateProducts;
                                    break;
                                case 'removeProducts':
                                    allowed_1 = allowances_1.canRemoveProducts;
                                    break;
                                case 'addStores':
                                    allowed_1 = allowances_1.canAddStores;
                                    break;
                                case 'getStores':
                                    allowed_1 = allowances_1.canGetStores;
                                    break;
                                case 'updateStores':
                                    allowed_1 = allowances_1.canUpdateStores;
                                    break;
                                case 'removeStores':
                                    allowed_1 = allowances_1.canRemoveStores;
                                    break;
                                default: return true;
                            }
                        });
                        return [2 /*return*/, true];
                    case 2:
                        error_8 = _a.sent();
                        return [2 /*return*/, true];
                    case 3: return [2 /*return*/];
                }
            });
        });
    };
    return OperatorService;
}());
exports.default = OperatorService;
//# sourceMappingURL=operator.service.js.map