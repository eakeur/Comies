import { Controller, Param, Body, Get, Post, Put, Delete, State, UseBefore, UploadedFile, Authorized, CurrentUser, QueryParams, QueryParam } from "routing-controllers";
import { json } from 'body-parser'
import Costumer from '../structures/costumer';
import CostumerService from '../services/costumer.service';
import Operator from "../structures/operator";

@Controller("/costumers")

export default class CostumerController {


    @Authorized('getCostumers')
    @Get("/:id")
    public async getCostumerById(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number){
        const service:CostumerService = new CostumerService(operator);
        return service.getCostumerById(id);
    }

    @Authorized('getCostumers')
    @Get("/extraget/keys")
    public async getCostumersByPhone(@CurrentUser({required:true}) operator: Operator, @QueryParam("phone") phone: string){
        const service:CostumerService = new CostumerService(operator);
        return service.getCostumersByPhone(phone);
    }

    @Authorized('getCostumers')
    @Get("")
    public async getCostumers(@CurrentUser({required:true}) operator: Operator, @QueryParams() params: Costumer){
        const service:CostumerService = new CostumerService(operator);
        return service.getCostumers(params);
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

    @Authorized('removeCostumers')
    @Delete("/:id")
    @UseBefore(json())
    public async removeCostumer(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number){
        const service:CostumerService = new CostumerService(operator);
        return service.removeCostumer(id);
    }

    @Authorized('removePhones')
    @Delete("/phones/:id")
    @UseBefore(json())
    public async removePhone(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number){
        const service:CostumerService = new CostumerService(operator);
        return service.removePhone(id);
    }

    @Authorized('removeAddresses')
    @Delete("/addresses/:id")
    @UseBefore(json())
    public async removeAddress(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number){
        const service:CostumerService = new CostumerService(operator);
        return service.removeAddress(id);
    }

}