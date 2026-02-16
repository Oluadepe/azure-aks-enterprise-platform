# Monitoring on AKS (Azure Monitor + Container Insights)

This project enables AKS monitoring via **Log Analytics Workspace** in Terraform.

## Verify Container Insights
1) Azure Portal → AKS → **Insights**
2) Confirm logs/metrics are flowing

## Useful KQL queries
### Pod restarts
```kusto
KubePodInventory
| where ClusterName == "<aks_cluster_name>"
| summarize Restarts=sum(RestartCount) by Namespace, Name
| order by Restarts desc
```

### Failed pods
```kusto
KubePodInventory
| where PodStatus in ("Failed", "Unknown")
| project TimeGenerated, Namespace, Name, PodStatus, Reason
| order by TimeGenerated desc
```

### Node CPU pressure signals
```kusto
InsightsMetrics
| where Name in ("cpuUsageNanoCores", "memoryWorkingSetBytes")
| summarize avg(Val) by Name, bin(TimeGenerated, 5m)
| render timechart
```

## Alerting (recommended)
Create alerts in Azure Monitor (Portal or IaC) for:
- Node CPU > 80% for 10 minutes
- Pod restart count > threshold
- Deployment unavailable replicas > 0

## Dashboard
Create an Azure Dashboard with tiles for:
- AKS Insights
- Log Analytics queries (KQL)
- Workbooks (Container Insights workbook)
