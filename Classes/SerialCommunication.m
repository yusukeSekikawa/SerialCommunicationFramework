/*
 * SerialCommunication.framework for iOS
 * SerialCommunication.h
 *
 * Copyright (c) Yusuke Sekikawa, 11/06/02
 * All rights reserved.
 * 
 * BSD License
 *
 * Redistribution and use in source and binary forms, with or without modification, are 
 * permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, this list of
 *  conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this list
 *  of conditions and the following disclaimer in the documentation and/or other materia
 * ls provided with the distribution.
 * - Neither the name of the "Yuichi Yoshida" nor the names of its contributors may be u
 * sed to endorse or promote products derived from this software without specific prior 
 * written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY E
 * XPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES O
 * F MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SH
 * ALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENT
 * AL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROC
 * UREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS I
 * NTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRI
 * CT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF T
 * HE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#import "SerialCommunication.h"

#import "serial.h"
#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

@implementation SerialCommunication
@synthesize delegate;
-(BOOL)isDeviceConnected{
    return YES;
}
-(int)openSerialPort{
	
	struct termios org_termios_s;
	struct termios my_termios_s;
	serialFD = -1;
	
	// Open serial port
	if((serialFD = open("/dev/tty.iap", O_RDWR | O_NOCTTY | O_NONBLOCK)) == -1) {
		NSLog(@"open failed");
		return serialFD;	
    }
	if(ioctl(serialFD, TIOCEXCL) == -1) {
		NSLog(@"TIOCEXCL");
		close(serialFD);
		return serialFD;	
    }
	if(fcntl(serialFD, F_SETFL, 0) == -1) {
		NSLog(@"clear O_NONBLOCK");
		close(serialFD);
		return serialFD;
	}
	
	// Get original termios
	if(tcgetattr(serialFD, &org_termios_s) == -1) {
		NSLog(@"get serial original termios");
		close(serialFD);
		return serialFD;	
    }
	
	// Make my termios
	my_termios_s = org_termios_s;
	cfmakeraw(&my_termios_s);
	my_termios_s.c_iflag = 0;
	my_termios_s.c_oflag = 0;
	my_termios_s.c_cflag |= (CREAD|HUPCL);
	my_termios_s.c_cflag &= ~CSTOPB;
	my_termios_s.c_cc[VMIN] = 0; //can't detect modem hungups (cf. http://www.sbin.org/doc/unix-faq/programmer/faq_4.html#SEC60)
	my_termios_s.c_cc[VTIME] = 0;
	cfsetspeed(&my_termios_s, B9600);

	// Change terminal settings
	if(tcsetattr(serialFD, TCSANOW, &my_termios_s) == -1) {
		NSLog(@"set my serial termios");
		close(serialFD);
		return false;	
    }
	
	// Success
	return serialFD;
}


-(void)serialDataRecieved:(NSNumber*)uint32_tNum{
    [self.delegate serialDataRecieved:[uint32_tNum intValue]];
}
-(void)serialAlert:(NSString*)msg{
    [self.delegate serialAlert:msg];
}
-(int)sendSerialData:(uint32_t)data{
    //NSLog(@"Sent %x",data);
    return write(serialFD,&data,sizeof(uint32_t));  // Write 32bit
}
-(void)readSerialData{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	uint32_t data=0x00000000;
	
	while (1) {
        data=0x00;
        if(serialFD<0){
            break;
        }
		int len=read(serialFD,&data,sizeof(uint32_t));  // Read 32bit
		if (len>0) {
			/* read some charactor over serial */
			[self performSelectorOnMainThread:@selector(serialDataRecieved:) withObject:[NSNumber numberWithInt:data] waitUntilDone:NO];
		}
	}
	[pool release];
}



// TODO.
//In future update,this framework provide socket access from remote devece.
//
//- (void) startServer
//{
//	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
//	socklen_t length;
//	static struct sockaddr_in cli_addr; 
//	static struct sockaddr_in serv_addr;
//	
//	// Set up socket
//	if((listenfd = socket(AF_INET, SOCK_STREAM,0)) <0)	
//	{
//		isServing = NO;
//		[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(1)"] waitUntilDone:NO];
//
//		return;
//	}
//	
//	[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(2)"] waitUntilDone:NO];
//
//    // Serve to a random port
//	serv_addr.sin_family = AF_INET;
//	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
//	serv_addr.sin_port = 1234;
//	
//	// Bind
//	if(bind(listenfd, (struct sockaddr *)&serv_addr,sizeof(serv_addr)) <0)	
//	{
//		[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(3)"] waitUntilDone:NO];
//
//		isServing = NO;
//		return;
//	}
//	[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(4)"] waitUntilDone:NO];
//
//	
//	// Find out what port number was chosen.
//	int namelen = sizeof(serv_addr);
//	if (getsockname(listenfd, (struct sockaddr *)&serv_addr, (void *) &namelen) < 0) {
//		[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(5)"] waitUntilDone:NO];
//
//		close(listenfd);
//		isServing = NO;
//		return;
//	}
//	// Listen
//	if(listen(listenfd, 64) < 0)	
//	{
//		[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(6)"] waitUntilDone:NO];
//
//		isServing = NO;
//		return;
//	} 
//	
//	[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(7)"] waitUntilDone:NO];
//
//	
//	length = sizeof(cli_addr);
//	while (1) {
//		if((socketfd = accept(listenfd, (struct sockaddr *)&cli_addr, &length)) < 0)
//		{
//			[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"(8)"] waitUntilDone:NO];
//			
//			isServing = NO;
//			NSLog(@"accept failed");
//			return;
//		}else{
//			[self performSelectorOnMainThread:@selector(addLog:) withObject:[NSString stringWithFormat:@"Connected With Client"] waitUntilDone:NO];
//			isServing=YES;
//		}
//	}
//	[pool release];
//}
- (id)init {
    serialFD=[self openSerialPort];
	if(serialFD>0){
        [NSThread detachNewThreadSelector:@selector(readSerialData) toTarget:self withObject:nil];
        [self serialAlert:@"Open Serial Port Success!"];
        NSLog(@"Open Serial Port Success!");
        return [super init];
    }else{
        [self serialAlert:@"Open Serial Port Failed!"];
        NSLog(@"Open Serial Port Failed!");
        return nil;
    }
}

- (void)dealloc {
    close(serialFD);
    serialFD=-1;
    [super dealloc];
}
@end
