//
//  SHICMacro.h
//  IntergratedCertification
//
//  Created by 두베아이맥 on 2018. 2. 7..
//
//

#ifndef SHICMacro_h
#define SHICMacro_h

//숫자를 문자열로 변환
#define _NUM_TO_STR(num) #num
#define NUM_TO_STR(num) _NUM_TO_STR(num)

//
#define HOGE(a) tes##a
//
#define Prefix(str) @"Prefix" str

#define PREPARE_SELF __weak typeof(self) SELF = self
/*
 PREPARE_SELF;
 [self doSomethingWithBlock:^{
 [SELF showAlert];
 }];
 */

#define ME [self class]
//[ME classMethod];



#endif /* SHICMacro_h */
