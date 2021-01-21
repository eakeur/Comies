import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, ManyToMany} from "typeorm";
import Order from "./order";
import Product from "./product";

@Entity()
export default class ProductItem {

    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => Order, order => order.products)
    order: Order;

    @ManyToMany(() => ProductItem, productItem => productItem.order, { eager: true })
    product: Product;

    @Column({nullable: false, type:"float"})
    quantity: number;

    @Column({nullable: false, type:"float"})
    discount: number;




}