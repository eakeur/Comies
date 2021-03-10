import 'dart:collection';
import 'package:comies/services/general.service.dart';
import 'package:comies/utils/converters.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/cupertino.dart';

class CostumerController extends ChangeNotifier {

  List<Costumer> _costumers;
  Costumer _costumer;
  Address _address;
  Phone _phone;

  Costumer costumerQuery = new Costumer();
  Address addressQuery = new Address();
  Phone phoneQuery = new Phone();

  LoadStatus costumersLoadStatus = LoadStatus.waitingStart; 
  LoadStatus addressesLoadStatus = LoadStatus.loaded;
  LoadStatus costumerLoadStatus = LoadStatus.loaded;
  LoadStatus addressLoadStatus = LoadStatus.loaded;
  LoadStatus phonesLoadStatus = LoadStatus.loaded;
  LoadStatus phoneLoadStatus = LoadStatus.loaded;
  
  bool deletePending = false;
  bool addPending = false;

  bool deleteAddressPending = false;
  bool addAddressPending = false;

  bool deletePhonePending = false;
  bool addPhonePending = false;


  Costumer get costumer => _costumer;
  Address get address => _address;
  Phone get phone => _phone;

  UnmodifiableListView<Costumer> get costumers => UnmodifiableListView<Costumer>(_costumers);

  Service<Costumer> costumerService = new Service<Costumer>("costumers", serializeCostumer, deserializeCostumerMap);
  Service<Address> addressService = new Service<Address>("costumers/addresses", serializeAddress, deserializeAddressMap);
  Service<Phone> phoneService = new Service<Phone>("costumers/phones", serializePhone, deserializePhoneMap);

  CostumerController({Costumer costumer, List<Costumer> costumers, Costumer query}){
    _costumer = costumer;
    _address = new Address();
    _phone = new Phone();
    _costumers = costumers ?? [];
    if (query != null){
      this.costumerQuery = query;
      getCostumers();
    }
  }





  Future<Response> getCurrentCostumerAddresses() async {
    addressesLoadStatus = LoadStatus.loading;
    notifyListeners();
    try {
      var res = await addressService.getMany(query: {'costumer': _costumer.id});
      if (!res.success) throw res;
      addressesLoadStatus = LoadStatus.loaded;
      _costumer.addresses = res.data;
      return res;
    } catch (e) {
      addressesLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      notifyListeners();
    }
  }


  Future<Response> getCurrentCostumerPhones() async {
    phonesLoadStatus = LoadStatus.loading;
    notifyListeners();
    try {
      var res = await phoneService.getMany(query: {'costumer': _costumer.id});
      if (!res.success) throw res;
      phonesLoadStatus = LoadStatus.loaded;
      _costumer.phones = res.data;
      return res;
    } catch (e) {
      phonesLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      notifyListeners();
    }
  }

    Future<void> getAddressByCEP() async {
    try {
      var res = await Service.getExternalResource("https://viacep.com.br/ws/${address.cep}/json/");
      if (res.data != null){
        _address.street = res.data['logradouro'];
        _address.cep = res.data['cep'];
        _address.city = res.data['localidade'];
        _address.complement = res.data['complemento'];
        _address.state = res.data['uf'];
        _address.district = res.data['bairro'];
        _address.country = "Brasil";
        notifyListeners();
      }
    } catch (e){

    }
  }

  void setCostumer(Costumer costumer) {_address = new Address(); _phone = new Phone(); _costumer = costumer;
  costumerLoadStatus = LoadStatus.loaded;
  notifyListeners();
  }
  void setAddress(Address address) {_address = address; addressLoadStatus = LoadStatus.loaded; notifyListeners();}
  void setPhone(Phone phone) {_phone = phone; phoneLoadStatus = LoadStatus.loaded; notifyListeners();}

  void clearCostumer(){_costumer = null; _address = new Address(); _phone = new Phone(); notifyListeners();}
  void clearAddress(){_address = new Address();notifyListeners();}
  void clearPhone(){_phone = new Phone();notifyListeners();}


  Future<Response> addCostumer() async {
    costumerLoadStatus = LoadStatus.loading;
    addPending = true;
    notifyListeners();
    try {
      var res = await costumerService.add(costumer);
      costumerLoadStatus = LoadStatus.loaded;
      if (!res.success) throw res;
      return res;
    } catch (e) {
      costumerLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      addPending = false;
      notifyListeners();
    }
  }

