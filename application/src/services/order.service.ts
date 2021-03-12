import Connection from "../utils/connection";
import { Repository } from "typeorm";
import Response from "../structures/response";
import Order from "../structures/order";
import Notification from "../structures/notification";
import Operator from "../structures/operator";

export default class OrderService {

    constructor(operator?: Operator){
        this.operator = operator;
    }

    operator: Operator;

    response: Response = new Response();

    collection:Repository<Order> = Connection.db.getRepository<Order>(Order);

    public async addOrder(order:Order):Promise<Response>{
        try {
            order.operator = this.operator;
            order.store = this.operator.store;
            await this.collection.save(order);
            this.response.notification = new Notification("Pedido adicionado com sucesso!");
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notification = new Notification("Um erro ocorreu ao adicionar esse pedido. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async removeOrder(order:Order):Promise<Response>{
        try {
            await this.collection.remove(order);
            this.response.notification = new Notification("Pedido excluído com sucesso!");
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao excluir este pedido. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response
    }

    public async updateOrder(order:Order):Promise<Response>{
        try {
            await this.collection.save(order);
            this.response.notification = new Notification("Pedido atualizado com sucesso!");
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao atualizar este pedido. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }

    public async getOrderById(id:number):Promise<Response>{
        try {
            const order = await this.collection.findOne(id);
            this.response.data = order;
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por este pedido. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }

    public async getOrders(filters:Order):Promise<Response>{
        try {
            this.response.data = await this.collection.find();
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por pedidos. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }
}