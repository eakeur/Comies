import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { ConfigKey } from "./enums";
import Partner from "./partner";

@Entity()
export default class PartnerConfiguration {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(()=> Partner, partner => partner.configurations)
    partner: Partner;

    @Column({nullable:false})
    key: ConfigKey;

    @Column({nullable:false})
    value: number;

    @Column({nullable:false})
    active: boolean;




}