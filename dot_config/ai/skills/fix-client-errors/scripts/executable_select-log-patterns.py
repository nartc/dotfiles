#!/usr/bin/env python3
"""Derive client-error log search patterns from selected containers."""

from __future__ import annotations

import argparse
import json
import sys


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Return built-in Grafana log search patterns for selected containers."
    )
    parser.add_argument(
        "--containers",
        required=True,
        help="Comma-separated container names selected by the user.",
    )
    args = parser.parse_args()

    containers = [item.strip() for item in args.containers.split(",") if item.strip()]
    if not containers:
        print("no containers provided", file=sys.stderr)
        return 2

    searches: list[dict[str, str]] = []
    for container in containers:
        lowered = container.lower()
        if "polygraph" in lowered:
            searches.append(
                {
                    "container": container,
                    "pattern": "client-errors",
                    "reason": "polygraph client error endpoint/log marker",
                }
            )
        if "nx-api" in lowered:
            searches.append(
                {
                    "container": container,
                    "pattern": "nx-cloud/report-client-error",
                    "reason": "nx-api client error reporting endpoint",
                }
            )

    output = {
        "containers": containers,
        "searches": searches,
        "has_builtin_searches": bool(searches),
    }
    print(json.dumps(output, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
