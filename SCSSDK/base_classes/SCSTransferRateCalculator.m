//
//  SCSTransferRateCalculator.m
//  SCSDemoIOS
//
//  Created by Littlebox on 14-4-1.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "SCSTransferRateCalculator.h"

// Octet is the base unit
#define SCSOctetUnitValue 1

// Units are expressed around base 2 values
// 1 Kibibit == 1024 bits == 128 Octets
#define SCSKibibitUnitValue 128LL
#define SCSMebibitUnitValue 131072LL
#define SCSGibibitUnitValue 134217728LL
#define SCSTebibitUnitValue 137438953472LL
#define SCSPebibitUnitValue 140737488355328LL

// Units are expressed around base 10 values
// 1 Kilobit == 1000 bits == 125 Octets
#define SCSKilobitUnitValue 125LL
#define SCSMegabitUnitValue 125000LL
#define SCSGigabitUnitValue 125000000LL
#define SCSTerabitUnitValue 125000000000LL
#define SCSPetabitUnitValue 125000000000000LL

// Units are expressed around base 2 values
// 1 Kibibyte == 1024 octets (bytes)
#define SCSKibibyteUnitValue 1024LL
#define SCSMebibyteUnitValue 1048576LL
#define SCSGibibyteUnitValue 1073741824LL
#define SCSTebibyteUnitValue 1099511627776LL
#define SCSPebibyteUnitValue 1125899906842624LL

// Units are expressed around base 10 values
// 1 Kilobyte == 8000 bits
#define SCSKilobyteUnitValue 1000LL
#define SCSMegabyteUnitValue 1000000LL
#define SCSGigabyteUnitValue 1000000000LL
#define SCSTerabyteUnitValue 1000000000000LL
#define SCSPetabyteUnitValue 1000000000000000LL

// Millisecond is the base unit
#define SCSPerMillisecondRateValue 1
#define SCSPerSecondRateValue      1000
#define SCSPerMinuteRateValue      60000
#define SCSPerHourRateValue        3600000
#define SCSPerDayRateValue         86400000


@interface SCSTransferRateCalculator (PrivateAPI)
- (void)resetTransferRateCalculator;
- (void)updateRateVariables:(NSTimer *)timer;
- (long long)valueForS3UnitType:(SCSUnitType)unitType;
- (long long)valueForS3RateType:(SCSRateType)rateType;
@end

@implementation SCSTransferRateCalculator

+ (BOOL)accessInstanceVariablesDirectly
{
	return NO;
}

- (id)init
{
	[super init];
	_displayAverageRate = YES;
	_externalUnit = SCSKibibyteUnit;
	_externalRate = SCSPerSecondRate;
	_calculationRate = 1.0;
	_calculatedTransferRate = nil;
	_timeRemaining = nil;
	return self;
}

- (void)dealloc
{
	[self stopTransferRateCalculator];
	[_startTime release];
	[_lastUpdateTime release];
	[super dealloc];
}

- (id)delegate
{
    return _delegate;
}

- (void)setDelegate:(id)object
{
    _delegate = object;
}

- (SCSUnitType)displayUnit
{
	return _externalUnit;
}

- (void)setDisplayUnit:(SCSUnitType)displayUnit
{
	_externalUnit = displayUnit;
}

- (SCSRateType)displayRate
{
	return _externalRate;
}

- (void)setDisplayRate:(SCSRateType)displayRate
{
	_externalRate = displayRate;
}

- (void)setCalculateUsingAverageRate:(BOOL)yn
{
    _displayAverageRate = yn;
}

