import { Controller, Param, Body, Get, Post, Put, Delete, State, UseBefore, UploadedFile, Authorized, CurrentUser, QueryParams } from "routing-controllers";
import { json } from 'body-parser'
import Operator from "../structures/operator";
import OperatorService from "../services/operator.service";

@Controller("/operators")

export default class OperatorController {


    @Authorized('getOperators')
    @Get("/:id")
    public async getOperatorByID(@Param("id") id:number){
        const service:OperatorService = new OperatorService();
        return service.getOperatorById(id);
    }

    @Authorized('getOperators')
    @Get("")
    public async getOperators(@CurrentUser({required:true}) operator: Operator, @QueryParams() params: Operator){
        const service:OperatorService = new OperatorService(operator);
        return service.getOperators(params);
    }

    @Authorized('addOperators')
    @Post("")
    @UseBefore(json())
    public async addOperator(@CurrentUser({required:true}) operator: Operator, @Body() operatorT: Operator){
        const service:OperatorService = new OperatorService(operator);
        return service.addOperator(operatorT);
    }

    @Authorized('updateOperators')
    @Put("")
    @UseBefore(json())
    public async updateOperator(@CurrentUser({required:true}) operator: Operator, @Body() operatorT: Operator){
        const service:OperatorService = new OperatorService(operator);
        return service.updateOperator(operatorT);
    }

    @Authorized('removeOperators')
    @Delete("")
    @UseBefore(json())
    public async removeOperator(@CurrentUser({required:true}) operator: Operator, @Body() operatorT: Operator){
        const service:OperatorService = new OperatorService(operator);
        return service.removeOperator(operatorT);
    }

}