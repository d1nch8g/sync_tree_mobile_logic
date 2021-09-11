// import '../local/storage.dart';
// import '../local/crypto.dart';
// import 'info_calls.dart';
// import 'user_calls.dart';

// Future<String> loadNameFromNet() async {
//   var adress = await Crypt().getPersonalAdressBytes();
//   var userInfo = await infoUser(adress);
//   saveValue(StorageKey.publicName, userInfo.name);
//   return userInfo.name;
// }

// Future<bool> updateUserInfo() async {
//   var publicKey = Keys().keyToBytes(await loadValue(StorageKey.privateKey));
//   var mesKey = Keys().keyToBytes(await loadValue(StorageKey.publicMessageKey));
//   var name = await loadValue(StorageKey.publicName);
//   var valuesList = [
//     publicKey,
//     mesKey,
//     name,
//   ];
//   var sign = await Crypt().signList(valuesList);
//   var updatedSuccessfully = await userUpdate(publicKey, mesKey, name, sign);
//   return updatedSuccessfully;
// }

// Future<bool> createNewUser() async {
//   var publicKey = Keys().keyToBytes(await loadValue(StorageKey.publicKey));
//   var mesKey = Keys().keyToBytes(await loadValue(StorageKey.publicMessageKey));
//   var name = await loadValue(StorageKey.publicName);
//   var valuesList = [
//     publicKey,
//     mesKey,
//     name,
//   ];
//   var sign = await Crypt().signList(valuesList);
//   print('sending message');
//   var createdSuccess = await userCreate(publicKey, mesKey, name, sign);
//   print(createdSuccess);
//   return createdSuccess;
// }

// Future<bool> sendAmountByAdress(String adressBase64, int amount) async {
//   var publicKey = Keys().keyToBytes(await loadValue(StorageKey.privateKey));
//   var reciever = Keys().keyToBytes(adressBase64);
//   var valueList = [
//     publicKey,
//     amount,
//     reciever,
//   ];
//   var sign = await Crypt().signList(valueList);
//   var sendSuccess = await userSend(publicKey, amount, reciever, sign);
//   return sendSuccess;
// }
