# Cloud Sandboxes

The lab defines the documented **basic examples** for all three cloud providers plus the multi-cloud credentials tab (Source: `/reference/sandbox/cloud/` and `/reference/sandbox/ui/cloud-credentials/`):

- `aws_account.lab` — region `us-east-1`, services `ec2`/`s3`, a `student` user with `AmazonEC2ReadOnlyAccess`
- `azure_subscription.lab` — region `westeurope`, `Microsoft.Compute`/`Microsoft.Storage`, a `student` Contributor
- `google_project.lab` — region `us-central1`, compute + storage APIs, a `student` editor
- `cloud_credentials.all-credentials` — the multi-cloud credentials tab

They are **disabled by default** (`variable.enable_cloud = false`) because they require cloud providers to be configured for your organization. To test them:

1. Set `enable_cloud`'s default to `true` in `variables.hcl`.
2. Add a tab targeting `resource.cloud_credentials.all-credentials` to a layout (the documented example is in `/reference/sandbox/ui/cloud-credentials/` — "Integration with Layout").
3. Push and restart the lab.

The same toggle pattern (a boolean variable driving `disabled`) is itself a documented example — see `/reference/types/variable/` ("Boolean Variable") and `/reference/types/resource/` ("Conditional Resource").
