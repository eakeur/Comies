import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany} from "typeorm";
import Operator from "./operator";
import Order from "./order";
import Partner from "./partner";
import Product from "./product";

@Entity()
export default class Store {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    name: string;

    @ManyToOne(() => Partner, partner => partner.stores, { eager: true })
    partner:Partner;

    @OneToMany(() => Order, order => order.store)
    orders: Order[];

    @OneToMany(() => Operator, operator => operator.store)
    operators: Operator[];

}