import {Entity, PrimaryGeneratedColumn, Column, ManyToOne} from "typeorm";
import Costumer from "./costumer";

@Entity()
export default class Address {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    cep: string;

    @Column({nullable:false})
    number: string;

    @Column({nullable:false})
    district: string;

    @Column()
    complement: string;

    @Column()
    reference: string;

    @Column({nullable:false})
    street: string;

    @Column({nullable:false})
    city: string;

    @Column({nullable:false})
    state: string;

    @Column({nullable:false})
    country: string;

    @ManyToOne(()=> Costumer, costumer => costumer.addresses, { eager: true })
    costumer:Costumer;

}