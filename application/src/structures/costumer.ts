import {Entity, PrimaryGeneratedColumn, Column, OneToMany} from "typeorm";
import Address from "./address";
import Phone from "./phone";
import Product from "./product";
import Order from "./order";

@Entity()
export default class Costumer {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @OneToMany(()=> Phone, phone => phone.costumer, {cascade: true, eager: true})
    phones: Phone[];

    @OneToMany(()=> Address, address => address.costumer, {cascade: true, eager: true})
    addresses: Address[];

    @OneToMany(() => Order, order => order.costumer)
    orders: Order[];

    @Column({default: true})
    active:boolean;

}