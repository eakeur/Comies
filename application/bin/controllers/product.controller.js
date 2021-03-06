"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
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
var routing_controllers_1 = require("routing-controllers");
var body_parser_1 = require("body-parser");
var product_service_1 = __importDefault(require("../services/product.service"));
var product_1 = __importDefault(require("../structures/product"));
var operator_1 = __importDefault(require("../structures/operator"));
var ProductController = /** @class */ (function () {
    function ProductController() {
    }
    ProductController.prototype.getProductByID = function (id) {
        return __awaiter(this, void 0, void 0, function () {
            var service;
            return __generator(this, function (_a) {
                service = new product_service_1.default();
                return [2 /*return*/, service.getProductById(id)];
            });
        });
    };
    ProductController.prototype.getProducts = function (params) {
        return __awaiter(this, void 0, void 0, function () {
            var service;
            return __generator(this, function (_a) {
                service = new product_service_1.default();
                return [2 /*return*/, service.getProducts(params)];
            });
        });
    };
    ProductController.prototype.addProduct = function (operator, product) {
        return __awaiter(this, void 0, void 0, function () {
            var service;
            return __generator(this, function (_a) {
                service = new product_service_1.default(operator);
                return [2 /*return*/, service.addProduct(product)];
            });
        });
    };
    ProductController.prototype.updateProduct = function (operator, product) {
        return __awaiter(this, void 0, void 0, function () {
            var service;
            return __generator(this, function (_a) {
                service = new product_service_1.default(operator);
                return [2 /*return*/, service.updateProduct(product)];
            });
        });
    };
    ProductController.prototype.removeProduct = function (operator, id) {
        return __awaiter(this, void 0, void 0, function () {
            var service;
            return __generator(this, function (_a) {
                service = new product_service_1.default(operator);
                return [2 /*return*/, service.removeProduct(id)];
            });
        });
    };
    ProductController.prototype.removeProducts = function (operator, productsIDs) {
        return __awaiter(this, void 0, void 0, function () {
            var service;
            return __generator(this, function (_a) {
                service = new product_service_1.default(operator);
                return [2 /*return*/];
            });
        });
    };
    __decorate([
        routing_controllers_1.Authorized('getProducts'),
        routing_controllers_1.Get("/:id"),
        __param(0, routing_controllers_1.Param("id")),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [Number]),
        __metadata("design:returntype", Promise)
    ], ProductController.prototype, "getProductByID", null);
    __decorate([
        routing_controllers_1.Authorized('getProducts'),
        routing_controllers_1.Get(""),
        __param(0, routing_controllers_1.QueryParams()),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [product_1.default]),
        __metadata("design:returntype", Promise)
    ], ProductController.prototype, "getProducts", null);
    __decorate([
        routing_controllers_1.Authorized('addProducts'),
        routing_controllers_1.Post(""),
        routing_controllers_1.UseBefore(body_parser_1.json()),
        __param(0, routing_controllers_1.CurrentUser({ required: true })), __param(1, routing_controllers_1.Body()),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [operator_1.default, product_1.default]),
        __metadata("design:returntype", Promise)
    ], ProductController.prototype, "addProduct", null);
    __decorate([
        routing_controllers_1.Authorized('updateProducts'),
        routing_controllers_1.Put(""),
        routing_controllers_1.UseBefore(body_parser_1.json()),
        __param(0, routing_controllers_1.CurrentUser({ required: true })), __param(1, routing_controllers_1.Body()),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [operator_1.default, product_1.default]),
        __metadata("design:returntype", Promise)
    ], ProductController.prototype, "updateProduct", null);
    __decorate([
        routing_controllers_1.Authorized('removeProducts'),
        routing_controllers_1.Delete("/:id"),
        routing_controllers_1.UseBefore(body_parser_1.json()),
        __param(0, routing_controllers_1.CurrentUser({ required: true })), __param(1, routing_controllers_1.Param("id")),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [operator_1.default, Number]),
        __metadata("design:returntype", Promise)
    ], ProductController.prototype, "removeProduct", null);
    __decorate([
        routing_controllers_1.Authorized('removeProducts'),
        routing_controllers_1.Post("/delete"),
        routing_controllers_1.UseBefore(body_parser_1.json()),
        __param(0, routing_controllers_1.CurrentUser({ required: true })), __param(1, routing_controllers_1.Body()),
        __metadata("design:type", Function),
        __metadata("design:paramtypes", [operator_1.default, Array]),
        __metadata("design:returntype", Promise)
    ], ProductController.prototype, "removeProducts", null);
    ProductController = __decorate([
        routing_controllers_1.Controller("/products"),
        routing_controllers_1.Authorized()
    ], ProductController);
    return ProductController;
}());
exports.default = ProductController;
//# sourceMappingURL=product.controller.js.map