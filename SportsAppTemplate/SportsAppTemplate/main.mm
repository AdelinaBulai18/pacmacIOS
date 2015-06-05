
//
//  main.m
//  SportsAppTemplate
//
//  Created by Brent Luehr on 2014-06-06.
//  Copyright (c) 2014 Just Be Friends Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#include "RegisterClasses.h"
//#include "RegisterMonoModules.h"
//#include "UnityInterface.h"

// Hack to work around iOS SDK 4.3 linker problem
// we need at least one __TEXT, __const section entry in main application .o files
// to get this section emitted at right time and so avoid LC_ENCRYPTION_INFO size miscalculation
//static const int constsection = 0;

//void UnityInitTrampoline();

int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        //UnityInitTrampoline();
        //if(!UnityParseCommandLine(argc, argv)) return -1;
        
        //RegisterMonoModules();
        //NSLog(@"-> registered mono modules %p\n", &constsection);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
