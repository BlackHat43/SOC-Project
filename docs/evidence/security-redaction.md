# Security Redaction Policy

This repository is intended for public GitHub and LinkedIn portfolio use.

The project demonstrates SOC implementation capability without exposing sensitive lab data.

---

## Do Not Publish

The following items must not be uploaded to the public repository:

- generated credentials
- passwords
- API keys
- tokens
- public IP addresses
- internal service URLs
- AWS security group identifiers
- private hostnames
- raw terminal output containing sensitive environment details
- screenshots showing browser address bars with internal URLs

---

## Screenshot Selection Rule

A screenshot should be public only if it demonstrates one of these:

- architecture
- workflow
- detection
- active monitored endpoint
- confirmed FIM alert
- TheHive case management
- observables or tasks
- Cortex analyzer result
- recovery documentation
- Autopsy DFIR review

Screenshots showing installation logs, generated credentials, setup users, cloud firewall rules, or raw terminal commands should usually be documented as Markdown text instead.

---

## Public Screenshot Set

The approved public screenshot set contains 15 images:

```text
fig01_architecture.png
fig02_workflow.png
fig08_wazuh_overview_active.png
fig09_wazuh_endpoints_kali.png
fig13_wazuh_fim_3hits.png
fig22_thehive_case_success.png
fig23_thehive_observables.png
fig24_thehive_tasks.png
fig28_cortex_unshorten_enabled.png
fig29_cortex_jobs_history.png
fig30_cortex_job_details.png
fig32_thehive_both_comments.png
fig37_autopsy_filetree.png
fig38_autopsy_keyword.png
fig39_autopsy_report.png
```

All other screenshots should remain private unless they are redacted and provide clear portfolio value.
