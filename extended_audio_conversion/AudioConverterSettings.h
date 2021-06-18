//
//  AudioConverterSettings.h
//  extended_audio_conversion
//
//  Created by Panayotis Matsinopoulos on 14/6/21.
//

#ifndef AudioConverterSettings_h
#define AudioConverterSettings_h

#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/ExtendedAudioFile.h>

typedef struct AudioConverterSettings {
  AudioStreamBasicDescription outputFormat;
  AudioStreamBasicDescription inputFormat;
  ExtAudioFileRef             inputFile;
  AudioFileID                 outputFile;
  UInt32                      outputBufferSizeInPackets;
} AudioConverterSettings;

#endif /* AudioConverterSettings_h */
