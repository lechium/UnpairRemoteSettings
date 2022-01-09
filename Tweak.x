#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TVSPeripheralManager: NSObject
+(id)sharedInstance;
-(void)unpairPeripheral:(id)arg1;
-(NSArray *)pairedPeripherals;
-(NSArray *)connectedPeripherals;
@end

@interface TVSBluetoothManager : NSObject 
+(id)sharedInstance;
-(void)unpairDevice:(id)arg1;
@end

@interface TVSBluetoothDevice: NSObject
-(NSString*)identifier;
@end

@interface TVSettingsBluetoothInfoViewController : UIViewController
- (id)_bluetoothDevice;
- (id)bluetoothDevice; //tvOS 9 not sure if any newer versions have this var
@end
%hook TVSettingsBluetoothInfoViewController

%new - (void)unpairRemote:(id)sender {
    %log;
    //id btMan = [%c(TVSBluetoothManager) sharedInstance];
    id pMan = [%c(TVSPeripheralManager) sharedInstance];
    id btDevice = nil;
    if ([self respondsToSelector:@selector(bluetoothDevice)]){
        btDevice = [self bluetoothDevice];
    } else { //should just be _bluetoothDevice instead for other cases        
        btDevice = [self _bluetoothDevice];
    }
    NSArray *pairedPeriph = [pMan pairedPeripherals];
    HBLogDebug(@"paired: %@", pairedPeriph);
    NSUUID *identifier = [[NSUUID alloc] initWithUUIDString: [btDevice identifier]];
    HBLogDebug(@"bt device: %@", btDevice);
    id paired = [[pairedPeriph filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@",identifier]] lastObject];
    HBLogDebug(@"found paired peripheral: %@", paired);
    if (paired){
        [pMan unpairPeripheral:paired];
        [[self navigationController] popViewControllerAnimated:true];
    }
    
    //[btMan unpairDevice:btDevice];
}

- (void)viewDidLoad {
    %log;
    %orig;
    UIButton *unpairRemoteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    unpairRemoteButton.translatesAutoresizingMaskIntoConstraints = false;
    [unpairRemoteButton setTitle:@"Unpair Remote" forState:UIControlStateNormal];
    [[self view] addSubview:unpairRemoteButton];
    [unpairRemoteButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-300].active = true;
    [unpairRemoteButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-260].active = true;
    [unpairRemoteButton addTarget:self action:@selector(unpairRemote:) forControlEvents:UIControlEventPrimaryActionTriggered];
}

%end
