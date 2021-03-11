import Order from "../structures/order";
import {Server} from 'http';
import * as WebSocket from 'ws';

export class DeliveryController {

    private static socket: WebSocket.Server;

    public static openKitchen(io: Server) : void {
        DeliveryController.socket = new WebSocket.Server({ noServer: true })
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