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
http://pinouts.ru/Devices/ipod_pinout.shtml<br>
Connect TX,RX,GND,5V(optional)<br>
For more info about H/W setup check [iPhone Serial Port Tutorial]<br>


Setting Up iOS
=======
To use this framework you need to add read access for USER to /dev/tty.iap<br>
You can use iFile from Cydia or any other application to change permission.<br>
You need to jailbreak your iOS device.<br>
For more info about Jailbreak visit [Dev-Team]<br>


<br>
Change permission /dev/tty.iap to add user read access.


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
[iPhone Serial Port Tutorial] :http://devdot.wikispaces.com/Iphone+Serial+Port+Tutorial