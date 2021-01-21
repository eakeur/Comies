import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinTable} from "typeorm";
import Operator from "./operator";
import PartnerConfiguration from "./partner-configurations";
import Product from "./product";
import { Profile } from "./profile";
import Store from "./store";

@Entity()
export default class Partner {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    name: string;

    @OneToMany(() => Store, store => store.partner)
    stores:Store[];

    @OneToMany(() => Product, product => product.partner)
    products:Product[];

    @OneToMany(() => Profile, profile => profile.partner)
    profiles:Profile[];

    @OneToMany(() => PartnerConfiguration, partnerConfiguration => partnerConfiguration.partner, { eager: true, cascade:true })
    @JoinTable()
    configurations:PartnerConfiguration[];

    @OneToMany(() => Operator, operator => operator.store)
    operators: Operator[];

    @Column({default: true})
    active:boolean;



}