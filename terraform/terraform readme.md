# **Terraform Okta Service Account Management**

This directory contains Terraform configuration for managing Okta service accounts via Infrastructure as Code.

## **Prerequisites**

* Terraform \>= 1.6.0  
* Okta organization with admin access  
* Okta API token with appropriate permissions

## **Files**

* **main.tf** \- Main Terraform configuration defining Okta resources  
* **variables.tf** \- Input variable definitions  
* **outputs.tf** \- Output value definitions  
* **terraform.tfvars.example** \- Example configuration (copy to terraform.tfvars)

## **Local Setup**

### **1\. Install Terraform**

\# macOS  
brew install terraform

\# Linux  
wget https://releases.hashicorp.com/terraform/1.6.0/terraform\_1.6.0\_linux\_amd64.zip  
unzip terraform\_1.6.0\_linux\_amd64.zip  
sudo mv terraform /usr/local/bin/

\# Verify installation  
terraform version

### **2\. Configure Credentials**

\# Copy example file  
cp terraform.tfvars.example terraform.tfvars

\# Edit with your values  
nano terraform.tfvars

Fill in:

* `okta_org_name` \- Your Okta organization name  
* `okta_base_url` \- Usually "okta.com"  
* `okta_api_token` \- API token from Okta admin console

### **3\. Initialize Terraform**

terraform init

This downloads the Okta provider and prepares the working directory.

### **4\. Review Changes**

terraform plan

Review the resources that will be created.

### **5\. Apply Configuration**

terraform apply

Type `yes` to confirm and create the resources in Okta.

## **Resources Created**

This configuration creates:

1. **Service Accounts Group** \- "Service Accounts" group  
2. **Three Service Account Users:**  
   * API Service Account (`api-service@{org}.com`)  
   * Data Sync Service Account (`data-sync-service@{org}.com`)  
   * Monitoring Service Account (`monitoring-service@{org}.com`)  
3. **Group Memberships** \- All service accounts added to the group

## **GitHub Actions Integration**

This repository is configured with GitHub Actions for automated deployments:

* **Pull Requests** \- Automatically runs `terraform plan` and comments results  
* **Merge to Main** \- Automatically runs `terraform apply`  
* **Manual Triggers** \- Run plan, apply, or destroy manually

See `.github/workflows/terraform-okta.yml` for workflow details.

## **Adding New Service Accounts**

Create a new branch:

 git checkout \-b feature/add-reporting-service-account

1. 

Add to `main.tf`:

 resource "okta\_user" "reporting\_service\_account" {  
  first\_name \= "Reporting"  
  last\_name  \= "Service Account"  
  login      \= "reporting-service@${var.okta\_org\_name}.com"  
  email      \= "reporting-service@${var.okta\_org\_name}.com"  
  status     \= "ACTIVE"  
}

resource "okta\_group\_memberships" "reporting\_service\_membership" {  
  group\_id \= okta\_group.service\_accounts.id  
  users    \= \[okta\_user.reporting\_service\_account.id\]  
}

2. 

Commit and push:

 git add terraform/main.tf  
git commit \-m "Add reporting service account"  
git push origin feature/add-reporting-service-account

3.   
4. Create pull request on GitHub

5. Review the terraform plan in PR comments

6. Merge when approved \- GitHub Actions will apply automatically

## **Modifying Existing Service Accounts**

Edit the resource in `main.tf`, commit, and create a PR. The plan will show what will change.

## **Removing Service Accounts**

1. Delete the resource blocks from `main.tf`  
2. Create PR and review plan  
3. Merge \- the service accounts will be deleted from Okta

**⚠️ Warning:** This permanently deletes the users from Okta\!

## **Destroying All Resources**

**⚠️ Use with extreme caution\!**

### **Locally:**

terraform destroy

### **Via GitHub Actions:**

1. Go to Actions tab  
2. Select "Terraform Okta Management"  
3. Click "Run workflow"  
4. Select "destroy" action  
5. Confirm

This will delete all service accounts and the group.

## **Troubleshooting**

### **Error: "User already exists"**

* A user with that email already exists in Okta  
* Either delete the existing user or change the email in your config

### **Error: "Invalid API token"**

* Check your `terraform.tfvars` has the correct token  
* Verify the token hasn't expired  
* Ensure the token has appropriate permissions

### **Error: "Terraform init failed"**

* Check internet connection (needs to download providers)  
* Verify Terraform version is \>= 1.6.0

### **State File Issues**

* Never manually edit `.tfstate` files  
* Don't commit state files to git (already in `.gitignore`)  
* For team usage, consider remote state with S3 backend

## **Security Best Practices**

✅ **Do:**

* Use strong, unique API tokens  
* Rotate API tokens regularly (every 90 days)  
* Store credentials in GitHub Secrets (for CI/CD)  
* Use `.gitignore` to prevent committing secrets  
* Review all terraform plans before applying  
* Use branch protection and required reviews

❌ **Don't:**

* Commit `terraform.tfvars` to git  
* Share API tokens in chat/email  
* Use personal admin accounts for automation  
* Skip reviewing terraform plans  
* Apply changes directly to production without testing

## **Getting Okta API Token**

1. Log into Okta admin console  
2. Navigate to: **Security → API**  
3. Click **Tokens** tab  
4. Click **Create Token**  
5. Give it a descriptive name (e.g., "Terraform Automation")  
6. Copy the token immediately (you won't see it again\!)  
7. Save to `terraform.tfvars`

## **Support**

* Terraform Okta Provider Docs: https://registry.terraform.io/providers/okta/okta/latest/docs  
* Okta API Documentation: https://developer.okta.com/docs/reference/  
* Terraform Documentation: https://www.terraform.io/docs

