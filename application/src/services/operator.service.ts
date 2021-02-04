import Connection from "../utils/connection";
import { Repository } from "typeorm";
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

    public async addOperator(operator:Operator):Promise<Response>{
        try {
            await this.collection.save(operator);
            this.response.notifications.push(new Notification("Operador adicionado com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao adicionar esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async removeOperator(operator:Operator):Promise<Response>{
        try {
            await this.collection.remove(operator);
            this.response.notifications.push(new Notification("Operador excluído com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao excluir esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async updateOperator(operator:Operator):Promise<Response>{
        try {
            if (this.operator.id !== operator.id){throw Error;}
            await this.collection.save(operator);
            this.response.notifications.push(new Notification("Operador atualizado com sucesso!"));
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao atualizar esse operador. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async getOperatorById(id:number):Promise<Response>{
        try {
            const result = await this.collection.findOne(id);
            result.password = '';
            this.response.data = result;
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Ocorreu um erro ao procurar por este operador. Por favor, tente mais tarde ou fale com um administrador."))
        }
        return this.response;
    }

    public async getOperators(filters:Operator):Promise<Response>{
        try {
            const query = this.collection.createQueryBuilder(); query.where("active = 1");
            if (filters.firstName ) query.andWhere(`firstName LIKE '%${filters.firstName}%'`);
            if (filters.lastName ) query.andWhere(`lastName LIKE '%${filters.lastName}%'`);
            if (filters.store) query.andWhere(`storeId = ${filters.store.id}`     );
            const results = await query.getMany();
            results.forEach( result => result.password = '');
            this.response.data = results;
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Ocorreu um erro ao procurar por operadores. Por favor, tente mais tarde ou fale com um administrador."))
        }
        return this.response;
    }

    public async authenticate(authParams: { identification:string, password:string }): Promise<Response>{
        try {
            const filter:Operator = new Operator();
            filter.identification = authParams.identification;
            const operator = await this.collection.findOneOrFail(filter);
            if (!operator.active){throw new Error("Operator "+filter.identification+" is unactive and tried to login.");}
            if (operator.password === authParams.password){
                operator.lastLogin = new Date(Date.now());
                this.response.access = jwt.sign({id: operator.id}, Connection.secret, { expiresIn: 3600 });
                this.response.success = true;
            } else {
                this.response.success = false;
                this.response.notifications.push(new Notification("Senha incorreta."));
            }
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Não foi possível encontrar um operador com o apelido especificado. Por favor, verifique se ele foi digitado corretamente ou fale com um administrador"));

        }
        return this.response;
    }




















    // Internal use. Nothing here is used by controllers

    public async getOperatorByToken(action: Action):Promise<Operator>{
        try {
            const identification : { id: number, iat:number, exp:number } = jwt.verify(action.request.headers.authorization, Connection.secret) as { id: number, iat:number, exp:number };
            const operator = await this.collection.findOne(identification.id)
            action.response.locals.jwtPayload = jwt.sign({id: operator.id}, Connection.secret, { expiresIn: 3600 });
            return operator;
        } catch (error) {
            console.log("Operador não autorizado com token: " + action.request.headers.authorization)
            return undefined;
        }
    }

    public async authorizeOperator(action: Action, roles: string[]):Promise<boolean>{
        try {
            const identification = jwt.verify(action.request.headers.authorization, Connection.secret)
            let allowed: boolean = false;
            const operator = await this.collection.findOne(identification.toString(), { relations: ['profile'] });
            const allowances = operator.profile;
            roles.forEach(
                role => {
                    switch (role) {
                        case 'addCostumers': allowed = allowances.canAddCostumers; break;
                        case 'getCostumers': allowed = allowances.canGetCostumers; break;
                        case 'updateCostumers': allowed = allowances.canUpdateCostumers; break;
                        case 'removeCostumers': allowed = allowances.canRemoveCostumers; break;

                        case 'addOrders': allowed = allowances.canAddOrders; break;
                        case 'getOrders': allowed = allowances.canGetOrders; break;
                        case 'updateOrders': allowed = allowances.canUpdateOrders; break;
                        case 'removeOrders': allowed = allowances.canRemoveOrders; break;

                        case 'addProducts': allowed = allowances.canAddProducts; break;
                        case 'getProducts': allowed = allowances.canGetProducts; break;
                        case 'updateProducts': allowed = allowances.canUpdateProducts; break;
                        case 'removeProducts': allowed = allowances.canRemoveProducts; break;

                        case 'addStores': allowed = allowances.canAddStores; break;
                        case 'getStores': allowed = allowances.canGetStores; break;
                        case 'updateStores': allowed = allowances.canUpdateStores; break;
                        case 'removeStores': allowed = allowances.canRemoveStores; break;
                        default: return true;
                    }
                }
            );
            return true;
        } catch (error){
            return true;
        }
    }
}