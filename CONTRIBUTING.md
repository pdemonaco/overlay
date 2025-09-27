## Testing

From within the package directory:

```bash
pkgdev manifest -f && git add ./* && pkgcheck scan -p stable .
```

## Committing Changes

If everything looks good `pkgdev commit`
