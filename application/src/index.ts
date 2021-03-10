import Connection from  './utils/connection'
import "reflect-metadata";
import express from 'express';
import {Action, createExpressServer, useExpressServer} from 'routing-controllers';
import CostumerController from './controllers/costumer.controller';
import ProductController from './controllers/product.controller';
import OrderController from './controllers/order.controller';
import OperatorController from './controllers/operator.controller';
import servefiles from "serve-static";
import AuthenticationController from './controllers/authentication.controller';

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
            currentUserChecker: (action: Action) => new AuthenticationController().getOperatorByToken(action),
            classTransformer:true,
            authorizationChecker:  (action: Action, roles: any[]) => new AuthenticationController().authorizeOperator(action, roles),
            controllers: [CostumerController, ProductController, OrderController, OperatorController, AuthenticationController]
        }).listen(port);
        console.log(`Comies server started on port ${port}`);
    }
}

ServerInitializer.start();
