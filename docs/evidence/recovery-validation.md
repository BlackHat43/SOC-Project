# Recovery Validation

This document summarizes the backup and restore validation completed in the SOC lab.

---

## Objective

Validate that important SOC lab configuration and evidence can be backed up, verified, and restored safely.

---

## Backup Method

A compressed archive was created from selected SOC lab configuration paths.

The backup process used:

```text
tar
gzip
sha256sum
```

---

## Integrity Check

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

## Restore Test

The archive was extracted into a safe test directory:

```text
/tmp/soc-restore-test
```

This validated recoverability without overwriting production paths.

---

## Result

The backup archive was created successfully, the SHA-256 checksum validated successfully, and the restore test confirmed that the archived files could be recovered.
