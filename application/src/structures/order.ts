import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, ManyToMany, JoinTable} from "typeorm";
import Costumer from "./costumer";
import PartnerConfiguration from "./partner-configurations";
import Product from "./product";
import Store from "./store";
import ProductItem from "./order-items";
import { Status } from "./enums";
import Operator from "./operator";

@Entity()
export default class Order {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    placed: Date;

    @Column({nullable:false, default:Status.pending})
    status: Status;

    @ManyToOne(() => Store, store => store.orders)
    store: Store;

    @ManyToOne(() => Costumer, costumer => costumer.orders, { eager: true })
    costumer: Costumer;

    @ManyToOne(() => Operator, operator => operator.orders, { eager: true })
    operator: Operator;

    @OneToMany(() => ProductItem, productItem => productItem.order, {cascade: true, eager:true})
    @JoinTable()
    products: ProductItem[];

    @Column({nullable: false, type:"float"})
    price: number;

    @Column({default: true})
    active: boolean;



}