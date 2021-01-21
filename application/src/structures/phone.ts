import {Entity, PrimaryGeneratedColumn, Column, ManyToOne} from "typeorm";
import Costumer from "./costumer";

@Entity()
export default class Phone {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    ddd: number;

    @Column({nullable:false})
    number: number;

    @ManyToOne(()=> Costumer, costumer => costumer.phones, { eager: true })
    costumer:Costumer;

}