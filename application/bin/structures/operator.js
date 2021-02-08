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
var partner_1 = __importDefault(require("./partner"));
var profile_1 = require("./profile");
var store_1 = __importDefault(require("./store"));
var Operator = /** @class */ (function () {
    function Operator() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Operator.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Operator.prototype, "name", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Operator.prototype, "identification", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Operator.prototype, "password", void 0);
    __decorate([
        typeorm_1.Column(),
        __metadata("design:type", Date)
    ], Operator.prototype, "lastLogin", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return profile_1.Profile; }, function (profile) { return profile.operators; }, { eager: true }),
        __metadata("design:type", profile_1.Profile)
    ], Operator.prototype, "profile", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return store_1.default; }, function (store) { return store.operators; }, { eager: true }),
        __metadata("design:type", store_1.default)
    ], Operator.prototype, "store", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return partner_1.default; }, function (partner) { return partner.operators; }, { eager: true }),
        __metadata("design:type", partner_1.default)
    ], Operator.prototype, "partner", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return order_1.default; }, function (order) { return order.operator; }),
        __metadata("design:type", Array)
    ], Operator.prototype, "orders", void 0);
    __decorate([
        typeorm_1.Column({ default: true }),
        __metadata("design:type", Boolean)
    ], Operator.prototype, "active", void 0);
    Operator = __decorate([
        typeorm_1.Entity()
    ], Operator);
    return Operator;
}());
exports.default = Operator;
//# sourceMappingURL=operator.js.map