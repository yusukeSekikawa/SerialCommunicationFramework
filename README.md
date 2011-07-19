![](http://vanishlab.web.fc2.com/vanishlab/OSS_files/chip.png)
FEATURE
=======
You can easily control Arduino using iOS devices.
You can build and Run using Xcode as you create normal project.<br>
This is iOS version of Android NDK.<br>
(This framework use UART,Android ADK uses USB)<br>
Using this framework and method Arduino can power from iOS devices.

[NEW]
It also provide remote control over 3G or Wifi,that you can control Arduino in remotely.



[JP]<br>
XCodeを使ってビルド＆実行できる環境で簡単にArduinoと通信するアプリを開発できます。<br>
iOS版のAndroid ADKみたいな感じの環境ができればなと思って開発しています。<br>
ADKより、いい点は、USBじゃなくてUARTなので通信がシンプルなのと、デバイスから電源をもらえるので（限度はありますが、、）構成がシンプルになる点です。<br>

![](http://blog-imgs-42.fc2.com/v/a/n/vanishlab/201106232358095ce.png)

Setting Up H/W
=======
See [iPhone Pinout] and,connect TX,RX,GND,Vcc(optional) with Arduino<br>
Note that use 3.3V version of Arduino when connecting with iOS devieces.<br>
You can use this(http://www.sparkfun.com/products/633) or this(http://www.sparkfun.com/products/8295) <br>
For more info about iOS Serial port check [iPhone Serial Port Tutorial]<br>
You can easily build development boards with the help of the sample code in yourself,or you can build your favorite,or you can even use " Android Open Accessory compatible development boards" and connect to iOS with TX,RX and GND. 

[JP]<br>
[iPhone Pinout] を参考にして、TX,RX,GND,Vcc(optional) をArduinoと接続してください。<br>
電源をデバイスから取りたい場合には、3.3V品のArduinoを使ってください。.<br>
DockConnectorとの接続には、秋葉原とかで売っている工作用のを使うか、手持ちのいらないケーブルを分解してもOKです。 <br>
DocKコネクタを経由したシリアル通信について、詳しく知りたい方は[iPhone Serial Port Tutorial]を参考にしてください。<br>
/Arduino(iOS ADK sample)/iOS_ADKArduino/iOS_ADK.pde を開いて、付属のファームウェアを転送してください。<br>
サンプルコードに対応したdevelopment boardsは上記コードを参考に簡単に組み立てることもできますし、ちょっと高いですがAndroid-ADKを購入し、シリアル端子を付けてもOKです。<br>


Setting Up iOS
=======
1.jailbreak your iOS device.<br>
More info about Jailbreak visit [Dev-Team]<br>
2.Add read,and execute to everyone for /dev/tty.iap<br>
3.Download this Project and open SerialCommunicationFramework/SerialCommunicationSkeleton/SerialCommunicationSkeleton.xcodeproj<br> 
4.Buil and Run.<br>
5.Connect Arduino.<br>
For more info about this frame work see source code in Project files.<br>

[JP]<br>
1.デバイスをJailbreakします。<br>
2./dev/tty.iapにユーザのExecuteとRead権限を付加します。（CydiaにあるiFileを使うと簡単です）<br>
3.このプロジェクトをダウンロードし、SerialCommunicationFramework/SerialCommunicationSkeleton/SerialCommunicationSkeleton.xcodeproj　を開きます。<br> 
4.Buil and Run.<br>
5.上で作成したケーブルを介してArduinoを接続すれば動くはずです。<br>


How to use remote controll function with sample project,
=======
[Server]<br>
1.Connect Arduino.<br>
2.Home->Settings->ADK Select Server<br>
3.Lunch App.<br>

[Client]<br>
1.Home->Settings->ADK Select Clinet<br>
2.Lunch App.<br>
3.Input IP Address shown in server side App and push connect.
$.Background color turns black when successfully connected with server.(Server side also turns black)



[JP]<br>
1.Arduinoを接続します。.<br>
2.Home->Settings->ADK でServerを選択します。<br>
3.アプリケーションを起動します.<br>

[Client]<br>
1.Home->Settings->ADK でClinetを選択します。<br>
2.アプリケーションを起動します.<br>
3.Server側の画面に表示されているIPアドレスを入力してconnectを押します。
$.正常に接続されると、背景が赤から黒に変わります。（サーバー側も同様に黒になります)

Limitations
=======

[JP]<br>
0xffを同期用の信号として使用しているため、現在、iOS->Arduinoにおくる値として、0xffが使用できません。<br>
将来的には、現在の4Byteパケットの構成はかえないまま0xffを使用可能になるように修正する予定です。


Update Plan
=======
In update I want to add direct socket access feature from remote device in same network.
I commented out draft code in "SerialCommunication.m",someone please implement this feature.

Reference
=======
http://hcgilje.wordpress.com/2010/02/15/iphone-serial-communication/<br>


HP
=======
[vanishlab]

Contacts
=======
[facebook]<br>
[twitter]

Dependency
=======
Accelerate.framework
 
Acknowledgement
=======

License
=======
BSD License.

Gallery
=======
BSD License.
![](http://blog-imgs-42.fc2.com/v/a/n/vanishlab/20110625121707c2a.jpg)


[Dev-Team]: http://blog.iphone-dev.org/
[vanishlab]: http://vanishlab.web.fc2.com/
[BSD License]: http://www.opensource.org/licenses/bsd-license.php
[facebook]: http://www.facebook.com/yusuke.sekikawa
[twitter]: http://twitter.com/#!/YusukeSekikawa
[iPhone Pinout]: http://pinouts.ru/Devices/ipod_pinout.shtml
[iPhone Serial Port Tutorial]: http://devdot.wikispaces.com/Iphone+Serial+Port+Tutorial