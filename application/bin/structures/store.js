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
var operator_1 = __importDefault(require("./operator"));
var order_1 = __importDefault(require("./order"));
var partner_1 = __importDefault(require("./partner"));
var Store = /** @class */ (function () {
    function Store() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Store.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Store.prototype, "name", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return partner_1.default; }, function (partner) { return partner.stores; }, { eager: true }),
        __metadata("design:type", partner_1.default)
    ], Store.prototype, "partner", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return order_1.default; }, function (order) { return order.store; }),
        __metadata("design:type", Array)
    ], Store.prototype, "orders", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return operator_1.default; }, function (operator) { return operator.store; }),
        __metadata("design:type", Array)
    ], Store.prototype, "operators", void 0);
    Store = __decorate([
        typeorm_1.Entity()
    ], Store);
    return Store;
}());
exports.default = Store;
//# sourceMappingURL=store.js.map