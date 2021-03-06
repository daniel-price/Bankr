import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../api/true_layer/true_layer_api_adapter_test.dart';
import '../../fake_data_generator.dart';

class FakeDataRetriever implements DataRetriever {
  final DownloadedData response;

  FakeDataRetriever(this.response);

  @override
  Future<DownloadedData> retrieveAllData(String uuidAccessToken) {
    return Future.value(response);
  }

  @override
  Future<DownloadedData> retrieveBalancesAndTransactions(AccountProvider accountProvider, List<Account> accounts) {
    return Future.value(response);
  }
}

class DataSaverSpy implements DataSaver {
  int saveCounter = 0;

  @override
  save(DownloadedData downloadedData) async {
    saveCounter++;
  }

  @override
  saveAudit(String uuidAccountProvider, bool success) {

  }
}

void main() {
  group("downloadData", () {
    test("returns true if successful", () async {
      var downloadedData = generateFakeDownloadedData();
      DataDownloader dataDownloader = factoryFakeDataDownloader(downloadedData: downloadedData);

      var success = await dataDownloader.downloadAllData();

      expect(success, TypeMatcher<String>());
    });

    test("saved data if successful", () async {
      var downloadedData = generateFakeDownloadedData();
      var dataSaver = DataSaverSpy();
      var dataDownloader = factoryFakeDataDownloader(downloadedData: downloadedData, dataSaver: dataSaver);

      await dataDownloader.downloadAllData();

      expect(dataSaver.saveCounter, 1);
    });

    test("returns null if no data", () async {
      var dataDownloader = factoryFakeDataDownloader();

      var success = await dataDownloader.downloadAllData();

      expect(success, null);
    });

    test("doesn't save data if unsuccessful", ()
    async {
      var dataSaver = DataSaverSpy();
      var dataDownloader = factoryFakeDataDownloader(dataSaver: dataSaver);

      await dataDownloader.downloadAllData();

      expect(dataSaver.saveCounter, 0);
    });
  });

  group("update", ()
  {
    test("returns true if successful", ()
    async {
      var downloadedData = generateFakeDownloadedData();
      var dataDownloader = factoryFakeDataDownloader(downloadedData: downloadedData);

      var success = await dataDownloaderUpdate(dataDownloader);

      expect(success, true);
    });

    test("saved data if successful", ()
    async {
      var downloadedData = generateFakeDownloadedData();
      var dataSaver = DataSaverSpy();
      var dataDownloader = factoryFakeDataDownloader(downloadedData: downloadedData, dataSaver: dataSaver);

      await dataDownloaderUpdate(dataDownloader);

      expect(dataSaver.saveCounter, 1);
    });

    test("returns false if no data", ()
    async {
      var dataDownloader = factoryFakeDataDownloader();

      var success = await dataDownloaderUpdate(dataDownloader);

      expect(success, false);
    });

    test("doesn't save data if unsuccessful", ()
    async {
      var dataSaver = DataSaverSpy();
      var dataDownloader = factoryFakeDataDownloader(dataSaver: dataSaver);

      await dataDownloaderUpdate(dataDownloader);

      expect(dataSaver.saveCounter, 0);
    });
  });
}

dataDownloaderUpdate (DataDownloader dataDownloader)
{
  var accountProvider = generateFakeAccountProvider();
  var accounts = generateFakeAccounts();
  return dataDownloader.update(accountProvider, accounts);
}

factoryFakeDataDownloader ({DownloadedData downloadedData, DataSaverSpy dataSaver})
{
  var dataRetriever = FakeDataRetriever(downloadedData);
  var fakeOAuthHttp = FakeOAuthHttp();
  when(fakeOAuthHttp.authenticate()).thenAnswer((_)
  => Future.value('code'));
  return DataDownloader(fakeOAuthHttp, dataRetriever, dataSaver ?? DataSaverSpy());
}
