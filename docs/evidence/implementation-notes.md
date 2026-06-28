# Implementation Notes

This document summarizes implementation evidence that is clearer as text than as screenshots.

---

## Wazuh FIM Configuration

The monitored lab path was:

```text
/home/kali/Desktop/Final/monitored
```

The Wazuh FIM configuration sample is available in:

```text
configs/ossec-fim.xml
```

---

## FIM Test Commands

The incident was generated with a controlled file creation, modification, and deletion sequence.

```bash
mkdir -p /home/kali/Desktop/Final/monitored

echo "Original secure configuration" > /home/kali/Desktop/Final/monitored/critical_config.txt

echo "UNAUTHORIZED CONFIG - simulated attacker modification" >> /home/kali/Desktop/Final/monitored/critical_config.txt

rm /home/kali/Desktop/Final/monitored/critical_config.txt
```

Expected Wazuh result:

```text
file added
integrity checksum changed
file deleted
```

---

## Docker-Based IR Stack

TheHive and Cortex were deployed with supporting services using Docker Compose.

Validated service group:

```text
TheHive
Cortex
Cassandra
Elasticsearch
Nginx / reverse proxy
```

---

## TheHive Case Content

The incident case documented:

- case title and summary
- severity and tags
- endpoint observable
- affected file path
- affected filename
- URL observable for enrichment testing
- response tasks
- analyst comments
- recovery validation notes

---

## Cortex Enrichment

Cortex was configured as the enrichment component.

The `UnshortenLink_1_2` analyzer was enabled and executed against a URL observable. The analyzer job completed successfully and the output was documented in TheHive.

---

## Autopsy DFIR Review

Autopsy was used to review the collected SOC evidence as logical files.

The review confirmed that:

- evidence folders were indexed
- `critical_config.txt` was searchable
- an HTML forensic report was generated
