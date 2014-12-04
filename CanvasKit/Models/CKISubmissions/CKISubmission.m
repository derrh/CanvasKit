//
//  CKISubmission.m
//  CanvasKit
//
//  Created by Jason Larsen on 8/29/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "CKISubmission.h"
#import "CKISubmissionComment.h"
#import "NSValueTransformer+CKIPredefinedTransformerAdditions.h"
#import "NSDictionary+DictionaryByAddingObjectsFromDictionary.h"
#import "CKIAssignment.h"
#import "CKIFile.h"
#import "CKIMediaComment.h"
#import "CKIDiscussionEntry.h"

@interface CKISubmission ()

@property(nonatomic, readwrite) CKISubmissionEnumType type;

@end

NSString * const CKISubmissionTypeOnlineTextEntry = @"online_text_entry";
NSString * const CKISubmissionTypeOnlineURL = @"online_url";
NSString * const CKISubmissionTypeOnlineUpload = @"online_upload";
NSString * const CKISubmissionTypeMediaRecording = @"media_recording";
NSString * const CKISubmissionTypeQuiz = @"online_quiz";
NSString * const CKISubmissionTypeDiscussion = @"discussion_topic";
NSString * const CKISubmissionTypeExternalTool = @"external_tool";


@implementation CKISubmission

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"assignmentID": @"assignment_id",
        @"gradeMatchesCurrentSubmission": @"grade_matches_current_submission",
        @"htmlURL": @"html_url",
        @"previewURL": @"preview_url",
        @"submittedAt": @"submitted_at",
        @"submissionType": @"submission_type",
        @"userID": @"user_id",
        @"graderID": @"grader_id",
        @"discussionEntries": @"discussion_entries",
        @"mediaComment": @"media_comment"
    };
    NSDictionary *superPaths = [super JSONKeyPathsByPropertyKey];
    return [superPaths dictionaryByAddingObjectsFromDictionary:keyPaths];
}

+ (NSValueTransformer *)assignmentIDJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberStringTransformerName];
}

+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)htmlURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)previewURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)submittedAtJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKIDateTransformerName];
}

+ (NSValueTransformer *)userIDJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberStringTransformerName];
}

+ (NSValueTransformer *)graderIDJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberStringTransformerName];
}

+ (NSValueTransformer *)gradeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberOrStringToStringTransformerName];
}
+ (NSValueTransformer *)assignmentJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[CKIAssignment class]];
}
+ (NSValueTransformer *)attachmentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CKIFile class]];
}

+ (NSValueTransformer *)discussionEntriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CKIDiscussionEntry class]];
}

+ (NSValueTransformer *)mediaCommentJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[CKIMediaComment class]];
}

- (NSString *)path {
    return [[[self.context path] stringByAppendingPathComponent:@"submissions"] stringByAppendingPathComponent:self.userID];
}

- (void)setSubmissionType:(NSString *)submissionType {
    if (_submissionType == submissionType) {
        return;
    }
    
    _submissionType = submissionType;
    self.type = [self typeForSubmissionType:_submissionType];
}

- (CKISubmissionEnumType)typeForSubmissionType:(NSString *)submissionType {
    
    CKISubmissionEnumType type = CKISubmissionEnumTypeUnknown;
    if ([submissionType isEqualToString:CKISubmissionTypeOnlineUpload]) {
        type = CKISubmissionEnumTypeOnlineUpload;
    }
    else if ([submissionType isEqual:CKISubmissionTypeOnlineTextEntry]) {
        type = CKISubmissionEnumTypeOnlineTextEntry;
    }
    else if ([submissionType isEqual:CKISubmissionTypeOnlineURL]) {
        type = CKISubmissionEnumTypeOnlineURL;
    }
    else if ([submissionType isEqual:CKISubmissionTypeMediaRecording]) {
        type = CKISubmissionEnumTypeMediaRecording;
    }
    else if ([submissionType isEqual:CKISubmissionTypeQuiz]) {
        type = CKISubmissionEnumTypeQuiz;
    }
    else if ([submissionType isEqual:CKISubmissionTypeDiscussion]) {
        type = CKISubmissionEnumTypeDiscussion;
    }
    else if ([submissionType isEqual:CKISubmissionTypeExternalTool]) {
        type = CKISubmissionEnumTypeExternalTool;
    }
    return type;
}

@end
