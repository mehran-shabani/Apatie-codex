#!/usr/bin/env python3
"""Utility for translating Flutter integration test performance metrics.

The script extracts the `binding.reportData` payload emitted by the
performance integration tests and converts it into a concise summary that can
be published by CI. The input is expected to be the JSON log produced by
`flutter test --machine`, but plain-text logs containing a line that begins
with `PERFORMANCE_METRICS:` are also supported.
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Iterable, Tuple

_METRICS_SENTINEL = "PERFORMANCE_METRICS:"

BUDGETS: Dict[str, Dict[str, float]] = {
    "startup": {
        "first_frame_build_millis": 180.0,
        "first_frame_raster_millis": 180.0,
    },
    "scroll": {
        "average_build_millis": 24.0,
        "average_raster_millis": 28.0,
        "janky_frame_percentage": 20.0,
    },
    "memory": {
        "heap_usage_mb": 256.0,
        "external_usage_mb": 128.0,
    },
}


@dataclass
class MetricStatus:
    """Represents a single metric and its evaluation."""

    name: str
    value: float | None
    budget: float | None

    @property
    def passed(self) -> bool | None:
        if self.value is None or self.budget is None:
            return None
        return self.value <= self.budget

    def to_row(self) -> Tuple[str, str, str, str]:
        formatted_value = "n/a" if self.value is None else f"{self.value:.2f}"
        formatted_budget = "n/a" if self.budget is None else f"{self.budget:.2f}"
        if self.passed is None:
            status = "UNKNOWN"
            emoji = "⚪"
        elif self.passed:
            status = "PASS"
            emoji = "✅"
        else:
            status = "FAIL"
            emoji = "❌"
        return (self.name, formatted_value, formatted_budget, f"{emoji} {status}")


def _load_lines(path: Path) -> Iterable[str]:
    with path.open(encoding="utf-8") as handle:
        for line in handle:
            yield line.rstrip("\n")


def _try_decode_json(text: str) -> Dict[str, Any] | None:
    try:
        data = json.loads(text)
    except json.JSONDecodeError:
        return None
    if isinstance(data, dict):
        return data
    return None


def _extract_metrics_from_message(message: str) -> Dict[str, Any] | None:
    sentinel_index = message.find(_METRICS_SENTINEL)
    if sentinel_index == -1:
        return None
    payload = message[sentinel_index + len(_METRICS_SENTINEL) :].strip()
    if not payload:
        return None
    metrics = _try_decode_json(payload)
    if metrics is not None:
        return metrics
    # Some CI logs escape the JSON payload – attempt a secondary decode.
    try:
        unescaped = bytes(payload, "utf-8").decode("unicode_escape")
    except UnicodeDecodeError:
        return None
    return _try_decode_json(unescaped)


def load_metrics(path: Path) -> Dict[str, Any]:
    """Parse the Flutter test log and extract the performance metrics."""

    for raw_line in _load_lines(path):
        metrics = _extract_metrics_from_message(raw_line)
        if metrics is not None:
            return metrics
        parsed_line = _try_decode_json(raw_line)
        if not parsed_line:
            continue
        message = parsed_line.get("message")
        if isinstance(message, str):
            metrics = _extract_metrics_from_message(message)
            if metrics is not None:
                return metrics
    raise RuntimeError(
        "No performance metrics were found. Ensure the integration tests "
        "printed a PERFORMANCE_METRICS line and the log was captured correctly.",
    )


def build_status(metrics: Dict[str, Any]) -> Dict[str, Tuple[str, ...]]:
    summary: Dict[str, Tuple[str, ...]] = {}
    for category, category_metrics in metrics.items():
        category_budget = BUDGETS.get(category, {})
        rows = []
        if isinstance(category_metrics, dict):
            for metric_name, value in category_metrics.items():
                if isinstance(value, (int, float)):
                    metric_value: float | None = float(value)
                else:
                    metric_value = None
                budget_value = category_budget.get(metric_name)
                rows.append(
                    MetricStatus(metric_name, metric_value, budget_value).to_row()
                )
        summary[category] = tuple(rows)
    return summary


def emit_stdout(summary: Dict[str, Tuple[str, ...]]) -> None:
    print("Performance metric summary:")
    for category, rows in summary.items():
        print(f"\n[{category}]")
        if not rows:
            print("  (no numeric metrics reported)")
            continue
        for name, value, budget, status in rows:
            print(f"  - {name}: {value} (budget {budget}) → {status}")


def emit_markdown(summary: Dict[str, Tuple[str, ...]], destination: Path) -> None:
    lines = ["# Performance metrics", "", "| Category | Metric | Value | Budget | Status |", "| --- | --- | --- | --- | --- |"]
    for category, rows in summary.items():
        if not rows:
            lines.append(f"| {category} | _no numeric metrics_ | n/a | n/a | ⚪ UNKNOWN |")
            continue
        first = True
        for name, value, budget, status in rows:
            category_cell = category if first else ""
            first = False
            lines.append(f"| {category_cell} | {name} | {value} | {budget} | {status} |")
    destination.write_text("\n".join(lines) + "\n", encoding="utf-8")


def emit_json(metrics: Dict[str, Any], destination: Path) -> None:
    destination.write_text(json.dumps(metrics, indent=2), encoding="utf-8")


def parse_args(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, type=Path, help="Path to the raw Flutter test output")
    parser.add_argument(
        "--markdown-output",
        type=Path,
        help="Optional path to write a Markdown summary table",
    )
    parser.add_argument(
        "--json-output",
        type=Path,
        help="Optional path to write the parsed metrics as JSON",
    )
    return parser.parse_args(list(argv))


def main(argv: Iterable[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    metrics = load_metrics(args.input)
    summary = build_status(metrics)
    emit_stdout(summary)
    if args.markdown_output:
        emit_markdown(summary, args.markdown_output)
    if args.json_output:
        emit_json(metrics, args.json_output)
    return 0


if __name__ == "__main__":
    sys.exit(main())
