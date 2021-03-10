import { Controller, Param, Body, Get, Post, Put, Delete, State, UseBefore, UploadedFile, HeaderParams, Params, Req, QueryParams, Authorized, CurrentUser } from "routing-controllers";
import { json } from 'body-parser'
import ProductService from '../services/product.service';
import Product from "../structures/product";
import Operator from "../structures/operator";
import { KitchenController } from "./kitchen.controller";

@Controller("/products")
@Authorized()
export default class ProductController {



    @Authorized('getProducts')
    @Get("/:id")
    public async getProductByID(@Param("id") id:number ){
        const service:ProductService = new ProductService();
        return service.getProductById(id);
    }

    @Authorized('getProducts')
    @Get("")
    public async getProducts(@QueryParams() params:Product){
        const service:ProductService = new ProductService();
        return service.getProducts(params);
    }

    @Authorized('addProducts')
    @Post("")
    @UseBefore(json())
    public async addProduct(@CurrentUser({required:true}) operator: Operator, @Body() product:Product){
        const service:ProductService = new ProductService(operator);
        return service.addProduct(product);
    }

    @Authorized('updateProducts')
    @Put("")
    @UseBefore(json())
    public async updateProduct(@CurrentUser({required:true}) operator: Operator, @Body() product:Product){
        const service:ProductService = new ProductService(operator);
        return service.updateProduct(product);
    }

    @Authorized('removeProducts')
    @Delete("/:id")
    @UseBefore(json())
    public async removeProduct(@CurrentUser({required:true}) operator: Operator, @Param("id") id:number ){
        const service:ProductService = new ProductService(operator);
        return service.removeProduct(id);
    }

    @Authorized('removeProducts')
    @Post("/delete")
    @UseBefore(json())
    public async removeProducts(@CurrentUser({required:true}) operator: Operator, @Body() productsIDs: number[]){
        const service:ProductService = new ProductService(operator);
        return
    }

}