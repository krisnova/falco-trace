# Benchmarks Falco Nginx

```
docker run krisnova/falco-trace-benchmarksfalconginx:latest
```

|           | Control (30s)            | Sleep (30s)          | Nginx (30s)          |
|-----------|--------------------------|----------------------|----------------------|
| No Falco  | Simple Container         | Sleep                | Nginx                |
| Yes Falco | Simple Container + Falco | Sleep + Falco + pdig | Nginx + Falco + Pdig |

Runs `stress-ng` against various applications running with
and without pdig + Falco. 