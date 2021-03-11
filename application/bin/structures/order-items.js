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
var order_1 = __importDefault(require("./order"));
var product_1 = __importDefault(require("./product"));
var ProductItem = /** @class */ (function () {
    function ProductItem() {
    }
    ProductItem_1 = ProductItem;
    var ProductItem_1;
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], ProductItem.prototype, "id", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return order_1.default; }, function (order) { return order.products; }),
        __metadata("design:type", order_1.default)
    ], ProductItem.prototype, "order", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", Number)
    ], ProductItem.prototype, "group", void 0);
    __decorate([
        typeorm_1.ManyToMany(function () { return ProductItem_1; }, function (productItem) { return productItem.order; }),
        __metadata("design:type", product_1.default)
    ], ProductItem.prototype, "product", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, type: "float" }),
        __metadata("design:type", Number)
    ], ProductItem.prototype, "quantity", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, type: "float" }),
        __metadata("design:type", Number)
    ], ProductItem.prototype, "discount", void 0);
    ProductItem = ProductItem_1 = __decorate([
        typeorm_1.Entity()
    ], ProductItem);
    return ProductItem;
}());
exports.default = ProductItem;
//# sourceMappingURL=order-items.js.map