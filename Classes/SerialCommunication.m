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
 * - Neither the name of the "Yusuke Sekikawa" nor the names of its contributors may be u
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

#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>



#import "AsyncSocket.h"

int WelcomeMsgTag=0;
int GenericMsgTag=1;


@implementation SerialCommunication
@synthesize delegate;
@synthesize running;

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

    int serialData=[uint32_tNum unsignedIntValue];

    if(self.running){
        if(socketType==TYPE_SERVER){
            [serialSocket writeData:[NSData dataWithBytes:&serialData length:sizeof(uint32_t)] withTimeout:-1 tag:GenericMsgTag];
        }else{
            ;
        }
    }

    
}
-(void)serialAlert:(NSString*)msg{
    [self.delegate serialAlert:msg];
}
-(int)sendSerialData:(uint32_t)data{
    //NSLog(@"Sent %x",data);
<<<<<<< HEAD
    return write(serialFD,&data,sizeof(uint32_t));  // Write 32bit
=======
    if(socketType==TYPE_SERVER){
        return write(serialFD,&data,sizeof(uint32_t));  // Write 32bit
    }else{
        [serialSocket writeData:[NSData dataWithBytes:&data length:sizeof(uint32_t)] withTimeout:-1 tag:GenericMsgTag];
        return 0;
    }
>>>>>>> Add remote access function.
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


// Return the iPhone's IP address
- (NSString *) wifiAddress
{
	char baseHostName[255];
	gethostname(baseHostName, 255);
	
	char hn[255];
	sprintf(hn, "%s.local", baseHostName);
	struct hostent *host = gethostbyname(hn);
    if (host == NULL)
	{
        herror("resolv");
		return NULL;
	}
    else {
        struct in_addr **list = (struct in_addr **)host->h_addr_list;
        NSString *wifiAddress=[NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSASCIIStringEncoding];
        if([wifiAddress isEqualToString:@"127.0.0.1"]){
            return @"N/A";
        }else{
            return wifiAddress;
        }
        
        //return [NSString stringWithFormat:@"<br /><i>or</i><br />http://%@:%d <hr /> http://%@:%d", [NSString stringWithCString:inet_ntoa(*list[0])], chosenPort,ThreeG_IP,chosenPort];
    }
}
- (NSString *) wanAddress
{
	struct ifaddrs * addrs, * ifloop; 
	char buf[64];
	struct sockaddr_in *s4;
	NSString *wanAddress;
	getifaddrs(&addrs);
	for (ifloop = addrs; ifloop != NULL; ifloop = ifloop->ifa_next)
	{
		s4 = (struct sockaddr_in *)(ifloop->ifa_addr);
		inet_ntop(ifloop->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) == NULL;
		const char * ifname = ifloop->ifa_name;
		if (memcmp(ifname, "pdp_ip1", 7) == 1)
		{
			printf("******%s: %s*******\n", ifloop->ifa_name, buf);
			wanAddress=[[NSString alloc] initWithUTF8String:buf];
		}
		printf("----%s: %s----\n", ifloop->ifa_name, buf);
		//printf("%s: %s----\n", ifloop->ifa_addr, buf);
	}
    if([wanAddress isEqualToString:@"127.0.0.1"]){
        return @"N/A";
    }else{
        return wanAddress;
    }
}
//TODO.
//In future update,this framework provide socket access from remote devece.

-(void)addLog:(NSString*)str{
    ;
}

- (id)initWithType:(uint8_t)type{
    socketType=type;
    if((self=[super init])){
        if(type==TYPE_LOCAL || type==TYPE_SERVER){
            serialFD=[self openSerialPort];
            if(serialFD>0){
                [NSThread detachNewThreadSelector:@selector(readSerialData) toTarget:self withObject:nil];
                [self serialAlert:@"Open Serial Port Success!"];
                running = false;       
                if(type==TYPE_SERVER){
                    NSLog(@"[TYPE_SERVER]Open Serial Port Success! Work As Remote Server");
                    serialSocket = [[AsyncSocket alloc] initWithDelegate:self];
                    connectedClients = [[NSMutableArray alloc] initWithCapacity:1];
                }else{
                    NSLog(@"[TYPE_LOCAL]Open Serial Port Success!");
                }
            }else{
                [self serialAlert:@"Open Serial Port Failed!"];
                NSLog(@"Open Serial Port Failed!");
                [self release];
                self = nil;
            }
        }else if(type==TYPE_CLIENT){
            NSLog(@"Work As Remote Client");
            serialSocket = [[AsyncSocket alloc] initWithDelegate:self];
            connectedClients = [[NSMutableArray alloc] initWithCapacity:1];
            running = false;
        }else{
            NSLog(@"Invalid Mode");
            [self release];
            self = nil;
        }
    }
    return  self;
}

- (void)dealloc {
    close(serialFD);
    serialFD=-1;
    
    [self stop];
    [connectedClients release];
    [serialSocket release];
    [super dealloc];
}


#pragma Async Socket Delegate

- (void) startOnPort:(int)port;
{
    if (running) return;
    
    if (port < 0 || port > 65535)
        port = 0;
    
    NSError *error = nil;
    if (![serialSocket acceptOnPort:port error:&error])
        return;
    
    NSLog(@"My Awesome Serial Server has started on port %hu", [serialSocket localPort]);
    
    running = true;
}


- (void) stop;
{
    if (!running) return;
    
    [serialSocket disconnect];
    for (AsyncSocket* socket in connectedClients)
        [socket disconnect]; 
    
    running = false;
}

- (void)onSocket:(AsyncSocket *)socket didAcceptNewSocket:(AsyncSocket *)newSocket;
{
    [connectedClients addObject:newSocket];
}


- (void)onSocketDidDisconnect:(AsyncSocket *)socket;
{
    [connectedClients removeObject:socket];
    [self.delegate disconnectedWithPeer];
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);

}


