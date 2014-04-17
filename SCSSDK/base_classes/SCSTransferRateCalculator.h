//
//  SCSTransferRateCalculator.h
//  SCSDemoIOS
//
//  Created by Littlebox on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SCSUnitType {
    // Base Unit 1 Octet / 8 Bits
    SCSOctetUnit,
    // Base 2
    SCSKibibitUnit,
    SCSMebibitUnit,
    SCSGibibitUnit,
    SCSTebibitUnit,
    SCSPebibitUnit,
    // Base 10
    SCSKilobitUnit,
    SCSMegabitUnit,
    SCSGigabitUnit,
    SCSTerabitUnit,
    SCSPetabitUnit,
    // Base 2
    SCSKibibyteUnit,
    SCSMebibyteUnit,
    SCSGibibyteUnit,
    SCSTebibyteUnit,
    SCSPebibyteUnit,
    SCSExbibyteUnit,
    // Base 10
    SCSKilobyteUnit,
    SCSMegabyteUnit,
    SCSGigabyteUnit,
    SCSTerabyteUnit,
    SCSPetabyteUnit
} SCSUnitType;

typedef enum _SCSRateType {
    SCSPerMillisecondRate,
    SCSPerSecondRate,
    SCSPerMinuteRate,
    SCSPerHourRate,
    SCSPerDayRate
} SCSRateType;


/*!SCSTransferRateCalculator */
/*!The SCSTransferRateCalculator is a class for calculating the data transfer rate from the connection.
 */
@interface SCSTransferRateCalculator : NSObject {
    
    id _delegate;
    
    SCSUnitType _externalUnit;
    SCSRateType _externalRate;
    
    long long _objective; // In bytes
    NSDate *_startTime;
    
    long long _totalTransfered; // In bytes
    long long _pendingIncrease; // In bytes
    
    NSDate *_lastUpdateTime;
    
    NSTimer *_calculateTimer;
    NSTimeInterval _calculationRate;
    
    NSString *_calculatedTransferRate;
    NSString *_timeRemaining;
    
    BOOL _displayAverageRate;
}

/*!Initialize a new SCSTransferRateCalculator immediately after memory for it has been allocated.
 \returns The initialized SCSTransferRateCalculator.
 */
- (id)init;

/*!Get the delegate used to get the calculation result.
 \returns The delegate.
 */
- (id)delegate;

/*!Set the delegate used to get the calculation result.
 \param object The delegate.
 */
- (void)setDelegate:(id)object;

/*!Get the display unit.
 \returns The display unit.
 */
- (SCSUnitType)displayUnit;

/*!Set the display unit.
 \param displayUnit The display unit.
 */
- (void)setDisplayUnit:(SCSUnitType)displayUnit;

/*!Get the display rate type.
 \returns The display rate type.
 */
- (SCSRateType)displayRate;

/*!Set the display rate type.
 \param displayRate display rate type.
 */
- (void)setDisplayRate:(SCSRateType)displayRate;

/*!Set whether the calculate using average rate.
 \param yn YES or NO.
 */
- (void)setCalculateUsingAverageRate:(BOOL)yn;

/*!Get the objective size.
 \returns The objective size.
 */
- (long long)objective;

/*!Set the objective size.
 \param bytes The objective size.
 */
- (BOOL)setObjective:(long long)bytes;

/*!Get the total transfered size.
 \returns The total transfered size.
 */
- (long long)totalTransfered;

/*!Get whether the calculator is running.
 \returns The bool value of whether the calculator is running.
 */
- (BOOL)isRunning;

/*!Start the calculator for the delegate timer method updateRateVariables:.
 */
- (void)startTransferRateCalculator;

/*!Stop the calculator.
 */
- (void)stopTransferRateCalculator;

/*!Add bytes to the data size transfered.
 \param bytes Bytes to be added.
 */
- (void)addBytesTransfered:(long long)bytes;

- (NSString *)stringForCalculatedTransferRate;
- (NSString *)stringForShortDisplayUnit;
- (NSString *)stringForLongDisplayUnit;
- (NSString *)stringForShortRateUnit;
- (NSString *)stringForLongRateUnit;
- (NSString *)stringForEstimatedTimeRemaining;
- (NSString *)stringForObjectivePercentageCompleted;
- (float)floatForObjectivePercentageCompleted; // 0.0 - 1.0

@end

@interface NSObject (SCSTransferRateCalculatorDelegate)
- (void)pingFromTransferRateCalculator:(SCSTransferRateCalculator *)obj;
@end
