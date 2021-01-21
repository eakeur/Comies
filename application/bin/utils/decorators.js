"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = require("express");
function Route(base, route, method, name) {
    var router = express_1.Router();
    return function (target, propertyKey) {
        switch (method) {
            case "GET":
                router.get(base + route, target[name]);
                break;
            case "POST":
                router.post(base + route, target[name]);
                break;
            case "PUT":
                router.put(base + route, target[name]);
                break;
            case "DELETE":
                router.delete(base + route, target[name]);
                break;
            default: break;
        }
    };
}
exports.Route = Route;
//# sourceMappingURL=decorators.js.map