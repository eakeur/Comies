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
var enums_1 = require("./enums");
var order_1 = __importDefault(require("./order"));
var partner_1 = __importDefault(require("./partner"));
var Product = /** @class */ (function () {
    function Product() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Product.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Product.prototype, "name", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Product.prototype, "code", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, default: 1 }),
        __metadata("design:type", Number)
    ], Product.prototype, "min", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", Number)
    ], Product.prototype, "unity", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false, type: "float" }),
        __metadata("design:type", Number)
    ], Product.prototype, "price", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return partner_1.default; }, function (partner) { return partner.products; }),
        __metadata("design:type", partner_1.default)
    ], Product.prototype, "partner", void 0);
    __decorate([
        typeorm_1.ManyToMany(function () { return order_1.default; }, function (order) { return order.products; }),
        __metadata("design:type", Array)
    ], Product.prototype, "orders", void 0);
    __decorate([
        typeorm_1.Column({ default: true }),
        __metadata("design:type", Boolean)
    ], Product.prototype, "active", void 0);
    Product = __decorate([
        typeorm_1.Entity()
    ], Product);
    return Product;
}());
exports.default = Product;
//# sourceMappingURL=product.js.map