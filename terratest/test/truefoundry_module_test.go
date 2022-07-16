package test

import (
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestTruefoundryModule(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples",
		//Vars: map[string]interface{}{
		//	"is_private": false,
		//},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	region := "eu-west-1"

	// Check MLFoundry Bucket
	mlfoundryBucketId := terraform.Output(t, terraformOptions, "mlfoundry_bucket_id")
	aws.AssertS3BucketExists(t, region, mlfoundryBucketId)
	aws.AssertS3BucketVersioningExists(t, region, mlfoundryBucketId)
	aws.AssertS3BucketPolicyExists(t, region, mlfoundryBucketId)

	// Check ServiceFoundry Bucket
	svcfoundryBucketId := terraform.Output(t, terraformOptions, "svcfoundry_bucket_id")
	aws.AssertS3BucketExists(t, region, svcfoundryBucketId)
	aws.AssertS3BucketVersioningExists(t, region, svcfoundryBucketId)
	aws.AssertS3BucketPolicyExists(t, region, svcfoundryBucketId)

	// Check Truefoundry RDS
	truefoundryDbID := terraform.Output(t, terraformOptions, "truefoundry_db_id")
	aws.GetAddressOfRdsInstance(t, truefoundryDbID, region)
}
