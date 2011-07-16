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

// For more info
// GitHub
// http://devdot.wikispaces.com/Iphone+Serial+Port+Tutorial


#import <Foundation/Foundation.h>

#define TYPE_SERVER             0x01
#define TYPE_CLIENT             0x02
#define TYPE_LOCAL              0x03



@class AsyncSocket;

@protocol SerialCommunicationDelegate;

@interface SerialCommunication : NSObject {
    id <SerialCommunicationDelegate> delegate;
    int     serialFD;
    int     socketType;
    BOOL    isServing;
    
    AsyncSocket *serialSocket;
    NSMutableArray *connectedClients;
    bool running;
}
@property (nonatomic, assign) id <SerialCommunicationDelegate> delegate;
@property (readonly,getter=isRunning) bool running;
- (id)initWithType:(uint8_t)type;
- (void) startOnPort:(int)port;
- (void) stop;
- (BOOL)isDeviceConnected;
- (int)sendSerialData:(uint32_t)data;
- (void)normalConnectTo:(NSString*)host port:(int)port;
- (NSString *) wanAddress;
- (NSString *) wifiAddress;
@end

@protocol SerialCommunicationDelegate
-(void)serialDataRecieved:(int)data;
-(void)serialAlert:(NSString*)msg;
-(void)disconnectedWithPeer;
-(void)connectedWithPeer:(BOOL)result;
@end
