import Connection from "../utils/connection";
import Costumer from "../structures/costumer";
import { FindConditions, FindOperator, Like, Repository } from "typeorm";
import Operator from "../structures/operator";
import Response from "../structures/response";
import Notification from "../structures/notification";
import Phone from "../structures/phone";
import Address from "../structures/address";

export default class CostumerService {

    constructor(operator?: Operator){
        this.operator = operator;
    }

    response: Response = new Response();

    operator: Operator;

    conditions: FindConditions<Costumer> = {};

    collection:Repository<Costumer> = Connection.db.getRepository<Costumer>(Costumer);

    addressCollection: Repository<Address> = Connection.db.getRepository<Address>(Address);

    phoneCollection: Repository<Phone> = Connection.db.getRepository<Phone>(Phone);






    public async addCostumer(costumer:Costumer):Promise<Response>{
        try {
            await this.collection.save(costumer);
            this.response.notification = new Notification("Oba! Cliente adicionado com sucesso!");
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Um erro ocorreu ao adicionar esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async removeCostumer(costumerID: number):Promise<Response>{
        try {
            const costumer = (await this.getCostumerById(costumerID)).data as Costumer;
            await this.phoneCollection.remove(costumer.phones);
            await this.addressCollection.remove(costumer.addresses);
            await this.collection.remove(costumer);
            this.response.notification = new Notification("Cliente excluído com sucesso!");
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Um erro ocorreu ao excluir esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async updateCostumer(costumer:Costumer):Promise<Response>{
        try {
            await this.collection.save(costumer);
            this.response.notification = new Notification("Oba! O cliente foi atualizado com sucesso!");
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Opa! Um erro ocorreu ao atualizar esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async getCostumerById(id:number):Promise<Response>{
        try {
            this.response.data = await this.collection.findOne(id, { relations: ['addresses', 'phones'] });
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por este cliente. Por favor, tente mais tarde ou fale com um administrador.")
        }
        return this.response;
    }

    public async getCostumers(costumer?:Costumer):Promise<Response>{
        try {
            this.conditions.active = true;
            if (costumer.name) this.conditions.name = Like(`%${costumer.name}%`);
            this.response.data = await this.collection.find(this.conditions);
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por clientes. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }

    public async getCostumersByPhone(phone: string):Promise<Response>{
        try {
            const cond: FindConditions<Costumer> = {};
            const phones = await this.phoneCollection.find({relations: ["costumer"], where:{ number:Like(`%${phone}%`)}});
            this.response.data = phones.map(phone => phone.costumer);
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por clientes. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }
}