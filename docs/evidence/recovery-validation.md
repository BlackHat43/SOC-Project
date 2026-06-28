# Recovery Validation

This document summarizes the disaster recovery validation performed in the SOC lab.

---

## Recovery Objective

The objective was to prove that important SOC-related configuration and evidence could be backed up, verified, and safely restored in a controlled test location.

---

## Backup Method

A compressed archive was created using Linux backup utilities.

The backup covered selected SOC lab configuration and supporting files, including Wazuh-related configuration, Docker Compose configuration, TheHive/Cortex-related configuration, and supporting lab files.

---

## Integrity Verification

A SHA-256 checksum was generated for the backup archive.

Verification command:

```bash
sha256sum -c soc_lab_backup_YYYY-MM-DD_HH-MM-SS.tar.gz.sha256
```

Expected result:

```text
soc_lab_backup_YYYY-MM-DD_HH-MM-SS.tar.gz: OK
```

---

## Safe Restore Test

The backup was extracted into a non-production test directory:

```text
/tmp/soc-restore-test
```

This avoided overwriting live configuration paths while still proving that files could be recovered.

---

## Result

The backup archive was created successfully, the SHA-256 checksum returned OK, and the archive was safely restored into the test directory.

The recovery validation was documented in TheHive comments as part of the incident response record.
