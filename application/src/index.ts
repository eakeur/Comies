import Connection from  './utils/connection'
import "reflect-metadata";
import {Action, createExpressServer} from 'routing-controllers';
import CostumerController from './controllers/costumer.controller';
import ProductController from './controllers/product.controller';
import OperatorService from './services/operator.service';
import OrderController from './controllers/order.controller';
import OperatorController from './controllers/operator.controller';

class ServerInitializer {

    public static start(){
        const init = new ServerInitializer();
    }

    constructor(){
        this.getDatabaseConnection()
            .then(() => this.initializeServer()
        );
    }

    public async getDatabaseConnection(){
        await Connection.connect();
        await Connection.initializeDatabase();
    }

    public async initializeServer(){
        return createExpressServer({
            cors: true,
            currentUserChecker: (action: Action) => new OperatorService().getOperatorByToken(action),
            classTransformer:true,
            authorizationChecker:  (action: Action, roles: any[]) => new OperatorService().authorizeOperator(action, roles),
            controllers: [CostumerController, ProductController, OrderController, OperatorController]
         }).listen(process.env.port || 8080);
    }
}

ServerInitializer.start();
