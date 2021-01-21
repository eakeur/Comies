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
    firstName: string;

    @Column()
    lastName: string;

    @Column({nullable:true})
    token: string;

    @OneToMany(()=> Phone, phone => phone.costumer)
    phones: Phone[];

    @OneToMany(()=> Address, address => address.costumer)
    addresses: Address[];

    @OneToMany(() => Order, order => order.costumer)
    orders: Order[];

    @Column({default: true})
    active:boolean;

}