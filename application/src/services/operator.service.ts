import Connection from "../utils/connection";
import { FindConditions, Like, Repository } from "typeorm";
import Operator from "../structures/operator";
import Response from "../structures/response";
import Notification from "../structures/notification";
import { Action } from "routing-controllers/Action";
import * as jwt from "jsonwebtoken";

export default class OperatorService {

    constructor(operator?: Operator){
        this.operator = operator;
    }

    operator: Operator;

    response: Response = new Response();

    collection:Repository<Operator> = Connection.db.getRepository<Operator>(Operator);

    conditions: FindConditions<Operator> = {}

    public async addOperator(operator:Operator):Promise<Response>{
        try {
            await this.collection.save(operator);
            this.response.notification = new Notification("Operador adicionado com sucesso!");
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Um erro ocorreu ao adicionar esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async removeOperator(operator:Operator):Promise<Response>{
        try {
            await this.collection.remove(operator);
            this.response.notification = new Notification("Operador excluído com sucesso!");
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Um erro ocorreu ao excluir esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async updateOperator(operator:Operator):Promise<Response>{
        try {
            if (this.operator.id !== operator.id){throw Error;}
            await this.collection.save(operator);
            this.response.notification = new Notification("Operador atualizado com sucesso!");
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Um erro ocorreu ao atualizar esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas.");
        }
        return this.response;
    }

    public async getOperatorById(id:number):Promise<Response>{
        try {
            const result = await this.collection.findOne(id);
            delete result.password;
            this.response.data = result;
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por este operador. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }

    public async getOperators(filters:Operator):Promise<Response>{
        try {
            this.conditions.active = true;
            if (filters.name) this.conditions.name = Like(filters.name);
            const results = await this.collection.find(this.conditions);
            results.forEach( result => delete result.password);
            this.response.data = results;
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Ocorreu um erro ao procurar por operadores. Por favor, tente mais tarde ou fale com um administrador.");
        }
        return this.response;
    }
}