import {Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany} from "typeorm";
import Order from "./order";
import Partner from "./partner";
import { Profile } from "./profile";
import Store from "./store";

@Entity()
export default class Operator {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    firstName: string;

    @Column()
    lastName: string;

    @Column({nullable:false})
    identification: string;

    @Column({nullable:false})
    password: string;

    @Column({nullable:true})
    token: string;

    @Column()
    lastLogin: Date;

    @ManyToOne(() => Profile, profile => profile.operators, { eager: true })
    profile: Profile;

    @ManyToOne(() => Store, store => store.operators, { eager: true })
    store: Store;

    @ManyToOne(() => Partner, partner => partner.operators, { eager: true })
    partner: Partner;

    @OneToMany(() => Order, order => order.operator)
    orders: Order[];

    @Column({default: true})
    active: boolean;

}