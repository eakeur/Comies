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
var Address = /** @class */ (function () {
    function Address() {
    }
    __decorate([
        typeorm_1.PrimaryGeneratedColumn(),
        __metadata("design:type", Number)
    ], Address.prototype, "id", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "cep", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "number", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "district", void 0);
    __decorate([
        typeorm_1.Column(),
        __metadata("design:type", String)
    ], Address.prototype, "complement", void 0);
    __decorate([
        typeorm_1.Column(),
        __metadata("design:type", String)
    ], Address.prototype, "reference", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "street", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "city", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "state", void 0);
    __decorate([
        typeorm_1.Column({ nullable: false }),
        __metadata("design:type", String)
    ], Address.prototype, "country", void 0);
    __decorate([
        typeorm_1.ManyToOne(function () { return costumer_1.default; }, function (costumer) { return costumer.addresses; }, { eager: true }),
        __metadata("design:type", costumer_1.default)
    ], Address.prototype, "costumer", void 0);
    Address = __decorate([
        typeorm_1.Entity()
    ], Address);
    return Address;
}());
exports.default = Address;
//# sourceMappingURL=address.js.map