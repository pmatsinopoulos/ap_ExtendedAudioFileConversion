//
//  GetFileAudioStreamBasicDescription.m
//  extended_audio_conversion
//
//  Created by Panayotis Matsinopoulos on 15/6/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import <AudioToolbox/AudioFile.h>
#import "CheckError.h"

void GetExtendedFileAudioStreamBasicDescription(ExtAudioFileRef iExtAudioFileRef, AudioStreamBasicDescription *oAudioStreamBasicDescription) {
  UInt32 propertyValueSize = 0;
  Boolean writable = false;
  
  CheckError(ExtAudioFileGetPropertyInfo(iExtAudioFileRef,
                                         kExtAudioFileProperty_FileDataFormat,
                                         &propertyValueSize,
                                         &writable),
             "Getting the file data format property value size of audio file");
  
  CheckError(ExtAudioFileGetProperty(iExtAudioFileRef,
                                     kExtAudioFileProperty_FileDataFormat,
                                     &propertyValueSize,
                                     (void *)oAudioStreamBasicDescription),
             "Getting the value of the property file data format");
}
  
