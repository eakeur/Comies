import Order from "../structures/order";
import {IncomingMessage, Server} from 'http';
import * as WebSocket from 'ws';
import Operator from "../structures/operator";
import OrderService from "../services/order.service";
import { Status } from "../structures/enums";

export class ScreenController {

    private static socket: WebSocket.Server;
    private static screens: Map<number, Map<number, Map<string, WebSocket>>> = new Map<number, Map<number, Map<string, WebSocket>>>();
    private static controllers: Map<number, Map<number, Set<WebSocket>>> = new Map<number, Map<number, Set<WebSocket>>>();

    public static openKitchen(socket: WebSocket.Server) : void {
        ScreenController.socket = socket;
    }

    public static async addClient(client: WebSocket, partnerID: number, storeID: number, operator: Operator, isScreen: boolean){
        if (isScreen){
            const letterIN = String.fromCharCode(65 + Math.floor(Math.random() * 26));
            const letterFI = String.fromCharCode(65 + Math.floor(Math.random() * 26));
            const reqTime = new Date(Date.now());
            const code = letterIN + partnerID + reqTime.getMinutes() + letterFI + storeID;
            if (ScreenController.screens.has(partnerID)){
                if(ScreenController.screens.get(partnerID).has(storeID)) ScreenController.screens.get(partnerID).get(storeID).set(code, client);
                else {
                    const map = new Map<string, WebSocket>(); map.set(code, client);
                    ScreenController.screens.get(partnerID).set(storeID, map);
                }
            } else {
                const orderMap = new Map<string, WebSocket>();
                const storemap = new Map<number, Map<string, WebSocket>>();
                orderMap.set(code, client);
                storemap.set(storeID, orderMap);
                ScreenController.screens.set(partnerID, storemap);
            }
            client.send(code);
        }
    }

    public static receiveSocket(message: any, route: string[]){
        try {
            ScreenController.screens.get(Number.parseInt(route[0], 10)).get(Number.parseInt(route[1], 10)).get(route[2])
            .send(message);
        } catch (error) {

        }
    }
}