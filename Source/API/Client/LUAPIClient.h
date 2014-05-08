// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class LUAPIConnection;
@class LUAPIRequest;
@class LUAPIResponse;

typedef void (^LUAPISuccessBlock)(id result, LUAPIResponse *response);
typedef void (^LUAPIFailureBlock)(NSError *error);

/**
 `LUAPIClient` is used to perform requests to the LevelUp API.

 ## Setup

 Before using `LUAPIClient`, it must be set up with a valid API key. This is done with
 `setupWithAppID:APIKey:`.

 ## Issuing Requests

 The method `performRequest:success:failure:` is used to issue requests to the LevelUp's REST API.
 It performs these requests in the background, and then handles the responses. If the request is
 successful, the `success` block is called, passing in the result of the API call. If an error
 occurs, the `failure` block is called with an appropriate `NSError`.

 A API request is an instance of `LUAPIRequest` which has been generated using a request builder
 class. See the documentation for the request builder for information on specific API calls.

 ## Authentication

 When a user logs in, an access token is provided along with the user's ID. `LUAPIClient` needs to
 be given these values so that they can be included in API calls which require an authenticated
 user.

 The application is responsible for securely storing these values so that when the application
 launches, users will remain logged in. As part of launching your application, you may set these
 values using the `accessToken` and `currentUserID` properties.

 ## Errors

 When an API call fails, the `failure` block passed to `performRequest:success:failure:` will be
 called with an `NSError` object containing additional information about the error. This error will
 have the domain `LUAPIErrorDomain`.

 ### Codes

 See `LUAPIErrorCode` in LUConstants.h for a list of possible error codes.

 ### User Info

 The `userInfo` dictionary for this `NSError` has keys for several pieces of information:

 - `LUAPIErrorKeyAPIErrors`: An optional array of `LUAPIError` objects returned by the server.
 - `LUAPIErrorKeyErrorMessage`: An optional error message from the server. If multiple errors were
 returned, this will only contain the first message. `LUAPIErrorKeyAPIErrors` can be used to see all
 errors.
 - `LUAPIErrorKeyJSONResponse`: An optional JSON response from the server.
 - `LUAPIErrorKeyOriginalError`: If this error was generated from another `NSError`, it is included
 under this key.
 - `LUAPIErrorKeyURLResponse`: An `NSURLResponse` containing the response.

 ## Example

    LUAPIRequest *request = [LUUserRequestFactory requestForCurrentUser];
    [[LUAPIClient sharedClient] performRequest:request
                                       success:^(LUUser *user) {
                                         NSLog(@"The current user is %@", user);
                                       }
                                       failure:^(NSError *error) {
                                         NSLog(@"Got an error: %@", error);
                                       }];
 */

@interface LUAPIClient : NSObject

///-------------------------------
/// @name Configuration
///-------------------------------

/**
 Sets up the LevelUp SDK.

 This method must be called before performing any API requests.

 @param appID Your LevelUp App ID.
 @param apiKey Your LevelUp API key.
 */
+ (void)setupWithAppID:(NSString *)appID APIKey:(NSString *)apiKey;

/**
 Sets up the LevelUp SDK with the option of turning on development mode (internal use only).

 Using `setupWithAppID:APIKey:` is preferred, as development mode uses the LevelUp staging server
 which may not be up to date with all API keys, as well as periodic downtime or possible bugs.

 @param appID Your LevelUp App ID.
 @param apiKey Your LevelUp API key.
 @param developmentMode Specifies if requests should go to the development or production server.
 */
+ (void)setupWithAppID:(NSString *)appID APIKey:(NSString *)apiKey developmentMode:(BOOL)developmentMode;

/**
 The access token of an authenticated user.
 */
@property (copy) NSString *accessToken;

/**
 The user ID of the authenticated user.
 */
@property (copy) NSNumber *currentUserID;

@property (copy, readonly) NSString *apiKey;
@property (copy, readonly) NSString *appID;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, copy) NSString *clientsideEncryptionKey;
@property (assign, readonly) BOOL developmentMode;

///-------------------------------
/// @name Deep Link Auth Configuration
///-------------------------------

/**
 The bundle ID of the app to use for Deep Link Auth. Defaults to LevelUp's bundle ID.
 */
@property (copy) NSString *deepLinkAuthBundleID;

/**
 The URL of the App Store link used to direct the user to the App Store if LevelUp isn't installed.
 This URL can be generated at https://linkmaker.itunes.apple.com.

 The default value of this property is the URL to LevelUp on the App Store.
 */
@property (copy) NSURL *deepLinkAuthInstallAppStoreURL;

/**
 Used to override the default message of the alert shown when a user doesn't have LevelUp installed.
 */
@property (copy) NSString *deepLinkAuthInstallMessage;

/**
 Used to override the title of the negative button of the alert shown when a user doesn't have
 LevelUp installed. Tapping this button dismisses the alert.
 */
@property (copy) NSString *deepLinkAuthInstallNegativeButtonTitle;

/**
 Used to override the title of the positive button of the alert shown when a user doesn't have
 LevelUp installed. Tapping this button brings the user to the App Store.
 */
@property (copy) NSString *deepLinkAuthInstallPositiveButtonTitle;

/**
 Used to override the title of the alert shown when a user doesn't have LevelUp installed.
 */
@property (copy) NSString *deepLinkAuthInstallTitle;

/**
 When a Deep Link Auth request is made and the user doesn't have the LevelUp app installed, show
 an alert that directs the user to the App Store to download it. If set to `YES`, an alert view will
 automatically be shown, and an error notification will not be thrown. If set to `NO`, no alert is
 shown, and instead an error notification is sent with code `LUDeepLinkAuthErrorAppNotInstalled`.

 The default value of this property is `YES`.
 */
@property (assign) BOOL deepLinkAuthShowInstallAlert;

/**
 The URL scheme of the app to use for Deep Link Auth. Defaults to LevelUp's URL scheme.
 */
@property (copy) NSString *deepLinkAuthURLScheme;

///-------------------------------
/// @name Network Methods
///-------------------------------

/**
 Checks if the network is unreachable.

 @return `YES` if the network is unreachable, else `NO`.
*/
- (BOOL)isNetworkUnreachable;

/**
 Returns the `User-Agent` string containing the app name and version, device name and version and
 LevelUpSDK version.

 @return An `NSString` containing the `User-Agent` data.
 */
- (NSString *)userAgent;

///-------------------------------
/// @name Performing Requests
///-------------------------------

/**
 Returns the `LUAPIClient` singleton used to issue API requests.

 @return The shared `LUAPIClient` instance.

 @exception NSInternalInconsistencyException If this method is called before
 `setupWithAppID:APIKey:`.
 */
+ (LUAPIClient *)sharedClient;

/**
 Initiates a LevelUp API request.

 @param apiRequest The API request to perform. Request builders can be used to generate these
 objects.
 @param success A block to be called upon successful completion of the API request. This block takes
 a single argument, which is the result of the API call. The type of the object depends on the
 specific API request.
 @param failure A block to be called if the API call fails. This block takes a single argument,
 which is an `NSError` containing additional information about the error.

 @return An `LUAPIConnection` for the request.
 */
- (LUAPIConnection *)performRequest:(LUAPIRequest *)apiRequest
                            success:(LUAPISuccessBlock)success
                            failure:(LUAPIFailureBlock)failure;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters;

@end
