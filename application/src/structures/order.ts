import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, ManyToMany, JoinTable} from "typeorm";
import Costumer from "./costumer";
import PartnerConfiguration from "./partner-configurations";
import Product from "./product";
import Store from "./store";
import ProductItem from "./order-items";
import { DeliverType, PaymentMethod, Status } from "./enums";
import Operator from "./operator";
import Address from "./address";

@Entity()
export default class Order {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    placed: Date;

    @Column({nullable:false, default:Status.pending})
    status: Status;

    @Column({nullable:false, default:PaymentMethod.cash})
    payment: PaymentMethod;

    @Column({nullable:false, default:DeliverType.takeout})
    deliverType: DeliverType;

    @ManyToOne(() => Address, address => address.orders, {cascade: true, eager:true})
    address: Address;

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