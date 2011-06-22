![](http://vanishlab.web.fc2.com/vanishlab/OSS_files/chip.png)

FEATURE
=======
You can communicate Arduino with iOS easily.
You can build and Run using Xcode as you create normal project.<br>
This is iOS version of Android NDK.<br>
(This framework use UART,Android ADK uses USB)<br>
Using this framework and method Arduino can power from iOS devices.

Setting Up H/W
=======
See [iPhone Pinout] and,connect TX,RX,GND,5V(optional) with Arduino<br>
Note that use 5V version of Arduino when connecting with iOS devieces.<br>
You can use this(http://www.sparkfun.com/products/633) or this(http://www.sparkfun.com/products/8295) <br>
For more info about H/W setup check [iPhone Serial Port Tutorial]<br>


Setting Up iOS
=======
1.jailbreak your iOS device.<br>
More info about Jailbreak visit [Dev-Team]<br>
2.Add read,and execute to everyone for /dev/tty.iap<br>
3.Download this Project and open SerialCommunicationFramework/SerialCommunicationSkeleton/SerialCommunicationSkeleton.xcodeproj<br> 
4.Buil and Run.<br>
5.Connect Arduino.<br>
For more info about this frame work see source code in Project files.<br>

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


[Dev-Team]: http://blog.iphone-dev.org/
[vanishlab]: http://vanishlab.web.fc2.com/
[BSD License]: http://www.opensource.org/licenses/bsd-license.php
[facebook]: http://www.facebook.com/yusuke.sekikawa
[twitter]: http://twitter.com/#!/YusukeSekikawa
[iPhone Pinout]: http://pinouts.ru/Devices/ipod_pinout.shtml
[iPhone Serial Port Tutorial]: http://devdot.wikispaces.com/Iphone+Serial+Port+Tutorial