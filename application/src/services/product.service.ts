import Connection from "../utils/connection";
import { Repository } from "typeorm";
import Product from "../structures/product";
import Response from "../structures/response";
import Notification from "../structures/notification";
import Operator from "../structures/operator";

export default class ProductService {

    constructor(operator?: Operator){
        this.operator = operator;
    }

    response: Response = new Response();

    operator: Operator;

    collection:Repository<Product> = Connection.db.getRepository<Product>(Product);

    public async addProduct(product:Product):Promise<Response>{
        try {
            product.partner = this.operator.partner;
            await this.collection.insert(product);
            this.response.notifications.push(new Notification("Produto adicionado com sucesso!"))
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao adicionar esse produto. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async removeProduct(productID: number):Promise<Response>{
        try {
            await this.collection.delete(productID);
            this.response.notifications.push(new Notification("Produto excluído com sucesso!"))
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao excluir esse produto. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async updateProduct(product:Product):Promise<Response>{
        try {
            await this.collection.update(product.id, product);
            this.response.notifications.push(new Notification("Produto atualizado com sucesso!"))
        } catch (error) {
            console.log(error.message)
            this.response.success = false;
            this.response.notifications.push(new Notification("Um erro ocorreu ao atualizar esse produto. Por favor, tente novamente mais tarde ou verifique se todas as informações estão corretas."));
        }
        return this.response;
    }

    public async getProductById(id:number):Promise<Response>{
        try {
            this.response.data = await this.collection.findOne(id);
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Ocorreu um erro ao procurar por este produto. Por favor, tente mais tarde ou fale com um administrador."))
        }
        return this.response;
    }

    public async getProducts(filters:Product):Promise<Response>{
        try {
            const query = this.collection.createQueryBuilder(); query.where("active = 1");
            if (filters.code ) query.andWhere(`code LIKE '%${filters.code}%'`);
            if (filters.name ) query.andWhere(`name LIKE '%${filters.name}%'`);
            if (filters.price) query.andWhere(`price = ${filters.price}`     );
            this.response.data = await query.getMany();
        } catch (error) {
            console.error(error);
            this.response.success = false;
            this.response.notifications.push(new Notification("Ocorreu um erro ao procurar por produtos. Por favor, tente mais tarde ou fale com um administrador."))
        }

        return this.response;
    }
}