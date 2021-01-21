export default class Notification {
    message: string;
    action: {name: string, href:string}


    constructor(message: string){
        this.message = message;
    }
}