- (void)normalConnectTo:(NSString*)host port:(int)port
{
	NSError *error = nil;
	
	//NSString *host = @"google.com";
    //	NSString *host = @"deusty.com";
	NSLog(@"normalConnectTo %@:%d",host,port);
	if (![serialSocket connectToHost:host onPort:port error:&error])
	{
		NSLog(@"Error connecting: %@", error);
	}
    
	// You can also specify an optional connect timeout.
	
    //if (![serialSocket connectToHost:host onPort:9999 withTimeout:5.0 error:&error])
    //{
    //    NSLog(@"Error connecting: %@", error);
    //}
}
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if(socketType==TYPE_SERVER){
        [self.delegate connectedWithPeer:true];
        NSLog(@"Accepted client %@:%hu", host, port);
        
//        NSData *welcomeData = [@"Welcome to my Awesome Debug Server\r\n" 
//                               dataUsingEncoding:NSUTF8StringEncoding];
//        [sock writeData:welcomeData withTimeout:-1 tag:WelcomeMsgTag];
        
        [sock readDataWithTimeout:-1 tag:GenericMsgTag];
    }else{
        [self.delegate connectedWithPeer:true];
        [sock readDataWithTimeout:-1 tag:GenericMsgTag];

        NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
        
        //	DDLogInfo(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
        
        if (port == 443)//Secure Conneections
        {
            
#if 0
            // Backgrounding doesn't seem to be supported on the simulator yet
            [sock performBlock:^{
                if ([sock enableBackgroundingOnSocketWithCaveat])
                    NSLog(@"Enabled backgrounding on socket");
                else
                    NSLog(@"Enabling backgrounding failed!");
            }];
            
#endif
            
            // Configure SSL/TLS settings
            NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
            
            // If you simply want to ensure that the remote host's certificate is valid,
            // then you can use an empty dictionary.
            
            // If you know the name of the remote host, then you should specify the name here.
            // 
            // NOTE:
            // You should understand the security implications if you do not specify the peer name.
            // Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
            
            [settings setObject:@"www.paypal.com"
                         forKey:(NSString *)kCFStreamSSLPeerName];
            
            // To connect to a test server, with a self-signed certificate, use settings similar to this:
            
            //	// Allow expired certificates
            //	[settings setObject:[NSNumber numberWithBool:YES]
            //				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
            //	
            //	// Allow self-signed certificates
            //	[settings setObject:[NSNumber numberWithBool:YES]
            //				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
            //	
            //	// In fact, don't even validate the certificate chain
            //	[settings setObject:[NSNumber numberWithBool:NO]
            //				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
            
            NSLog(@"Starting TLS with settings:\n%@", settings);
            
            [sock startTLS:settings];
            
            // You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
            // Again, you should understand the security implications of doing so.
            // Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
        }
    }
}

- (void)onSocket:(AsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag;
{
    int *serialData;
    serialData=(int*)[data bytes];
    
    if(socketType==TYPE_SERVER){
        NSLog(@"[TYPE_SERVER] Send Data over serial %x,%d",*serialData,[data length]);
        write(serialFD,serialData,sizeof(uint32_t));  // Write 32bit
    }else{
        NSLog(@"[TYPE_CLIENT] Send Data APP %x,%d",*serialData,[data length]);
        [self serialDataRecieved:[NSNumber numberWithUnsignedInt:*serialData]];
    }
    
    NSString *tmp = [NSString stringWithUTF8String:[data bytes]];
    NSString *input = [tmp stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([input isEqualToString:@"exit"])
    {
        NSData *byeData = [@"Bye!\r\n" dataUsingEncoding:NSUTF8StringEncoding];
        [socket writeData:byeData withTimeout:-1 tag:GenericMsgTag];
        [socket disconnectAfterWriting];
        return;
    }
    
    [socket readDataWithTimeout:-1 tag:GenericMsgTag];
}
- (void)socketDidDisconnect:(AsyncSocket *)sock withError:(NSError *)err
{
    [self.delegate disconnectedWithPeer];
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

@end
