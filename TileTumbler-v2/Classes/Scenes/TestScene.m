//
//  TestScene.m
//  TileTumbler-v2
//
//  Created by Ronan Turner on 23/08/2014.
//  Copyright 2014 Ronan Turner. All rights reserved.
//

#import "TestScene.h"

@implementation TestScene

+(TestScene *) scene
{
	return [[self alloc] init];
}

-(id) init {
  self = [super init];
  if (!self) return(nil);
  
  self.contentSize = [CCDirector sharedDirector].viewSize;
  
  [self createBackground];
  
  return self;
}

-(void) createBackground {
  
  CGSize size = [CCDirector sharedDirector].viewSize;
  
  _background = [CCDrawNode node];
  
  /* Draw fill */
  CGPoint *verts = malloc(sizeof(CGPoint)*4);
  
  verts[0] = ccp(0,0);
  verts[1] = ccp(0,size.height);
  verts[2] = ccp(size.width,size.height);
  verts[3] = ccp(size.width,0);
  
  [_background drawPolyWithVerts:verts count:4 fillColor:[CCColor colorWithCcColor3b:ccBLACK] borderWidth:1 borderColor:[CCColor colorWithCcColor3b:ccWHITE]];
  
  [self addChild:_background z:0];
}

@end