- (long long)valueForS3UnitType:(SCSUnitType)unitType
{
	switch (unitType) {
		case SCSOctetUnit:
			return SCSOctetUnitValue;
			break;
        case SCSKibibitUnit:
            return SCSKibibitUnitValue;
            break;
        case SCSMebibitUnit:
            return SCSMebibitUnitValue;
            break;
        case SCSGibibitUnit:
            return SCSGibibitUnitValue;
            break;
        case SCSTebibitUnit:
            return SCSTebibitUnitValue;
            break;
        case SCSPebibitUnit:
            return SCSPebibitUnitValue;
            break;
        case SCSKilobitUnit:
            return SCSKilobitUnitValue;
            break;
        case SCSMegabitUnit:
            return SCSMegabitUnitValue;
            break;
        case SCSGigabitUnit:
            return SCSGigabitUnitValue;
            break;
        case SCSTerabitUnit:
            return SCSTerabitUnitValue;
            break;
        case SCSPetabitUnit:
            return SCSPetabitUnitValue;
            break;
		case SCSKibibyteUnit:
			return SCSKibibyteUnitValue;
			break;
		case SCSMebibyteUnit:
			return SCSMebibyteUnitValue;
			break;
		case SCSGibibyteUnit:
			return SCSGibibyteUnitValue;
			break;
		case SCSTebibyteUnit:
			return SCSTebibyteUnitValue;
			break;
		case SCSPebibyteUnit:
			return SCSPebibyteUnitValue;
			break;
		case SCSKilobyteUnit:
			return SCSKilobyteUnitValue;
			break;
		case SCSMegabyteUnit:
			return SCSMegabyteUnitValue;
			break;
		case SCSGigabyteUnit:
			return SCSGigabyteUnitValue;
			break;
		case SCSTerabyteUnit:
			return SCSTerabyteUnitValue;
			break;
		case SCSPetabyteUnit:
			return SCSPetabyteUnitValue;
			break;
		default:
			return 0;
	}
}

- (long long)valueForS3RateType:(SCSRateType)rateType
{
	switch (rateType) {
		case SCSPerMillisecondRate:
			return SCSPerMillisecondRateValue;
			break;
		case SCSPerSecondRate:
			return SCSPerSecondRateValue;
			break;
		case SCSPerMinuteRate:
			return SCSPerMinuteRateValue;
			break;
		case SCSPerHourRate:
			return SCSPerHourRateValue;
			break;
		case SCSPerDayRate:
			return SCSPerDayRateValue;
			break;
		default:
			return 0;
	}
}

- (long long)objective
{
	return _objective;
}

- (BOOL)setObjective:(long long)bytes
{
    if ([self isRunning] == YES) {
        return NO;
    }
	if (bytes < 0) {
		_objective = 0;
		return NO;
	}
	_objective = bytes;
	return YES;
}

- (long long)totalTransfered
{
	return _totalTransfered;
}

- (BOOL)isRunning
{
	if (_calculateTimer == nil) {
		return NO;
	}
	return YES;
}

- (void)startTransferRateCalculator
{
    if ([self isRunning] == YES) {
        [self stopTransferRateCalculator];
        _totalTransfered = 0;
    }
	_calculateTimer = [NSTimer scheduledTimerWithTimeInterval:_calculationRate target:self selector:@selector(updateRateVariables:) userInfo:nil repeats:YES];
	[_calculateTimer retain];
	if (_startTime == nil) {
		_startTime = [[NSDate alloc] init];
	}
}

- (void)stopTransferRateCalculator
{
	[_calculateTimer invalidate];
	[_calculateTimer release];
	_calculateTimer = nil;
	[_startTime release];
	_startTime = nil;
}

- (void)addBytesTransfered:(long long)bytes
{
	if ([self isRunning] == NO) {
		return;
	}
	long long left = LLONG_MAX - _totalTransfered;
	if (bytes < 0 || bytes > left) {
		// No room left
		return;
	}
	_pendingIncrease += bytes;
}

