import Connection from "../utils/connection";
import Costumer from "../structures/costumer";
import { Repository } from "typeorm";
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

    collection:Repository<Costumer> = Connection.db.getRepository<Costumer>(Costumer);

    public async addCostumer(costumer:Costumer):Promise<Response>{
        try {
            await this.collection.insert(costumer);
            if (costumer.phones !== null && costumer.phones !== undefined){
                costumer.phones.forEach((phone, index) => costumer.phones[index].costumer = costumer);
                costumer.phones.forEach((phone) => Connection.db.getRepository<Phone>(Phone).insert(phone));
            }
            if (costumer.addresses !== null && costumer.addresses !== undefined){
                costumer.addresses.forEach((addr, index) => costumer.addresses[index].costumer = costumer);
                costumer.addresses.forEach((addr) => Connection.db.getRepository<Address>(Address).insert(addr));
            }

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
            const newAddresses = costumer.addresses.filter( addr => addr.id === null && addr.id !== undefined);
            const newPhones = costumer.phones.filter( phone => phone.id === null && phone.id !== undefined);
            delete costumer.addresses;
            delete costumer.phones;
            await this.collection.update(costumer.id, costumer);
            if (newPhones !== null && newPhones !== undefined){
                newPhones.forEach((phone, index) => newPhones[index].costumer = costumer);
                newPhones.forEach((phone) => Connection.db.getRepository<Phone>(Phone).insert(phone));
            }
            if (newAddresses !== null && newAddresses !== undefined){
                newAddresses.forEach((addr, index) => newAddresses[index].costumer = costumer);
                newAddresses.forEach((addr) => Connection.db.getRepository<Address>(Address).insert(addr));
            }

            this.response.notifications.push(new Notification("Cliente atualizado com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao atualizar esse cliente. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async removePhone(id:number):Promise<Response>{
        try {
            await Connection.db.getRepository<Phone>(Phone).delete(id);
            this.response.notifications.push(new Notification("Telefone excluído com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao excluir esse telefone. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async removeAddress(id:number):Promise<Response>{
        try {
            await Connection.db.getRepository<Address>(Address).delete(id);
            this.response.notifications.push(new Notification("Endereço excluído com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao excluir esse endereço. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async getCostumerById(id:number):Promise<Response>{
        try {
            this.response.data = await this.collection.findOne(id, { relations: ['addresses', 'phones'] });
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