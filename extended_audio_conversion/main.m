//
//  main.m
//  extended_audio_conversion
//
//  Created by Panayotis Matsinopoulos on 12/6/21.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import <CoreAudioTypes/CoreAudioBaseTypes.h>
#import "AudioConverterSettings.h"
#import "OpenExtendedAudioFile.h"
#import "GetExtendedFileAudioStreamBasicDescription.h"
#import "InitializeOutputAudioFile.h"
#import "CheckError.h"
#import "NSPrint.h"
#import "PrintFileAudioInformation.h"

#define OUTPUT_FILE_NAME "output.caf"
#define OUTPUT_FILE_TYPE kAudioFileCAFType

void SetUpAudioDataSettingsForOutputFile (AudioConverterSettings *outAudioConverterSettings) {
  outAudioConverterSettings->outputFormat.mFormatID = kAudioFormatLinearPCM;
  outAudioConverterSettings->outputFormat.mSampleRate = outAudioConverterSettings->inputFormat.mSampleRate;
  outAudioConverterSettings->outputFormat.mChannelsPerFrame = outAudioConverterSettings->inputFormat.mChannelsPerFrame;
  
  if (outAudioConverterSettings->outputFormat.mFormatID == kAudioFormatLinearPCM) {
    // if the output format is PCM create a 16-bit int PCM file format description as an example
    outAudioConverterSettings->outputFormat.mBitsPerChannel = 16;
    outAudioConverterSettings->outputFormat.mBytesPerFrame = outAudioConverterSettings->outputFormat.mBitsPerChannel / 8 * outAudioConverterSettings->outputFormat.mChannelsPerFrame;
    outAudioConverterSettings->outputFormat.mFramesPerPacket = 1;
    outAudioConverterSettings->outputFormat.mBytesPerPacket = outAudioConverterSettings->outputFormat.mBytesPerFrame * outAudioConverterSettings->outputFormat.mFramesPerPacket;
    outAudioConverterSettings->outputFormat.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
  } else {
    NSException* exception = [NSException
            exceptionWithName:@"AudioFormatNotSupportedException"
            reason:@"Audio Format Not Supported"
            userInfo:nil];
    [exception raise];
  }
    
  return;
}

void SetConversionOutputFormat(ExtAudioFileRef iExtAudioFileRef, AudioStreamBasicDescription iConversionOutputFormat) {
  CheckError(ExtAudioFileSetProperty(iExtAudioFileRef,
                                     kExtAudioFileProperty_ClientDataFormat,
                                     sizeof(iConversionOutputFormat),
                                     &iConversionOutputFormat),
             "Setting conversion output format");
}

void Convert(AudioConverterSettings audioConverterSettings) {
  UInt32 outputBufferSize = audioConverterSettings.outputBufferSizeInPackets * audioConverterSettings.outputFormat.mBytesPerPacket;

  AudioBufferList convertedData;
  convertedData.mNumberBuffers = 1;
  convertedData.mBuffers[0].mNumberChannels = audioConverterSettings.outputFormat.mChannelsPerFrame;
  convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
  convertedData.mBuffers[0].mData = (UInt8 *)malloc(sizeof(UInt8) * outputBufferSize);
  SInt64 outputFilePacketPosition = 0;
  
  while(true) {
    UInt32 frameCount = audioConverterSettings.outputBufferSizeInPackets;
    CheckError(ExtAudioFileRead(audioConverterSettings.inputFile,
                                &frameCount,
                                &convertedData),
               "Reading data from input audio file and converting them to PCM");
    if (frameCount == 0) {
      free(convertedData.mBuffers[0].mData);
      return;
    }
    
    UInt32 packetsToWrite = frameCount; // since we are using uncompressed audio
    CheckError(AudioFileWritePackets(audioConverterSettings.outputFile,
                                     FALSE,
                                     packetsToWrite * audioConverterSettings.outputFormat.mBytesPerPacket,
                                     NULL,
                                     outputFilePacketPosition,
                                     &packetsToWrite,
                                     convertedData.mBuffers[0].mData),
               "Writing packets to output file");
    
    outputFilePacketPosition += packetsToWrite;
    memset(convertedData.mBuffers[0].mData, 0, outputBufferSize);
  }
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc < 3) {
      NSLog(@"1st argument: You need to give the input file for converting. You can use any Core Audio supported file such as .mp3, .aac, .m4a, .wav, .aif e.t.c.\n");
      NSLog(@"2nd argument: You need to give the size of the conversion output buffer in number of packets.\n");
      NSLog(@"Example: audio_conversion trixtor.mp3 10000\n");
      return 1;
    }

    AudioConverterSettings audioConverterSettings = {0};
    
    OpenExtendedAudioFile(argv[1], &audioConverterSettings.inputFile);
    
    GetExtendedFileAudioStreamBasicDescription(audioConverterSettings.inputFile, &audioConverterSettings.inputFormat);
    
    SetUpAudioDataSettingsForOutputFile(&audioConverterSettings);
    
    // The bigger the number of packets, the less the number of calls to +ExtAudioFileRead()+ and program runs faster.
    audioConverterSettings.outputBufferSizeInPackets = atoi(argv[2]);
    
    InitializeOutputAudioFile(audioConverterSettings.outputFormat, OUTPUT_FILE_NAME, OUTPUT_FILE_TYPE, "Initializing Output Audio File", &audioConverterSettings.outputFile);
    
    SetConversionOutputFormat(audioConverterSettings.inputFile, audioConverterSettings.outputFormat);
    
    Convert(audioConverterSettings);
    
    CheckError(AudioFileClose(audioConverterSettings.outputFile), "Closing output audio file");
    CheckError(ExtAudioFileDispose(audioConverterSettings.inputFile), "Closing input audio file");
    
    NSPrint(@"---- Output audio file info ----->\n");
    PrintFileAudioInformation(OUTPUT_FILE_NAME);
    NSPrint(@"--------------------------\n\n");
    
    NSPrint(@"...Bye!\n");
  }
  return 0;
}
