import Connection from  './utils/connection'
import "reflect-metadata";
import express from 'express';
import {Action, createExpressServer, useExpressServer} from 'routing-controllers';
import CostumerController from './controllers/costumer.controller';
import ProductController from './controllers/product.controller';
import OrderController from './controllers/order.controller';
import OperatorController from './controllers/operator.controller';
import servefiles from "serve-static";
import * as WebSocket from 'ws';
import AuthenticationController from './controllers/authentication.controller';
import { KitchenController } from './controllers/kitchen.controller';
import { DeliveryController } from './controllers/delivery.controller';
import { IncomingMessage, Server } from 'http';
import { ScreenController } from './controllers/screen.controller';

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
        const port = process.env.PORT || 8080;
        const server = useExpressServer(express().use("/", servefiles("public")), {
            cors: true,
            currentUserChecker: (action: Action) => new AuthenticationController().getOperatorByToken(action),
            classTransformer:true,
            authorizationChecker:  (action: Action, roles: any[]) => new AuthenticationController().authorizeOperator(action, roles),
            controllers: [CostumerController, ProductController, OrderController, OperatorController, AuthenticationController]
        }).listen(port);
        await this.openRooms(server);

        console.log(`Comies server started on port ${port}`);
    }

    public async openRooms(server: Server){
        const socket: WebSocket.Server = new WebSocket.Server({ server });
        KitchenController.openKitchen(socket);
        socket.on("connection", async (srv: WebSocket, req: IncomingMessage) => {
            try {
                const routes = req.url.split('/');
                const operator = await new AuthenticationController().getOperatorBySocketToken(req.headers.authorization);
                if (operator){
                    console.log('Operator '+operator.id+' from store '+operator.store.id+' connected to the socket with address :' + req.socket.remoteAddress);
                    const partnerID = Number.parseInt(routes[2], 10);
                    const storeID = Number.parseInt(routes[3], 10);
                    if ( partnerID === operator.partner.id && storeID === operator.store.id){
                        switch (routes[1]) {
                            case "": srv.close(); break;
                            case "kitchen": KitchenController.addClient(srv, partnerID, storeID, operator); break;
                            case "screen": ScreenController.addClient(srv, partnerID, storeID, operator, routes[4] === "TV"); break;
                            default: srv.close(); break;
                        }
                        srv.on("message", (message: any) => {
                            switch (routes[1]) {
                                case "": srv.close(); break;
                                case "kitchen": KitchenController.receiveSocket(message, routes.slice(2)); break;
                                case "screen": ScreenController.receiveSocket(message, routes.slice(2)); break;
                                default: srv.close(); break;
                            }
                        });
                        srv.on("close", (message: any) => {
                            switch (routes[1]) {
                                case "": break;
                                case "kitchen": KitchenController.removeClient(srv, partnerID, storeID); break;
                                default: break;
                            }
                        });
                    } else srv.close();
                } else srv.close();
            } catch (error) {
                srv.close();
            }
        })
    }
}
ServerInitializer.start();