- (void)updateRateVariables:(NSTimer *)timer
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(pingFromTransferRateCalculator:)]) {
        [[self delegate] pingFromTransferRateCalculator:self];
    }
	[_calculatedTransferRate release];
	_calculatedTransferRate = nil;
	if (_displayAverageRate == NO && _pendingIncrease > 0) {
		_calculatedTransferRate = [[NSString alloc] initWithFormat:@"%.2f", ((float)(_pendingIncrease) / [self valueForS3UnitType:_externalUnit]) / (([[NSDate date] timeIntervalSinceDate:_lastUpdateTime] * 1000.0) / [self valueForS3RateType:_externalRate])];
	}
	[_timeRemaining release];
	_timeRemaining = nil;
	if (_objective > 0 && _totalTransfered > 0) {
		//
		NSTimeInterval estimatedSeconds = (_objective - _totalTransfered) / (_totalTransfered / [_lastUpdateTime timeIntervalSinceDate:_startTime]);
		int days = estimatedSeconds / 86400;
		estimatedSeconds = estimatedSeconds - (days * 86400);
		int hours = estimatedSeconds / 3600;
		estimatedSeconds = estimatedSeconds - (hours * 3600);
		int minutes = estimatedSeconds / 60;
		estimatedSeconds = estimatedSeconds - (minutes * 60);
		int seconds = estimatedSeconds - 0;
		NSMutableString *timeRemaining = [NSMutableString string];
		if (days > 0) {
			[timeRemaining appendFormat:@"%d ", days];
			if (days == 1) {
				[timeRemaining appendFormat:@"day"];
			} else {
				[timeRemaining appendFormat:@"days"];
			}
            if (hours > 0 || minutes > 0 || seconds > 0) {
                [timeRemaining appendString:@" "];
            }
		}
        if (hours > 0) {
            if (hours < 10) {
                [timeRemaining appendFormat:@"%dh:", hours];
            } else {
                [timeRemaining appendFormat:@"%.2dh:", hours];
            }
        }
        if (hours > 0 || minutes > 0) {
            if (hours == 0 && minutes < 10) {
                [timeRemaining appendFormat:@"%dm:", minutes];
            } else {
                [timeRemaining appendFormat:@"%.2dm:", minutes];
            }
        }
        if (hours > 0 || minutes > 0 || seconds > 0) {
            if (hours == 0 && minutes == 0 && seconds < 10) {
                [timeRemaining appendFormat:@"%ds", seconds];
            } else {
                [timeRemaining appendFormat:@"%.2ds", seconds];
            }
        }
		_timeRemaining = [[NSString alloc] initWithString:timeRemaining];
	} else {
		_timeRemaining = nil;
	}
	
	_totalTransfered += _pendingIncrease;
	_pendingIncrease = 0;
	[_lastUpdateTime autorelease];
	_lastUpdateTime = [[NSDate alloc] init];
    
	if (_displayAverageRate == YES && _totalTransfered > 0) {
		_calculatedTransferRate = [[NSString alloc] initWithFormat:@"%.2f", ((float)(_totalTransfered) / [self valueForS3UnitType:_externalUnit]) / (([_lastUpdateTime timeIntervalSinceDate:_startTime] * 1000.0) / [self valueForS3RateType:_externalRate])];
	}
}

- (NSString *)stringForCalculatedTransferRate
{
	return _calculatedTransferRate;
}

