//
//  CKIAssignment.m
//  CanvasKit
//
//  Created by Jason Larsen on 8/22/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "CKIAssignment.h"
#import "CKIRubricCriterion.h"
#import "CKICourse.h"
#import "NSValueTransformer+CKIPredefinedTransformerAdditions.h"
#import "NSDictionary+DictionaryByAddingObjectsFromDictionary.h"
#import "CKISubmission.h"

@implementation CKIAssignment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyPaths = @{
        @"descriptionHTML": @"description",
        @"dueAt": @"due_at",
        @"lockAt": @"lock_at",
        @"unlockAt": @"unlock_at",
        @"courseID": @"course_id",
        @"htmlURL": @"html_url",
        @"allowedExtensions": @"allowed_extensions",
        @"assignmentGroupID": @"assignment_group_id",
        @"groupCategoryID": @"group_category_id",
        @"gradeGroupStudentsIndividually": @"grade_group_students_individually",
        @"needsGradingCount": @"needs_grading_count",
        @"peerReviews": @"peer_reviews",
        @"automaticPeerReviews": @"automatic_peer_reviews",
        @"peerReviewCount": @"peer_review_count",
        @"peerReviewsAssignAt": @"peer_reviews_assign_at",
        @"submissionTypes": @"submission_types",
        @"lockedForUser" : @"locked_for_user",
        @"pointsPossible" : @"points_possible",
        @"gradingType" : @"grading_type"
    };
    NSDictionary *superPaths = [super JSONKeyPathsByPropertyKey];
    return [superPaths dictionaryByAddingObjectsFromDictionary:keyPaths];
}

+ (NSValueTransformer *)dueAtJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKIDateTransformerName];
}

+ (NSValueTransformer *)lockAtJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKIDateTransformerName];
}

+ (NSValueTransformer *)unlockAtJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKIDateTransformerName];
}

+ (NSValueTransformer *)courseIDJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberStringTransformerName];
}

+ (NSValueTransformer *)htmlURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)assignmentGroupIDJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberStringTransformerName];
}

+ (NSValueTransformer *)groupCategoryIDJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:CKINumberStringTransformerName];
}

+ (NSValueTransformer *)peerReviewsAssignAtJSONTransformer {
    return [NSValueTransformer valueTransformerForName:CKIDateTransformerName];
}

+ (NSValueTransformer *)rubricJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CKIRubricCriterion class]];
}

+ (NSValueTransformer *)submissionJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[CKISubmission class]];
}

- (NSString *)path
{
    return [[[self.context path] stringByAppendingPathComponent:@"assignments"] stringByAppendingPathComponent:self.id];
}

- (CKIAssignmentScoringType)scoringType
{
    NSString *scoringTypeString = self.gradingType;
    if ([scoringTypeString isEqual:@"pass_fail"]) {
        return CKIAssignmentScoringTypePassFail;
    }
    else if ([scoringTypeString isEqual:@"percent"]) {
        return CKIAssignmentScoringTypePercentage;
    }
    else if ([scoringTypeString isEqual:@"letter_grade"]) {
        return CKIAssignmentScoringTypeLetter;
    }
    else if ([scoringTypeString isEqual:@"not_graded"]) {
        return CKIAssignmentScoringTypeNotGraded;
    }
    
    return CKIAssignmentScoringTypePoints;
}

@end
