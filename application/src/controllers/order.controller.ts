import { Controller, Param, Body, Get, Post, Put, Delete, State, UseBefore, UploadedFile, HeaderParams, Params, Req, QueryParams, Authorized, CurrentUser } from "routing-controllers";
import { json } from 'body-parser'
import OrderService from "../services/order.service";
import Order from "../structures/order";
import Operator from "../structures/operator";

@Controller("/orders")
export default class OrderController {

    @Authorized('getOrders')
    @Get("/:id")
    public async getOrderByID(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number){
        const service:OrderService = new OrderService(operator);
        return service.getOrderById(id);
    }

    @Authorized('getOrders')
    @Get("")
    public async getOrders(@CurrentUser({required:true}) operator: Operator, @QueryParams() params:Order){
        const service:OrderService = new OrderService(operator);
        return service.getOrders(params);
    }

    @Authorized('addOrders')
    @Post("")
    @UseBefore(json())
    public async addOrder(@CurrentUser({required:true}) operator: Operator, @Body() order:Order){
        const service:OrderService = new OrderService(operator);
        return service.addOrder(order);
    }

    @Authorized('updateOrders')
    @Put("")
    @UseBefore(json())
    public async updateOrder(@CurrentUser({required:true}) operator: Operator, @Body() order:Order){
        const service:OrderService = new OrderService(operator);
        return service.updateOrder(order);
    }

    @Authorized('removeOrders')
    @Delete("")
    @UseBefore(json())
    public async removeOrder(@CurrentUser({required:true}) operator: Operator, @Body() order:Order){
        const service:OrderService = new OrderService(operator);
        return service.removeOrder(order);
    }

    public static async sendToTheKitchen(order: Order){

    }

}