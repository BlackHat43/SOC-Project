# Implementation Evidence Notes

This document contains implementation details that are better represented as text instead of screenshots.

The public GitHub repository should not expose credentials, public IP addresses, internal URLs, tokens, generated access information, or raw infrastructure details.

---

## Wazuh and Endpoint Monitoring

Wazuh was deployed as the detection layer. A Kali Linux endpoint was enrolled as a monitored agent and validated as active from the Wazuh dashboard.

The endpoint was used to generate a controlled File Integrity Monitoring incident involving the file:

```text
critical_config.txt
```

The public repository includes Wazuh dashboard evidence, endpoint evidence, and FIM alert evidence. It does not include generated credentials or raw installation output.

---

## FIM Incident Commands

The FIM test was generated using the following controlled commands:

```bash
mkdir -p /home/kali/Desktop/Final/monitored

echo "Original secure configuration" > /home/kali/Desktop/Final/monitored/critical_config.txt

echo "UNAUTHORIZED CONFIG - simulated attacker modification" >> /home/kali/Desktop/Final/monitored/critical_config.txt

rm /home/kali/Desktop/Final/monitored/critical_config.txt
```

Expected detection result:

```text
Wazuh FIM generated alerts for:
- file added
- integrity checksum changed
- file deleted
```

---

## Docker-Based IR Stack

TheHive and Cortex were deployed using Docker Compose with supporting services.

Documented outcome:

```text
TheHive: running
Cortex: running
Cassandra: running
Elasticsearch: running
Nginx/reverse proxy: running
```

Raw screenshots containing ports, IP addresses, or internal infrastructure details should remain private.

---

## TheHive Case Management

The Wazuh FIM evidence was documented in TheHive as an incident response case.

The case included:

- incident summary
- severity and tags
- endpoint observable
- file path observable
- file name observable
- URL observable
- response tasks
- analyst comments
- enrichment and recovery notes

---

## Cortex Enrichment

Cortex was configured as the enrichment component.

The `UnshortenLink_1_2` analyzer was enabled and run against a URL observable. The analyzer job completed successfully and the result was documented in TheHive.

---

## Backup and Recovery Validation

Backup and recovery validation included:

1. Creating a compressed backup archive.
2. Generating a SHA-256 checksum file.
3. Verifying archive integrity.
4. Extracting the archive into a safe restore test directory.

Integrity check:

```bash
sha256sum -c soc_lab_backup_YYYY-MM-DD_HH-MM-SS.tar.gz.sha256
```

Expected result:

```text
soc_lab_backup_YYYY-MM-DD_HH-MM-SS.tar.gz: OK
```

Safe restore path:

```text
/tmp/soc-restore-test
```

---

## Autopsy DFIR Review

Autopsy was used to review collected SOC evidence as a logical files data source.

The DFIR review validated that:

- evidence folders were indexed
- the incident term `critical_config.txt` was searchable
- an HTML forensic report was generated

---

## Public Evidence Selection

The public evidence set contains 15 screenshots only:

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

All other screenshots should remain private unless they are redacted and have a clear portfolio value.
