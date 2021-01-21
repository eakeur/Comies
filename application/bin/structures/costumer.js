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
var address_1 = __importDefault(require("./address"));
var phone_1 = __importDefault(require("./phone"));
var order_1 = __importDefault(require("./order"));
var Costumer = /** @class */ (function () {
    function Costumer() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Costumer.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column(),
        __metadata("design:type", String)
    ], Costumer.prototype, "firstName", void 0);
    __decorate([
        typeorm_1.Column(),
        __metadata("design:type", String)
    ], Costumer.prototype, "lastName", void 0);
    __decorate([
        typeorm_1.Column({ nullable: true }),
        __metadata("design:type", String)
    ], Costumer.prototype, "token", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return phone_1.default; }, function (phone) { return phone.costumer; }),
        __metadata("design:type", Array)
    ], Costumer.prototype, "phones", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return address_1.default; }, function (address) { return address.costumer; }),
        __metadata("design:type", Array)
    ], Costumer.prototype, "addresses", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return order_1.default; }, function (order) { return order.costumer; }),
        __metadata("design:type", Array)
    ], Costumer.prototype, "orders", void 0);
    __decorate([
        typeorm_1.Column({ default: true }),
        __metadata("design:type", Boolean)
    ], Costumer.prototype, "active", void 0);
    Costumer = __decorate([
        typeorm_1.Entity()
    ], Costumer);
    return Costumer;
}());
exports.default = Costumer;
//# sourceMappingURL=costumer.js.map