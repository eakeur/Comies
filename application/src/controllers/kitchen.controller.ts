import Order from "../structures/order";
import {Server} from 'http';
import * as WebSocket from 'ws';
import CostumerService from "../services/costumer.service";
import Costumer from "../structures/costumer";

export class KitchenController {

    private static socket: WebSocket.Server;

    public static openKitchen(io: Server) : void {
        KitchenController.socket = new WebSocket.Server({server: io, path: "kitchen"})
        .on("connection", (srv: WebSocket) => {
            console.log('Someone got into the kitchen');
            srv.on("message", (message: string) =>
            KitchenController.socket.clients.forEach(client => client.send("Kitchen message")));
        })
    }

    public static sendOrderToKitchen(order: Order): void{
        KitchenController.socket.clients.forEach(client =>
            client.send(JSON.stringify(order)));
    }
}

export class DeliveryController {

    private static socket: WebSocket.Server;

    public static openKitchen(io: Server) : void {
        DeliveryController.socket = new WebSocket.Server({server: io, path: "location"})
        .on("connection", (srv: WebSocket) => {
            console.log('Someone started driving');
            srv.on("message", (message: string) =>
            DeliveryController.socket.clients.forEach(client => client.send("New location")));
        })
    }

    public static sendOrderToKitchen(order: Order): void{
        DeliveryController.socket.clients.forEach(client =>
            client.send(JSON.stringify(order)));
    }
}