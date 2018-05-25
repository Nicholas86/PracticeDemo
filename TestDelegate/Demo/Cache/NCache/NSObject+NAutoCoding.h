//
//  NSObject+NAutoCoding.h
//  TestDelegate
//
//  Created by a on 2018/5/23.
//  Copyright © 2018年 a. All rights reserved.
//

// copy frome https://github.com/nicklockwood/AutoCoding
// 序列化 2.2

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NAutoCoding)<NSSecureCoding>
+ (NSDictionary<NSString *, Class> *)codableProperties;

/**
 * Populates the object's properties using the provided `NSCoder` object, based
 * on the `codableProperties` dictionary. This is called internally by the
 * `initWithCoder:` method, but may be useful if you wish to initialise an object
 * from a coded archive after it has already been created. You could even
 * initialise the object by merging the results of several different archives by
 * calling `setWithCoder:` more than once.
 */
- (void)setWithCoder:(NSCoder *)aDecoder;

/**
 * Returns all the codable properties of the object, including those that are
 * inherited from superclasses. You should not override this method - if you
 * want to add additional properties, override the `+codableProperties` class
 * method instead.
 */
@property (nonatomic, readonly) NSDictionary<NSString *, Class> *codableProperties;

/**
 * Returns a dictionary of the values of all the codable properties of the
 * object. It is equivalent to calling `dictionaryWithValuesForKeys:` with the
 * result of `object.codableProperties.allKeys` as the parameter.
 */
@property (nonatomic, readonly) NSDictionary<NSString *, id> *dictionaryRepresentation;

/**
 * Attempts to load the file using the following sequence: 1) If the file is an
 * NSCoded archive, load the root object and return it; 2) If the file is an
 * ordinary Plist, load and return the root object; 3) Return the raw data as an
 * `NSData` object. If the de-serialised object is not a subclass of the class
 * being used to load it, an exception will be thrown (to avoid this, call the
 * method on `NSObject` instead of a specific subclass).
 */
+ (nullable instancetype)objectWithContentsOfFile:(NSString *)path;

/**
 * Attempts to write the file to disk. This method is overridden by the
 * equivalent methods for `NSData`, `NSDictionary` and `NSArray`, which save the
 * file as a human-readable XML Plist rather than a binary NSCoded Plist archive,
 * but the `objectWithContentsOfFile:` method will correctly de-serialise these
 * again anyway. For any other object it will serialise the object using the
 * `NSCoding` protocol and write out the file as a NSCoded binary Plist archive.
 * Returns `YES` on success and `NO` on failure.
 */

- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;
@end

NS_ASSUME_NONNULL_END
