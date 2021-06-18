//
//  GetFileAudioStreamBasicDescription.h
//  extended_audio_conversion
//
//  Created by Panayotis Matsinopoulos on 15/6/21.
//

#ifndef GetFileAudioStreamBasicDescription_h
#define GetFileAudioStreamBasicDescription_h
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import <AudioToolbox/ExtendedAudioFile.h>

void GetExtendedFileAudioStreamBasicDescription(ExtAudioFileRef iExtAudioFileRef, AudioStreamBasicDescription *oAudioStreamBasicDescription);

#endif /* GetFileAudioStreamBasicDescription_h */
