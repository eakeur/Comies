import { Server as HttpServer } from "http";
import {Server } from "socket.io";
import Order from "../structures/order";

export class KitchenController {

    private static socket: Server;

    public static openKitchen(io: HttpServer) : void {
        KitchenController.socket = new Server(io);
        KitchenController.socket.on('connection', (socket: any) => {
            console.log('a user connected');

            socket.on('chat message', (msg) => {
                console.log('message: ' + msg);
            });

            socket.on('disconnect', () => {
                console.log('user disconnected');
            });
        });
    }

    public static sendOrderToKitchen(order: Order): void{
        KitchenController.socket.emit('newOrder');
    }

    private constructor(server: HttpServer){

    }
}