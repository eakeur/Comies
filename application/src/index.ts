import Connection from  './utils/connection'
import "reflect-metadata";
import express from 'express';
import {Action, createExpressServer, useExpressServer} from 'routing-controllers';
import CostumerController from './controllers/costumer.controller';
import ProductController from './controllers/product.controller';
import OperatorService from './services/operator.service';
import OrderController from './controllers/order.controller';
import OperatorController from './controllers/operator.controller';
import https from 'https';
import fs from 'fs';
import servefiles from "serve-static";
import path from 'path';

class ServerInitializer {

    public static start(){
        const init = new ServerInitializer();
    }

    constructor(){
        this.getDatabaseConnection()
            .then(() => this.initializeServer()
        );
    }

    public async getDatabaseConnection(){
        await Connection.connect();
        await Connection.initializeDatabase();
    }

    public async initializeServer(){
        const port = process.env.port || 8080;
        useExpressServer(express().use("/", servefiles("public")), {
            cors: true,
            currentUserChecker: (action: Action) => new OperatorService().getOperatorByToken(action),
            classTransformer:true,
            authorizationChecker:  (action: Action, roles: any[]) => new OperatorService().authorizeOperator(action, roles),
            controllers: [CostumerController, ProductController, OrderController, OperatorController]
        }).listen(port);
        console.log(`Comies server started on port ${port}`);
    }
}

ServerInitializer.start();
