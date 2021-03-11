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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var typeorm_1 = require("typeorm");
var costumer_1 = __importDefault(require("./costumer"));
var store_1 = __importDefault(require("./store"));
var order_items_1 = __importDefault(require("./order-items"));
var enums_1 = require("./enums");
var operator_1 = __importDefault(require("./operator"));
var address_1 = __importDefault(require("./address"));
var Order = /** @class */ (function () {
    function Order() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Order.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column(),
        __metadata("design:type", Date)
    ], Order.prototype, "placed", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, default: enums_1.Status.pending }),
        __metadata("design:type", Number)
    ], Order.prototype, "status", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, default: enums_1.PaymentMethod.cash }),
        __metadata("design:type", Number)
    ], Order.prototype, "payment", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, default: enums_1.DeliverType.takeout }),
        __metadata("design:type", Number)
    ], Order.prototype, "deliverType", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return address_1.default; }, function (address) { return address.orders; }, { cascade: true, eager: true }),
        __metadata("design:type", address_1.default)
    ], Order.prototype, "address", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return store_1.default; }, function (store) { return store.orders; }),
        __metadata("design:type", store_1.default)
    ], Order.prototype, "store", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return costumer_1.default; }, function (costumer) { return costumer.orders; }, { eager: true }),
        __metadata("design:type", costumer_1.default)
    ], Order.prototype, "costumer", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return operator_1.default; }, function (operator) { return operator.orders; }, { eager: true }),
        __metadata("design:type", operator_1.default)
    ], Order.prototype, "operator", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return order_items_1.default; }, function (productItem) { return productItem.order; }, { cascade: true, eager: true }),
        __metadata("design:type", Array)
    ], Order.prototype, "products", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, type: "float" }),
        __metadata("design:type", Number)
    ], Order.prototype, "price", void 0);
    __decorate([
        typeorm_1.Column({ default: true }),
        __metadata("design:type", Boolean)
    ], Order.prototype, "active", void 0);
    Order = __decorate([
        typeorm_1.Entity()
    ], Order);
    return Order;
}());
exports.default = Order;
//# sourceMappingURL=order.js.map