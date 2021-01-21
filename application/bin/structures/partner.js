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
var partner_configurations_1 = __importDefault(require("./partner-configurations"));
var product_1 = __importDefault(require("./product"));
var profile_1 = require("./profile");
var store_1 = __importDefault(require("./store"));
var Partner = /** @class */ (function () {
    function Partner() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Partner.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Partner.prototype, "name", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return store_1.default; }, function (store) { return store.partner; }),
        __metadata("design:type", Array)
    ], Partner.prototype, "stores", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return product_1.default; }, function (product) { return product.partner; }),
        __metadata("design:type", Array)
    ], Partner.prototype, "products", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return profile_1.Profile; }, function (profile) { return profile.partner; }),
        __metadata("design:type", Array)
    ], Partner.prototype, "profiles", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return partner_configurations_1.default; }, function (partnerConfiguration) { return partnerConfiguration.partner; }, { eager: true, cascade: true }),
        typeorm_1.JoinTable(),
        __metadata("design:type", Array)
    ], Partner.prototype, "configurations", void 0);
    __decorate([
        typeorm_1.OneToMany(function () { return operator_1.default; }, function (operator) { return operator.store; }),
        __metadata("design:type", Array)
    ], Partner.prototype, "operators", void 0);
    __decorate([
        typeorm_1.Column({ default: true }),
        __metadata("design:type", Boolean)
    ], Partner.prototype, "active", void 0);
    Partner = __decorate([
        typeorm_1.Entity()
    ], Partner);
    return Partner;
}());
exports.default = Partner;
//# sourceMappingURL=partner.js.map