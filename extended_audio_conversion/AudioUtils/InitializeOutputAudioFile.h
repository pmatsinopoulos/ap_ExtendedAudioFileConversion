//
//  InitializeOutputAudioFile.h
//  extended_audio_conversion
//
//  Created by Panayotis Matsinopoulos on 15/6/21.
//

#ifndef InitializeOutputAudioFile_h
#define InitializeOutputAudioFile_h
#import <AudioToolbox/AudioFile.h>

void InitializeOutputAudioFile (AudioStreamBasicDescription iAudioBasicStreamDescription,
                                const char *iFileName,
                                AudioFileTypeID iAudioFileTypeID,
                                const char *iMessage,
                                AudioFileID *oAudioFileID);

#endif /* InitializeOutputAudioFile_h */