- (NSString *)stringForShortDisplayUnit
{
    switch (_externalUnit) {
		case SCSOctetUnit:
			return @"oct";
			break;
        case SCSKibibitUnit:
            return @"Kibit";
            break;
        case SCSMebibitUnit:
            return @"Mibit";
            break;
        case SCSGibibitUnit:
            return @"Gibit";
            break;
        case SCSTebibitUnit:
            return @"Tibit";
            break;
        case SCSPebibitUnit:
            return @"Pibit";
            break;
        case SCSKilobitUnit:
            return @"kb";
            break;
        case SCSMegabitUnit:
            return @"Mb";
            break;
        case SCSGigabitUnit:
            return @"Gb";
            break;
        case SCSTerabitUnit:
            return @"Tb";
            break;
        case SCSPetabitUnit:
            return @"Pb";
            break;
		case SCSKibibyteUnit:
			return @"KiB";
			break;
		case SCSMebibyteUnit:
			return @"MiB";
			break;
		case SCSGibibyteUnit:
			return @"GiB";
			break;
		case SCSTebibyteUnit:
			return @"TiB";
			break;
		case SCSPebibyteUnit:
			return @"PiB";
			break;
		case SCSKilobyteUnit:
			return @"kB";
			break;
		case SCSMegabyteUnit:
			return @"MB";
			break;
		case SCSGigabyteUnit:
			return @"GB";
			break;
		case SCSTerabyteUnit:
			return @"TB";
			break;
		case SCSPetabyteUnit:
			return @"PB";
			break;
		default:
            return @"?";
	}
}

- (NSString *)stringForLongDisplayUnit
{
    switch (_externalUnit) {
		case SCSOctetUnit:
			return @"octet";
			break;
        case SCSKibibitUnit:
            return @"kibibit";
            break;
        case SCSMebibitUnit:
            return @"Mebibit";
            break;
        case SCSGibibitUnit:
            return @"Gibibit";
            break;
        case SCSTebibitUnit:
            return @"Tebibit";
            break;
        case SCSPebibitUnit:
            return @"Pebibit";
            break;
        case SCSKilobitUnit:
            return @"kilobit";
            break;
        case SCSMegabitUnit:
            return @"megabit";
            break;
        case SCSGigabitUnit:
            return @"gigabit";
            break;
        case SCSTerabitUnit:
            return @"terabit";
            break;
        case SCSPetabitUnit:
            return @"petabit";
            break;
		case SCSKibibyteUnit:
			return @"kibibyte";
			break;
		case SCSMebibyteUnit:
			return @"mebibyte";
			break;
		case SCSGibibyteUnit:
			return @"gibibyte";
			break;
		case SCSTebibyteUnit:
			return @"tebibyte";
			break;
		case SCSPebibyteUnit:
			return @"pebibyte";
			break;
		case SCSKilobyteUnit:
			return @"kilobyte";
			break;
		case SCSMegabyteUnit:
			return @"megabyte";
			break;
		case SCSGigabyteUnit:
			return @"gigabyte";
			break;
		case SCSTerabyteUnit:
			return @"terabyte";
			break;
		case SCSPetabyteUnit:
			return @"petabyte";
			break;
		default:
            return @"?";
	}
}

- (NSString *)stringForShortRateUnit
{
    switch (_externalRate) {
		case SCSPerMillisecondRate:
			return @"ms";
			break;
		case SCSPerSecondRate:
			return @"sec";
			break;
		case SCSPerMinuteRate:
			return @"min";
			break;
		case SCSPerHourRate:
			return @"hr";
			break;
		case SCSPerDayRate:
			return @"d";
			break;
		default:
            return @"?";
	}
}

- (NSString *)stringForLongRateUnit
{
    switch (_externalRate) {
		case SCSPerMillisecondRate:
			return @"millisecond";
			break;
		case SCSPerSecondRate:
			return @"second";
			break;
		case SCSPerMinuteRate:
			return @"minute";
			break;
		case SCSPerHourRate:
			return @"hour";
			break;
		case SCSPerDayRate:
			return @"day";
			break;
		default:
            return @"?";
	}
}

- (NSString *)stringForEstimatedTimeRemaining
{
	return _timeRemaining;
}

- (NSString *)stringForObjectivePercentageCompleted
{
    if (_objective == 0) {
        return nil;
    }
	return [NSString stringWithFormat:@"%.2f", ([self floatForObjectivePercentageCompleted]*100)];
}

- (float)floatForObjectivePercentageCompleted
{
	if (_totalTransfered == 0 || _objective == 0) {
		return 0.0;
	}
	return (_totalTransfered * 1.0) / _objective;
}

@end
