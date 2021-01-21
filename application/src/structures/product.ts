import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, ManyToMany} from "typeorm";
import { Unity } from "./enums";
import Order from "./order";
import Partner from "./partner";
import Store from "./store";

@Entity()
export default class Product {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    name: string;

    @Column({nullable:false})
    code: string;

    @Column({nullable:false, default:1})
    min: number;

    @Column({nullable:false})
    unity: Unity;

    @Column({nullable:false, type:"float"})
    price: number;

    @ManyToOne(() => Partner, partner => partner.products)
    partner:Partner;

    @ManyToMany(() => Order, order => order.products)
    orders: Order[];

    @Column({default: true})
    active:boolean;

}