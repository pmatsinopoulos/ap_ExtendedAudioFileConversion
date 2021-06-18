//
//  OpenExtendedAudioFile.m
//  extended_audio_conversion
//
//  Created by Panayotis Matsinopoulos on 14/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import "CheckError.h"
#import "CharPointerFilenameToNSURLp.h"

void OpenExtendedAudioFile(const char *iFileName, ExtAudioFileRef *oExtAudioFileRef) {
  CheckError(ExtAudioFileOpenURL((__bridge CFURLRef) CharPointerFilenameToNSURLp(iFileName),
                                 oExtAudioFileRef),
             "Opening the audio file");
}
