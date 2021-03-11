import Connection from "../utils/connection";
import { FindConditions, Like, Repository } from "typeorm";
import Operator from "../structures/operator";
import Response from "../structures/response";
import Notification from "../structures/notification";
import { Action } from "routing-controllers/Action";
import * as jwt from "jsonwebtoken";
import { Body, Controller, Post, UseBefore } from "routing-controllers";
import { json } from "body-parser";


@Controller('/authentication')
export default class AuthenticationController {

    response: Response = new Response();

    collection:Repository<Operator> = Connection.db.getRepository<Operator>(Operator);

    conditions: FindConditions<Operator> = {}

    @Post("")
    @UseBefore(json())
    public async authenticate(@Body() authParams: { identification:string, password:string, remember: boolean}): Promise<Response>{
        try {
            const filter:Operator = new Operator();
            filter.identification = authParams.identification;
            const operator = await this.collection.findOneOrFail(filter);
            if (!operator.active){throw new Error("Operator "+filter.identification+" is unactive and tried to login.");}
            if (operator.password === authParams.password){
                operator.lastLogin = new Date(Date.now());
                this.response.access = jwt.sign({id: operator.id}, Connection.secret, { expiresIn: authParams.remember ? 86400 : 3600});
                this.response.success = true;
            } else {
                this.response.success = false;
                this.response.notification = new Notification("Senha incorreta.");
            }
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notification = new Notification("Não foi possível encontrar um operador com o apelido especificado. Por favor, verifique se ele foi digitado corretamente ou fale com um administrador");

        }
        return this.response;
    }

    // Internal use. Nothing here is used by controllers

    public async getOperatorByToken(action: Action):Promise<Operator>{
        try {
            const identification : { id: number, iat:number, exp:number } = jwt.verify(action.request.headers.authorization, Connection.secret) as { id: number, iat:number, exp:number };
            const operator = await this.collection.findOne(identification.id);
            if (!operator.active) throw new Error('Inactive user');
            if (new Date(identification.exp).getMinutes() < 60) action.response.locals.jwtPayload = jwt.sign({id: operator.id}, Connection.secret, { expiresIn: 3600 });
            return operator;
        } catch (error) {
            console.log("Operador não autorizado com token: " + action.request.headers.authorization)
            return undefined;
        }
    }

    public async getOperatorBySocketToken(token: string):Promise<Operator>{
        try {
            const identification : { id: number, iat:number, exp:number } = jwt.verify(token, Connection.secret) as { id: number, iat:number, exp:number };
            const operator = await this.collection.findOne(identification.id);
            if (!operator.active) throw new Error('Inactive user');
            return operator;
        } catch (error) {
            console.log("Operador não autorizado com token: " + token)
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