  Future<Response> removeCostumer() async {
    costumerLoadStatus = LoadStatus.loading;
    deletePending = true;
    notifyListeners();
    try {
      _costumers.remove(_costumer);
      var res = await costumerService.remove(costumer.id);
      costumerLoadStatus = LoadStatus.loaded;
      if (!res.success) throw res;
      _costumer = null;
      return res;
    } catch (e) {
      costumerLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      deletePending = false;
      notifyListeners();
    }
  }

  Future<Response> updateCostumer() async {
    costumerLoadStatus = LoadStatus.loading;
    addPending = true;
    notifyListeners();
    try {
      var res = await costumerService.update(costumer);
      costumerLoadStatus = LoadStatus.loaded;
      if (!res.success) throw res;
      return res;
    } catch (e) {
      costumerLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      addPending = false;
      notifyListeners();
    }
  }
  
  Future<Response> getCostumers() async {
    _costumers = [];
    costumersLoadStatus = LoadStatus.loading;
    notifyListeners();
    try {
      if (phoneQuery.number != null) return getCostumersByPhone();
      var res = await costumerService.getMany(filter: costumerQuery);
      if (!res.success) throw res;
      costumersLoadStatus = LoadStatus.loaded;
      _costumers = res.data;
      return res;
    } catch (e) {
      costumersLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      notifyListeners();
    }
  }

  Future<Response> getCostumersByPhone() async {
    _costumers = [];
    costumersLoadStatus = LoadStatus.loading;
    notifyListeners();
    try {
      var res = await costumerService.getMany(query: {'number': phoneQuery.number});
      if (!res.success) throw res;
      costumersLoadStatus = LoadStatus.loaded;
      _costumers = res.data;
      return res;
    } catch (e) {
      costumersLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      notifyListeners();
    }
  }



  Future<Response> addAddress() async {
    _costumer.addresses == null ? _costumer.addresses = [_address] : _costumer.addresses.add(_address);
    if(_costumer != null && _costumer.id != null && _costumer.id != 0){
      addressLoadStatus = LoadStatus.loading;
      addAddressPending = true;
      notifyListeners();
      try {
        var res = await costumerService.update(costumer);
        addressLoadStatus = LoadStatus.loaded;
        if (!res.success) throw res;
        res.notification.message.replaceFirst("Cliente", "Endereço");
        return res;
      } catch (e) {
        addressLoadStatus = LoadStatus.failed;
        throw e;
      } finally {
        addAddressPending = false;
        notifyListeners();
      }
    } else {
      notifyListeners();
      return new Response();
    }
  }

  Future<Response> removeAddress() async {
    if(_costumer != null && _costumer.id != null){
      deleteAddressPending = true;
      notifyListeners();
      try {
        _costumer.addresses.remove(_address);
        var res = await costumerService.update(_costumer);
        if (!res.success)throw res;
        return res;
      } catch (e) {
        _costumer.addresses.add(_address);
        throw e;
      } finally {
        deleteAddressPending = false;
        notifyListeners();
      }
    } else {
      _costumer.addresses.remove(_address);
      notifyListeners();
      return new Response();
    }
  }


  Future<Response> removePhone() async {
    
    if(_costumer != null && _costumer.id != null){
      costumerLoadStatus = LoadStatus.loading;
      addAddressPending = true;
      notifyListeners();
      try {
        _costumer.phones.remove(_phone);
        var res = await costumerService.update(_costumer);
        if (!res.success) throw res;
        return res;
      } catch (e) {
        _costumer.phones.add(_phone);
        throw e;
      } finally {
        addAddressPending = false;
        notifyListeners();
      }
    } else {
      _costumer.phones.remove(_phone);
      notifyListeners();
      return new Response();
    }
  }

  Future<Response> addPhone() async {
    _costumer.phones == null 
      ? _costumer.phones = [_phone]
      : _costumer.phones.add(_phone);
    if(_costumer != null && _costumer.id != null){
      costumerLoadStatus = LoadStatus.loading;
      addPhonePending = true;
      notifyListeners();
      try {
        var res = await costumerService.update(costumer);
        costumerLoadStatus = LoadStatus.loaded;
        if (!res.success) throw res;
        return res;
      } catch (e) {
        costumerLoadStatus = LoadStatus.failed;
        throw e;
      } finally {
        addPhonePending = false;
        notifyListeners();
      }
    } else {
      notifyListeners();
      return new Response();
    }
    
  }
}