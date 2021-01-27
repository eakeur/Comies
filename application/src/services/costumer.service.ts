import Connection from "../utils/connection";
import Costumer from "../structures/costumer";
import { Repository } from "typeorm";
import Operator from "../structures/operator";
import Response from "../structures/response";
import Notification from "../structures/notification";

export default class CostumerService {

    constructor(operator?: Operator){
        this.operator = operator;
    }

    response: Response = new Response();

    operator: Operator;

    collection:Repository<Costumer> = Connection.db.getRepository<Costumer>(Costumer);

    public async addCostumer(costumer:Costumer):Promise<Response>{
        try {
            await this.collection.insert(costumer);
            this.response.notifications.push(new Notification("Cliente adicionado com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao adicionar esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async removeCostumer(costumerID: number):Promise<Response>{
        try {
            await this.collection.delete(costumerID);
            this.response.notifications.push(new Notification("Cliente excluído com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao excluir esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async updateCostumer(costumer:Costumer):Promise<Response>{
        try {
            await this.collection.update(costumer.id, costumer);
            this.response.notifications.push(new Notification("Cliente atualizado com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao atualizar esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async getCostumerById(id:number):Promise<Response>{
        try {
            this.response.data = await this.collection.findOne(id);
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Ocorreu um erro ao procurar por este cliente. Por favor, tente mais tarde ou fale com um administrador."))
        }
        return this.response;
    }

    public async getCostumers(costumer?:Costumer):Promise<Response>{
        try {
            this.response.data = await this.collection.find(costumer);
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Ocorreu um erro ao procurar por clientes. Por favor, tente mais tarde ou fale com um administrador."))
        }
        return this.response;
    }
}