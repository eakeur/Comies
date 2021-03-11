import Order from "../structures/order";
import {IncomingMessage, Server} from 'http';
import * as WebSocket from 'ws';

export class KitchenController {

    private static socket: WebSocket.Server;
    private static rooms: Map<number, Map<number, Set<WebSocket>>> = new Map<number, Map<number, Set<WebSocket>>>();

    public static openKitchen(socket: WebSocket.Server) : void {
        KitchenController.socket = socket;
    }

    public static addClient(client: WebSocket, partnerID: number, storeID: number){
        if (KitchenController.rooms.has(partnerID)){
            if(KitchenController.rooms.get(partnerID).has(storeID)) KitchenController.rooms.get(partnerID).get(storeID).add(client);
            else {
                const socketSet = new Set<WebSocket>();socketSet.add(client);
                KitchenController.rooms.get(partnerID);
            }
        } else {
            const orderMap = new Map<number, Set<WebSocket>>();
            const socketSet = new Set<WebSocket>();socketSet.add(client);
            orderMap.set(storeID, socketSet);
            KitchenController.rooms.set(partnerID, orderMap);
        }
    }

    public static removeClient(client: WebSocket, partnerID: number, storeID: number){
        KitchenController.rooms.get(partnerID).get(storeID).delete(client);
    }

    public static sendOrderToKitchen(order: Order): void{
        if (KitchenController.rooms.has(order.store.partner.id)){
            if(KitchenController.rooms.get(order.store.partner.id).has(order.store.id)){
                KitchenController.rooms.get(order.store.partner.id).get(order.store.id).forEach(client => {
                    client.send(JSON.stringify(order));
                });
            }
        }
    }

    public static receiveSocket(message: any, route: string[]){
        try {
            KitchenController.rooms.get(Number.parseInt(route[0], 10)).get(Number.parseInt(route[1], 10))
            .forEach(cli => cli.send("Someone put something on the oven: "+message));
        } catch (error) {

        }
    }
}