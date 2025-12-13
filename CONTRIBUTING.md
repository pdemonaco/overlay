## Testing

From within the package directory:

```bash
pkgdev manifest -f -v && git add ./* && pkgcheck scan -p stable . && pkgdev commit
```

## Committing Changes

If everything looks good `pkgdev commit`
