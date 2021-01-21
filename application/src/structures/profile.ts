import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import Operator from "./operator";
import Partner from "./partner";

@Entity()
export class Profile {

    @PrimaryGeneratedColumn()
    id: number;

    @Column({default:'Sem nome'})
    name: string;

    @Column({default: false})
    canAddOrders: boolean;

    @Column({default: false})
    canAddProducts: boolean;

    @Column({default: false})
    canAddCostumers: boolean;

    @Column({default: false})
    canAddStores: boolean;

    @Column({default: false})
    canUpdateOrders: boolean;

    @Column({default: false})
    canUpdateProducts: boolean;

    @Column({default: false})
    canUpdateCostumers: boolean;

    @Column({default: false})
    canUpdateStores: boolean;

    @Column({default: false})
    canGetOrders: boolean;

    @Column({default: false})
    canGetProducts: boolean;

    @Column({default: false})
    canGetCostumers: boolean;

    @Column({default: false})
    canGetStores: boolean;

    @Column({default: false})
    canRemoveOrders: boolean;

    @Column({default: false})
    canRemoveProducts: boolean;

    @Column({default: false})
    canRemoveCostumers: boolean;

    @Column({default: false})
    canRemoveStores: boolean;

    @ManyToOne(() => Partner, partner => partner.profiles)
    partner: Partner;

    @OneToMany(() => Operator, operator => operator.profile)
    operators: Operator[];
}