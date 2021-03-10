import { Controller, Param, Body, Get, Post, Put, Delete, State, UseBefore, UploadedFile, Authorized, CurrentUser, QueryParams, QueryParam } from "routing-controllers";
import { json } from 'body-parser'
import Costumer from '../structures/costumer';
import CostumerService from '../services/costumer.service';
import Operator from "../structures/operator";
import Phone from "../structures/phone";
import Address from "../structures/address";

@Controller("/costumers")

export default class CostumerController {


    @Authorized('getCostumers')
    @Get("/:id")
    public async getCostumerById(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number){
        const service:CostumerService = new CostumerService(operator);
        return service.getCostumerById(id);
    }

    @Authorized('addCostumers')
    @Post("")
    @UseBefore(json())
    public async addCostumer(@CurrentUser({required:true}) operator: Operator, @Body() costumer: Costumer){
        const service:CostumerService = new CostumerService(operator);
        return service.addCostumer(costumer);
    }

    @Authorized('updateCostumers')
    @Put("")
    @UseBefore(json())
    public async updateCostumer(@CurrentUser({required:true}) operator: Operator, @Body() costumer: Costumer){
        const service:CostumerService = new CostumerService(operator);
        return service.updateCostumer(costumer);
    }


    @Delete("/:id")
    @UseBefore(json())
    public async removeCostumer(@Param("id") id:number){
        const service:CostumerService = new CostumerService();
        return service.removeCostumer(id);
    }

    @Authorized('getCostumers')
    @Get("")
    public async getCostumers(@CurrentUser({required:true}) operator: Operator, @QueryParams() params:any){
        const service:CostumerService = new CostumerService(operator);
        const costumerQuery = params as Costumer;
        const phoneQuery = params as Phone;
        if (phoneQuery.number) return service.getCostumersByPhone(phoneQuery.number);
        return service.getCostumers(costumerQuery);
    }

}